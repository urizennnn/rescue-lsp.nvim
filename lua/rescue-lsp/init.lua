local buf = vim.api.nvim_create_buf(false, true)
vim.api.nvim_buf_set_lines(buf, 0, -1, false, { "Hello from Lua!" })

local win_width = vim.api.nvim_win_get_width(0)
local win_height = vim.api.nvim_win_get_height(0)

local width = 40
local height = 10
local row = math.floor((win_height - height) / 2)
local col = math.floor((win_width - width) / 2)

local opts = {
    relative = "win",
    width = width,
    height = height,
    row = row,
    col = col,
    style = "minimal",
    border = "rounded"
}

vim.api.nvim_open_win(buf, true, opts)

