-- init.lua - Main Neovim configuration entry point


vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1

if vim.g.vscode then
    -- VSCode Neovim extension
    require('config.vscode')
else
    -- Regular Neovim
    require('config.options')
    require('config.keymaps')
    require('config.plugins')
    require('config.autocmds')
    require('config.repl-config').setup()
end
