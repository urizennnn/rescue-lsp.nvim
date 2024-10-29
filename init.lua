local buf = vim.api.nvim_create_buf(false, true)  
vim.api.nvim_buf_set_lines(buf, 0, -1, false, { "Hello from Lua!" })



local opts = {
    relative = "win",
    width = 40,
    height = 10,
    row = 5,
    col = 10,
    style = "minimal",
    border = "rounded"
}

vim.api.nvim_open_win(buf, true, opts)
