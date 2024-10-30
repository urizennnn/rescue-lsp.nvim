local window = require "rescue-lsp.window.window"
local M = {}
function M.commands()
vim.api.nvim_create_user_command("Rescue", function()
        window.draw_win()
  print("This code runs after :LspInfo!")
end, {})
vim.api.nvim_create_user_command("RescueClose", function()
        vim.api.nvim_buf_delete(0, { force = true })
    end, {})

end


return M
