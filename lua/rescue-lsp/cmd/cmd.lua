--- This module is responsible for creating the commands that will be used in the plugin.
-- @module cmd
local window = require "rescue-lsp.window.window"
local M = {}
function M.commands(opts)
vim.api.nvim_create_user_command("Rescue", function()
        window.draw_win(opts)
end, {})
vim.api.nvim_create_user_command("RescueClose", function()
        vim.api.nvim_buf_delete(0, { force = true })
    end, {})

end


return M
