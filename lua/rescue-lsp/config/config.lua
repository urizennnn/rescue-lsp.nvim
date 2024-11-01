local config = {}

config.defaults = {
    Lsp = {
        commands ={
            LspInfo = false,
            LspRestart=false,
            LspStart = false,
            LspStop = false,
        },
        find_lsp_servers=nil,
    },
    window ={
        win_height = 30,
        win_width = 170,
        win_row = 10,
        win_col = 35,
        border = "rounded",
        relative = "editor",
    }
}

return config
