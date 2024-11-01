local cmd = require "rescue-lsp.cmd.cmd"
local highlight = require "rescue-lsp.colors.highlight"
local init ={}

highlight.setup()
cmd.commands()
function init.setup()
    print("I am yet to add setup/configs")
end

return init
