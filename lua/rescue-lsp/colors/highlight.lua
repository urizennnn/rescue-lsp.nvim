local highlight = {}

function highlight.setup()
	vim.api.nvim_set_hl(0, "LightBlueText", { fg = "#87CEFA" })
	vim.api.nvim_set_hl(0, "BlueText", { fg = "#5fd7ff", bg = "NONE", bold = true })
	vim.api.nvim_set_hl(0, "GreenText", { fg = "#32CD32" })
	vim.api.nvim_set_hl(0, "RedText", { fg = "#FF6347" })
	vim.api.nvim_set_hl(0, "GreyBG", { fg = "#808080" })
	vim.api.nvim_set_hl(0, "ClientHighlight", { fg = "#61AFEF", bg = "#282C34", bold = true })
	vim.api.nvim_set_hl(0, "BoldText", { bold = true })
end

return highlight
