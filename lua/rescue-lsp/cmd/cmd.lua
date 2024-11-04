local window = require "rescue-lsp.window.window"
local lsp_plugin = require "rescue-lsp.window.lsp"
local lsp = require "rescue-lsp.window.lsp"

local M = {}

--- Creates user commands for opening and closing the Rescue window.
--- @alias opts table
--- @type opts function|opts
--- @param opts table: Options for drawing the window.
function M.commands(opts)
	-- Define the "Rescue" command to open the Rescue window.
	vim.api.nvim_create_user_command("Rescue", function()
		window.draw_win(opts)
	end, {})

	-- Define the "RescueClose" command to close the Rescue window.
	vim.api.nvim_create_user_command("RescueClose", function()
		vim.api.nvim_buf_delete(0, { force = true })
	end, {})
end

--- Creates user commands for managing the Rescue LSP client.
--- Defines commands to start, stop, and restart the LSP client.
function M.lsp_cmd()
	-- Define the "RescueStart" command to start the LSP client.
	vim.api.nvim_create_user_command("RescueStart", function()
		lsp_plugin.start_lsp()
	end, {})

	-- Define the "RescueStop" command to stop the LSP client.
	vim.api.nvim_create_user_command("RescueStop", function()
		lsp_plugin.stop_lsp()
	end, {})

	-- Define the "RescueRestart" command to restart the LSP client.
	vim.api.nvim_create_user_command("RescueRestart", function()
		lsp_plugin.restart_lsp()
	end, {})
end

function M.autocmd_group()
	vim.api.nvim_create_augroup("StopLsp", { clear = true })

	-- Stop LSP client on buffer enter
	vim.api.nvim_create_autocmd({ "BufEnter", "LspAttach" }, {
		group = "StopLsp",
		pattern = "*",
		callback = function()
			local lsp_table = lsp.stopped_clients
			local clients = vim.lsp.get_clients({ bufnr = vim.api.nvim_get_current_buf() })

			for _, client in ipairs(clients) do
				for _, value in ipairs(lsp_table) do
					if value.name == client.name then
						vim.lsp.stop_client(client.id, true)
					end
				end
			end
		end,
	})
end
return M
