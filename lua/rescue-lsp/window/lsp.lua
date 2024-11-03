local custom_lsp = {}

-- Start any LSP client, even if it's already running
function custom_lsp.start_lsp()
	local filetype = vim.bo.filetype
	local lspconfig = require("lspconfig")
	local configured_servers = {}

	-- Get all configured LSP servers for the filetype
	for server, config in pairs(lspconfig) do
		print(type(config))
		if config.filetypes then
			if vim.tbl_contains(config.filetypes, filetype) then
				table.insert(configured_servers, server)
			end
		end
	end

	if #configured_servers == 0 then
		vim.notify("No LSP configured for this filetype.", vim.log.levels.INFO)
		return
	end

	vim.ui.select(configured_servers, {
		prompt = "Select an LSP to start:",
	}, function(choice)
		if choice then
			lspconfig[choice].setup {} -- Start the selected LSP
			vim.notify("Starting LSP client: " .. choice, vim.log.levels.INFO)
		end
	end)
end

-- Stop all currently running LSP clients for the buffer
function custom_lsp.stop_lsp()
	local buf_id = vim.api.nvim_get_current_buf()
	local active_clients = vim.lsp.get_clients({ bufnr = buf_id })

	if #active_clients == 0 then
		vim.notify("No active LSP clients found for this buffer.", vim.log.levels.INFO)
		return
	end

	vim.ui.select(
		vim.tbl_map(function(client)
			return client.name
		end, active_clients),
		{
			prompt = "Select an LSP to stop:",
		},
		function(choice)
			if choice then
				for _, client in ipairs(active_clients) do
					if client.name == choice then
						vim.lsp.stop_client(client.id, true)
						vim.notify("Stopped LSP client: " .. client.name, vim.log.levels.INFO)
						break
					end
				end
			end
		end
	)
end

return custom_lsp
