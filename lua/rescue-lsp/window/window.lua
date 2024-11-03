local utils = require "rescue-lsp.utility.utils"
local win = {}
win.INSPECT = vim.inspect

function win.draw_win(setup)
	local previous_buf_id = vim.api.nvim_get_current_buf()
	local buf = vim.api.nvim_create_buf(false, true)
	-- local current_win_id = vim.api.nvim_get_current_win()
	local title = "LSP Client Info:"
	local centered_title = string.rep(" ", math.floor((setup.window.win_width - #title) / 2)) .. title
	vim.api.nvim_buf_set_lines(buf, 0, -1, false, { centered_title })

	local opts = {
		relative = setup.window.relative,
		width = tonumber(setup.window.win_width),
		height = tonumber(setup.window.win_height),
		row = tonumber(setup.window.win_row),
		col = tonumber(setup.window.win_col),
		style = "minimal",
		border = setup.window.border,
	}

	vim.api.nvim_open_win(buf, true, opts)
	vim.api.nvim_buf_add_highlight(buf, -1, "BlueText", 0, 0, -1)
	win.insert_into_buf(buf, previous_buf_id, setup)
	vim.bo[buf].buftype = "nofile"
	vim.bo[buf].readonly = true
	vim.bo[buf].modifiable = false
	-- vim.wo[current_win_id].wrap = false
	-- vim.wo[current_win_id].sidescrolloff = 0
	vim.api.nvim_buf_set_keymap(buf, "n", "q", "<cmd>q<CR>", { noremap = true, silent = true })
end

function win.insert_into_buf(buf, prev_buf_id, setup)
	local clients = vim.lsp.get_clients({ buffer = buf })
	local all_clients = vim.lsp.get_clients()
	local lines = {}
	local client_count = #clients
	local deprecated_clients = {}

	local function center_text(text, width)
		local pad = math.max(0, math.floor((width - #text) / 2))
		return string.rep(" ", pad) .. text
	end

	local width = vim.api.nvim_win_get_width(0)

	for _, client in ipairs(all_clients) do
		local status = utils.is_lsp_deprecated(client.name)
		if status == "true" then
			table.insert(deprecated_clients, client.name)
		end
	end

	if #deprecated_clients > 0 then
		table.insert(lines, center_text("Deprecated LSP clients found: " .. table.concat(deprecated_clients, ", "), width))
	else
		table.insert(lines, center_text("No deprecated LSP clients found.", width))
	end

	local client_count_index = #lines + 1
	table.insert(lines, center_text(client_count .. " client(s) active", width))

	local lsp_view_info = win.lsp_info(buf, prev_buf_id)
	for _, info in ipairs(lsp_view_info) do
		table.insert(lines, info)
	end

	table.insert(lines, string.rep("-", 100))

	for _, client in ipairs(clients) do
		local buffer_ids = {}
		for buffer_id, _ in pairs(client.attached_buffers) do
			table.insert(buffer_ids, buffer_id)
		end

		table.insert(
			lines,
			"   Client: " .. client.name .. " (id: " .. client.id .. ", bufnr: [" .. table.concat(buffer_ids, ", ") .. "])"
		)
		utils.highlight_copilot_text(client.name)
		table.insert(lines, "     root directory:    " .. (client.config.root_dir or "running in single file mode"))
		table.insert(lines, "     filetypes:         " .. table.concat(client.config.filetypes or {}, ", "))

		if type(client.config.filetypes) == "table" then
			vim.api.nvim_buf_add_highlight(buf, -1, "GreenText", #lines, 24, 24 + #client.config.filetypes)
		end

		table.insert(lines, "     cmd:               " .. table.concat(client.config.cmd or {}, " "))
		vim.api.nvim_buf_add_highlight(buf, -1, "GreyBG", #lines, 23, 23 + #client.config.cmd)

		local version_output
		if client.name == "gopls" then
			version_output = vim.fn.system(client.config.cmd[1] .. " version")
		else
			version_output = vim.fn.system(client.config.cmd[1] .. " --version")
		end
		local single_version_line = version_output:gsub("\n", " ")
		table.insert(lines, "     version:           " .. single_version_line)
		vim.api.nvim_buf_add_highlight(buf, -1, "GreyBG", #lines, 24, 24 + #single_version_line)

		local executable = client.config.cmd and vim.fn.executable(client.config.cmd[1]) == 1
		table.insert(lines, "     executable:        " .. tostring(executable))

		pcall(function()
			vim.api.nvim_buf_add_highlight(buf, -1, "GreyBG", #lines, 0, -1)
		end)

		table.insert(lines, "     autostart:         " .. tostring(client.config.autostart or false))
		table.insert(lines, "------")
	end

	table.insert(lines, string.rep("-", 100))

	table.insert(lines, "LSP configs active in this session (globally):")
	local lsp_servers = nil or {}
	if type(setup) == "table" and setup.Lsp and type(setup.Lsp.find_lsp_servers) == "function" then
		_, lsp_servers = pcall(setup.Lsp.find_lsp_servers)
	elseif type(win.list_all_lsp_servers) == "function" then
		_, lsp_servers = pcall(win.list_all_lsp_servers)
	else
		lsp_servers = { "No LSP servers available" }
	end
	table.insert(lines, table.concat(lsp_servers, ", "))
	vim.api.nvim_buf_set_lines(buf, 1, -1, false, lines)

	pcall(function()
		vim.api.nvim_buf_add_highlight(buf, -1, client_count > 0 and "GreenText" or "RedText", client_count_index, 0, -1)
	end)
	pcall(function()
		vim.api.nvim_buf_add_highlight(buf, -1, "LightBlueText", #lines - 1, 0, -1)
	end)
end

function win.list_all_lsp_servers()
	local lspconfig = require("lspconfig")
	local mason_registry = require("mason-registry")
	local lines = {}

	local server_names = {}

	for server_name, _ in pairs(lspconfig) do
		if type(lspconfig[server_name]) == "table" and lspconfig[server_name].setup then
			table.insert(server_names, server_name)
		end
	end

	for _, package in ipairs(mason_registry.get_installed_packages()) do
		if package.spec.categories[1] == "LSP" then
			table.insert(server_names, package.name)
		end
	end

	if #server_names > 0 then
		table.insert(lines, table.concat(server_names, ", "))
	else
		table.insert(lines, "No LSP servers found.")
	end

	return lines
end

function win.lsp_info(buf, buf_id)
	local log_path = vim.lsp.get_log_path()
	local lines = {}
	local file_type = vim.bo[buf_id].filetype

	table.insert(lines, "INFO")
	pcall(function()
		vim.api.nvim_buf_add_highlight(buf, -1, "BoldText", #lines, 0, 0)
	end)

	table.insert(lines, "-  Client LSP Log File: " .. log_path)
	table.insert(lines, "-  Detected File Type: " .. file_type)
	return lines
end

return win
