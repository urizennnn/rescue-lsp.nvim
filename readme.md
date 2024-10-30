<div align="center">
    <h1>Rescue-Lsp</hjson</h1>
</div>

[![Lua](https://img.shields.io/badge/Lua-5.1%20|%205.3%20|%205.4-blue.svg)](https://www.lua.org)
[![License](https://img.shields.io/badge/license-MIT-green.svg)](https://opensource.org/licenses/MIT)
[![Neovim](https://img.shields.io/badge/Neovim-0.10.2%2B-blue.svg)](https://github.com/neovim/neovim)
[![GitHub contributors](https://img.shields.io/github/contributors/urizennnn/zync)](https://github.com/urizennnn/zync/graphs/contributors)


## Aim
Rescue-Lsp is a drop-in replacement for some features of the lspconfig plugin. As at the make of the readme the ```LspInfo``` command opens up a new tab and shows explicit data of ``` 
:checkhealth``` in Neovim. The problem with this is that, there are too much unecessary data. So I wanna use this and create the same floating window just to bring that aesthetic back.

## Other ways
Alternatively you could just install the lspconfig version that had that but you might miss out on any improvements or breaking changes.


## Known bugs
- [x] The text in the floating windows doesn't fit (yet).

## Todo
- [ ] Add options to the setup function.
- [ ] Add text highlighting.
- [ ] Apply proper text wrapping and text formatting to the window.
- [ ] just have a config field that lets you set a function, which you then use to fetch the info for the LSPs that are not active.
And just default to something that gets it from lspconfig.
Then people can just write their own when they use something special.
(And disable it by setting it to false)
