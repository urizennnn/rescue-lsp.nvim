local utils = {}
function utils.highlight_copilot_text(client_name)
	local ns_id = vim.api.nvim_create_namespace("Client")
	local bufnr = vim.api.nvim_get_current_buf()
	local search_text = client_name

	vim.api.nvim_buf_clear_namespace(bufnr, ns_id, 0, -1)

	for line_nr = 0, vim.api.nvim_buf_line_count(bufnr) - 1 do
		local line = vim.api.nvim_buf_get_lines(bufnr, line_nr, line_nr + 1, false)[1]
		local start_col = line:find(search_text)

		if start_col then
			local end_col = start_col + #search_text
			vim.api.nvim_buf_add_highlight(bufnr, ns_id, "GreentText", line_nr, start_col - 1, end_col - 1)
		end
	end
end

function utils.is_lsp_deprecated(client_name)
	local doc_files = vim.api.nvim_get_runtime_file("doc/*.txt", true)
	for _, file in ipairs(doc_files) do
		local lines = vim.fn.readfile(file)
		for _, line in ipairs(lines) do
			if line:find(client_name) and line:find("deprecated") then
				return true
			end
		end
	end
	return false
end

return utils
