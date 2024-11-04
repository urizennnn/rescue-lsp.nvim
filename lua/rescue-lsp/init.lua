local cmd = require "rescue-lsp.cmd.cmd"
local highlight = require "rescue-lsp.colors.highlight"
local config = require "rescue-lsp.config.config"
local init = {}

--- Initialize the rescue-lsp plugin with user-provided options.
--- @class Init
--- @field setup function The function to set up the plugin with optional configurations.
--- @param opts Config? Optional user-provided configuration to override defaults.
function init.setup(opts)
	-- Merge user options with defaults
	local setup = config.setup(opts)

	-- Validate the final configuration; if invalid, raise an error with a detailed message
	local is_valid, validation_error = config.validate(setup)
	if not is_valid then
		vim.notify("Invalid configuration provided: " .. (validation_error or "unknown error"), vim.log.levels.ERROR)
	end

	-- Apply highlight settings based on the config
	highlight.setup()

	-- Set up commands and LSP configuration with the finalized settings
	cmd.commands(setup)
	if setup.Lsp.commands_override then
		vim.notify("commands_override not implemented for this verison", vim.log.levels.WARN)
	end
	cmd.lsp_cmd()
	cmd.autocmd_group()
end

return init
