--- This module is responsible for creating the commands that will be used in the plugin.
--- @module cmd
local window = require "rescue-lsp.window.window"
local lsp_plugin = require "rescue-lsp.window.lsp"
local M = {}
function M.commands(opts)
	vim.api.nvim_create_user_command("Rescue", function()
		window.draw_win(opts)
	end, {})
	vim.api.nvim_create_user_command("RescueClose", function()
		vim.api.nvim_buf_delete(0, { force = true })
	end, {})
end

function M.lsp_cmd()
	vim.api.nvim_create_user_command("RescueStart", function()
		lsp_plugin.start_lsp()
	end, {})

	vim.api.nvim_create_user_command("RescueStop", function()
		lsp_plugin.stop_lsp()
	end, {})

	vim.api.nvim_create_user_command("RescueRestart", function()
		vim.cmd("RescueStart")
		vim.cmd("RescueStop")
	end, {})
end

return M
