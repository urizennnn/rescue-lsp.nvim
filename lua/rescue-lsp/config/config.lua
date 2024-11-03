local config = {}

---Configuration options for the LSP-related settings.
---@class LspConfig
---@field commands_override boolean If true, allows custom commands to override default LSP commands.
---@field find_lsp_servers function|nil Function or command to locate available LSP servers.

---Configuration options for the window display settings.
---@class WindowConfig
---@field win_height number Height of the floating window.
---@field win_width number Width of the floating window.
---@field win_row number Row position of the floating window.
---@field win_col number Column position of the floating window.
---@field border string Border style of the floating window (e.g., "rounded", "single").
---@field relative string Positioning type for the window (e.g., "editor", "cursor").

---Main configuration structure.
---@class Config
---@field Lsp LspConfig
---@field window WindowConfig
config.defaults = {
	Lsp = {
		commands_override = false,
		find_lsp_servers = nil,
	},
	window = {
		win_height = 30,
		win_width = 170,
		win_row = 10,
		win_col = 35,
		border = "rounded",
		relative = "editor",
	},
}
---Merge user configuration with defaults.
---@param user_config Config? User-provided configuration to override defaults.
---@return Config
function config.setup(user_config)
	local final_config = vim.tbl_deep_extend("force", config.defaults, user_config or {})
	return final_config
end

---Validate the provided config to ensure all options are correctly set.
---@param conf Config The configuration to validate.
---@return boolean, string|nil Returns true if valid, otherwise false and an error message.
function config.validate(conf)
	if type(conf.Lsp.commands_override) ~= "boolean" then
		return false, "Lsp.commands_override must be a boolean."
	end
	if conf.Lsp.find_lsp_servers ~= nil and type(conf.Lsp.find_lsp_servers) ~= "function" then
		return false, "Lsp.find_lsp_servers must be a function or nil."
	end
	if type(conf.window.win_height) ~= "number" then
		return false, "window.win_height must be a number."
	end
	if type(conf.window.win_width) ~= "number" then
		return false, "window.win_width must be a number."
	end
	-- Additional validations can be added here
	return true
end
return config
