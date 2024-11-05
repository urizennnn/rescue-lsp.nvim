local help = {}

function help.generate_help()
	local script_path = debug.getinfo(1, "S").source:sub(2)
	local plugin_dir = vim.fn.fnamemodify(script_path, ":h:h")

	vim.cmd("helptags " .. plugin_dir .. "/doc")
end

return help
