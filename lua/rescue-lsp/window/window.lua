local win = {}

function win.draw_win()
    local buf = vim.api.nvim_create_buf(false, true)
    vim.api.nvim_buf_set_lines(buf, 0, -1, false, { "LSP Client Info:" })

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
        border = "rounded",
    }

    vim.api.nvim_open_win(buf, true, opts)
    win.insert_into_buf(buf)
    vim.api.nvim_buf_set_keymap(buf, "n", "q", "<cmd>q<CR>", { noremap = true, silent = true })
end

function win.insert_into_buf(buf)
    local clients = vim.lsp.get_active_clients()
    local lines = {}

    for _, client in ipairs(clients) do
        table.insert(lines, "Client Name: " .. client.name)
        table.insert(lines, "Root Directory: " .. (client.config.root_dir or "N/A"))

        -- Split capabilities output into individual lines
        local capabilities_lines = vim.split(vim.inspect(client.server_capabilities), "\n", { plain = true })
        table.insert(lines, "Capabilities:")
        vim.list_extend(lines, capabilities_lines)  -- Adds each line separately

        table.insert(lines, "------")
    end

    if #clients == 0 then
        table.insert(lines, "No active LSP clients found.")
    end

    vim.api.nvim_buf_set_lines(buf, 1, -1, false, lines)
end

return win

