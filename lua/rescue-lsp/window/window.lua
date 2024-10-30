local win = {}

function win.draw_win()
    local buf = vim.api.nvim_create_buf(false, true)
    vim.api.nvim_buf_set_lines(buf, 0, -1, false, { "LSP Client Info:" })

    local editor_width = vim.o.columns
    local editor_height = vim.o.lines
    local width = 150
    local height = 30
    local row = math.floor((editor_height - height) / 2)
    local col = math.floor((editor_width - width) / 2)

    local opts = {
        relative = "editor",
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
    local clients = vim.lsp.get_clients({ buffer = buf })
    local all_clients = vim.lsp.get_clients()
    local lines = {}
    local client_count = #clients
    local deprecated_clients = {}

    for _, client in ipairs(all_clients) do
        if client.deprecated then
            table.insert(deprecated_clients, client.name)
        end
    end

    if #deprecated_clients > 0 then
        table.insert(lines, "   Deprecated LSP clients found: " .. table.concat(deprecated_clients, ", "))
    else
        table.insert(lines, "   No deprecated LSP clients found.")
    end

    table.insert(lines, "   LSP configs active in this buffer (bufnr: " .. buf .. ")")
    table.insert(lines, client_count .. " client(s) active")

    for _, client in ipairs(clients) do
        local buffer_ids = {}
        for buffer_id, _ in pairs(client.attached_buffers) do
            table.insert(buffer_ids, buffer_id)
        end

        table.insert(lines, "   Client: `" .. client.name .. "` (id: " .. client.id .. ", bufnr: [" .. table.concat(buffer_ids, ", ") .. "])")
        table.insert(lines, "     root directory:    " .. (client.config.root_dir or "running in single file mode"))
        table.insert(lines, "     filetypes:         " .. table.concat(client.config.filetypes or {}, ", "))
        table.insert(lines, "     cmd:               " .. table.concat(client.config.cmd or {}, " "))

        local version_output = vim.fn.system(client.config.cmd[1] .. " --version")
        local single_version_line = version_output:gsub("\n", " ")
        table.insert(lines, "     version:           " .. single_version_line)

        local executable = client.config.cmd and vim.fn.executable(client.config.cmd[1]) == 1
        table.insert(lines, "     executable:        " .. tostring(executable))
        table.insert(lines, "     autostart:         " .. tostring(client.config.autostart or false))

        table.insert(lines, "------")
    end

    if #lines == 0 then
        table.insert(lines, "   No active LSP clients found.")
    end

    table.insert(lines, "   LSP configs active in this session (globally):")

    -- Add combined server list to lines as a single line
    local lsp_servers = win.list_all_lsp_servers()
    for _, server_line in ipairs(lsp_servers) do
        table.insert(lines, server_line)
    end

    vim.api.nvim_buf_set_lines(buf, 1, -1, false, lines)
end



function win.list_all_lsp_servers()
    local lspconfig = require("lspconfig")
    local mason_registry = require("mason-registry")
    local lines = {}

    local server_names = {}

    -- Gather configured servers
    for server_name, _ in pairs(lspconfig) do
        if type(lspconfig[server_name]) == "table" and lspconfig[server_name].setup then
            table.insert(server_names,  server_name)
        end
    end

    -- Gather installed servers
    for _, package in ipairs(mason_registry.get_installed_packages()) do
        if package.spec.categories[1] == "LSP" then
            table.insert(server_names,  package.name)
        end
    end

    -- Combine all server names into a single line
    if #server_names > 0 then
        table.insert(lines, table.concat(server_names, ", "))
    else
        table.insert(lines, "No LSP servers found.")
    end

    return lines    
end

return win
