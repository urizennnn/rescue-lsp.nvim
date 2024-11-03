local custom_lsp = {}
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

		-- Start the LSP client using its original configuration
		vim.lsp.start({
			name = choice.name,
			cmd = choice.config.cmd,
			root_dir = choice.config.root_dir,
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

		-- Stop the selected LSP client and add it to `stopped_clients`
		vim.lsp.stop_client(choice.id)
		vim.notify("Stopped LSP client: " .. choice.name, vim.log.levels.INFO)

		-- Store stopped client for potential restart
		table.insert(custom_lsp.stopped_clients, {
			name = choice.name,
			config = {
				cmd = choice.config.cmd,
				root_dir = choice.config.root_dir,
			},
		})
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
