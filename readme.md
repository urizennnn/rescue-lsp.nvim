```markdown
<div align="center">
    <h1>Rescue-Lsp.nvim</h1>
</div>

[![Lua](https://img.shields.io/badge/Lua-5.1%20|%205.3%20|%205.4-blue.svg)](https://www.lua.org)
[![License](https://img.shields.io/badge/license-MIT-green.svg)](https://opensource.org/licenses/MIT)
[![Neovim](https://img.shields.io/badge/Neovim-0.10.2%2B-blue.svg)](https://github.com/neovim/neovim)
[![GitHub contributors](https://img.shields.io/github/contributors/urizennnn/zync)](https://github.com/urizennnn/zync/graphs/contributors)

## Overview

**Rescue-Lsp.nvim** provides an aesthetic, floating window replacement for the `LspInfo` command, minimizing extraneous details displayed by Neovim’s native `:checkhealth` output. The goal is a cleaner, focused presentation of LSP status while offering a user-friendly interface to manage LSP clients.

### Preview

![Rescue-Lsp Preview](https://raw.githubusercontent.com/urizennnn/rescue-lsp.nvim/master/media/preview.png)

### Why Use Rescue-Lsp.nvim?
The native `LspInfo` command opens a new tab with verbose information that may be unnecessary for many users. **Rescue-Lsp.nvim** provides a minimal floating window that aligns better with streamlined workflows while giving a similar aesthetic to previous versions of `lspconfig`.

### Requirements
- **Neovim**: 0.10.2+

## Installation

### Using [lazy.nvim](https://github.com/folke/lazy.nvim)
```lua
{
    "urizennnn/rescue-lsp.nvim",
    config = function()
        require("rescue-lsp").setup()
    end
}
```

### Using [vim-plug](https://github.com/junegunn/vim-plug)
```vim
Plug "urizennnn/rescue-lsp.nvim"
```

### Using [Packer](https://github.com/wbthomason/packer.nvim)
```lua
use {
    "urizennnn/rescue-lsp.nvim",
    config = function()
        require("rescue-lsp").setup()
    end
}
```

## Configuration

Rescue-Lsp provides the following default configuration options:

```lua
require("rescue-lsp").setup({
    Lsp = {
        commands_override = false,
        find_lsp_servers = nil, -- Custom function for non-lspconfig/mason users to return a table of LSPs
    },
    window = {
        win_height = 30,
        win_width = 170,
        win_row = 10,
        win_col = 35,
        border = "rounded",
        relative = "editor",
    }
})
```

### Example Custom Configuration
```lua
require("rescue-lsp").setup({
    Lsp = {
        commands_override = true,
        find_lsp_servers = function()
            -- Custom logic to return available LSPs
        end,
    },
    window = {
        win_height = 25,
        win_width = 150,
        border = "single",
    }
})
```

## Commands

- **`:Rescue`** - Opens the LSP status window in a floating format.
- **`:RescueClose`** - Closes the floating LSP status window (can also use `q` key).
- **`:RescueStart`** - Opens a selection UI to choose and start or restart an LSP.
- **`RescueStop`** - Opens a selection UI to choose and stop an active LSP.
- **`RescueRestart`**- Opens a selection UI to choose which LSP to restart

## Known Issues

- [x] Text in floating windows may not fit perfectly yet.
- [ ] Highlight groups might not apply to all custom strings.

## Todo

- [x] Add customizable setup options.
- [x] Support text highlighting.
- [x] Implement text wrapping and formatting in the floating window.
- [x] Allow users to provide a custom function to fetch inactive LSP details if not using `lspconfig`.

---

**License**: MIT
