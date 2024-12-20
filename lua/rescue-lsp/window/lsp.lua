--- @type table
local custom_lsp = {}
--- @type table<string, {name: string, config: {cmd: string, root_dir: string}}>
custom_lsp.stopped_clients = {}

--- Starts a previously stopped LSP client.
--- Prompts the user to select an LSP client to start if multiple clients are available.
--- Displays a message if no stopped LSP clients are available.
function custom_lsp.start_lsp()
	if #custom_lsp.stopped_clients == 0 then
		vim.notify("No stopped LSP clients to start.", vim.log.levels.INFO)
		return
	end

	vim.ui.select(custom_lsp.stopped_clients, {
		prompt = "Select an LSP to start:",
		format_item = function(item)
			return "Start LSP: " .. item.name
		end,
	}, function(choice)
		if not choice then
			vim.notify("No LSP client selected.", vim.log.levels.WARN)
			return
		end

		-- Start the LSP client with `on_init` callback for buffer-specific setups
		vim.lsp.start({
			name = choice.name,
			cmd = choice.config.cmd,
			root_dir = choice.config.root_dir,
			auto_start = choice.config.autostart or false,
			on_init = function(client)
				vim.notify("LSP client initialized: " .. client.name, vim.log.levels.INFO)

				-- Example of buffer-specific settings
				local bufnr = vim.api.nvim_get_current_buf()

				-- Enable completion triggered by <C-x><C-o>
				vim.bo[bufnr].omnifunc = "v:lua.vim.lsp.omnifunc"
			end,
		})

		vim.notify("Started LSP client: " .. choice.name, vim.log.levels.INFO)
	end)
end

--- Stops an active LSP client for the current buffer.
--- Prompts the user to select an LSP client to stop if multiple clients are active.
--- Displays a message if no active LSP clients are found for the buffer.
function custom_lsp.stop_lsp()
	local clients = vim.lsp.get_clients({ bufnr = vim.api.nvim_get_current_buf() })
	if #clients == 0 then
		vim.notify("No active LSP clients for this buffer.", vim.log.levels.INFO)
		return
	end

	vim.ui.select(clients, {
		prompt = "Select an LSP to stop:",
		format_item = function(client)
			return "Stop LSP: " .. client.name
		end,
	}, function(choice)
		if not choice then
			vim.notify("No LSP client selected.", vim.log.levels.WARN)
			return
		end

		-- Stop the selected LSP client
		vim.lsp.stop_client(choice.id, true)
		vim.notify("Stopped LSP client: " .. choice.name, vim.log.levels.INFO)

		-- Check if the client is already in stopped_clients
		local already_stopped = false
		for _, value in ipairs(custom_lsp.stopped_clients) do
			if value.name == choice.name then
				already_stopped = true
				break
			end
		end

		-- Store stopped client for potential restart only if it is not already stopped
		if not already_stopped then
			table.insert(custom_lsp.stopped_clients, {
				name = choice.name,
				config = {
					cmd = choice.config.cmd,
					root_dir = choice.config.root_dir,
				},
			})
		end
	end)
end

--- Restarts an active LSP client for the current buffer.
--- Prompts the user to select an LSP client to restart if multiple clients are active.
--- Displays a message if no active LSP clients are found.
function custom_lsp.restart_lsp()
	local clients = vim.lsp.get_clients({ bufnr = vim.api.nvim_get_current_buf() })
	if #clients == 0 then
		vim.notify("No active LSP clients for this buffer.", vim.log.levels.INFO)
		return
	end

	vim.ui.select(clients, {
		prompt = "Select an LSP to restart:",
		format_item = function(client)
			return "Restart LSP: " .. client.name
		end,
	}, function(choice)
		if not choice then
			vim.notify("No LSP client selected.", vim.log.levels.WARN)
			return
		end

		-- Stop the selected LSP client
		vim.lsp.stop_client(choice.id)

		-- Restart the client with its original configuration
		vim.lsp.start({
			name = choice.name,
			cmd = choice.config.cmd,
			root_dir = choice.config.root_dir,
		})
		vim.notify("Restarted LSP client: " .. choice.name, vim.log.levels.INFO)
	end)
end

return custom_lsp
