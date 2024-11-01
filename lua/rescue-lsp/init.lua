local cmd = require "rescue-lsp.cmd.cmd"
local highlight = require "rescue-lsp.colors.highlight"
local config    = require "rescue-lsp.config.config"
local init ={}

function init.setup(opts)
    config.join= vim.tbl_deep_extend("force",config.defaults,opts or {})
    highlight.setup()
    print("This is the config\n")
    cmd.commands(config.join)
end

return init
