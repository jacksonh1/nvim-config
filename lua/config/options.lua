-- config/options.lua - Basic Neovim settings

local opt = vim.opt
local g = vim.g

-- Python host program
g.python3_host_prog = '/Users/jackson/miniforge3/bin/python'

-- Disable Vi compatibility
opt.compatible = false

-- Enable true color support
opt.termguicolors = true

-- Enable syntax highlighting
vim.cmd('syntax enable')

-- Leader key
g.mapleader = ' '

-- Mouse support
opt.mouse = 'a'

-- Search settings
opt.ignorecase = true
opt.smartcase = true
opt.hlsearch = true
opt.wildmenu = true
opt.wildignore:append({'*/.git/*', '*/tmp/*', '*.swp'})

-- Line numbers
opt.number = true
opt.relativenumber = true

-- Scrolling
opt.scrolloff = 7

-- Line wrapping
opt.linebreak = true

-- Status line
opt.laststatus = 2

-- Backspace behavior
opt.backspace = {'indent', 'eol', 'start'}

-- Disable bells
opt.errorbells = false
opt.visualbell = true

-- Show commands
opt.showcmd = true

-- Tab settings
opt.tabstop = 4
opt.softtabstop = 4
opt.shiftwidth = 4
opt.expandtab = true

-- Split settings
opt.splitright = true

-- Indentation
opt.autoindent = true

-- Show matching brackets
opt.showmatch = true

-- Enable Python syntax highlighting
g.python_highlight_all = 1

-- Folding
opt.foldenable = true
opt.foldlevelstart = 99
opt.foldnestmax = 10
opt.foldmethod = 'indent'
opt.foldlevel = 99           -- Start with all folds open

-- List characters
opt.listchars = {tab = '>-', trail = '_'}
opt.list = true

-- Clipboard
opt.clipboard = 'unnamedplus'

-- Update time for plugins
opt.updatetime = 300

-- Cursor line/column (for regular neovim)
opt.cursorline = true
opt.cursorcolumn = true

-- Sign column
if vim.fn.has('nvim-0.5.0') == 1 or vim.fn.has('patch-8.1.1564') == 1 then
    opt.signcolumn = 'number'
else
    opt.signcolumn = 'yes'
end

-- Encoding
opt.encoding = 'utf-8'

-- Hidden buffers
opt.hidden = true

-- Backup settings
opt.backup = false
opt.writebackup = false

-- Command height (commented out as it was in original)
-- opt.cmdheight = 2

-- Short messages
opt.shortmess:append('c')
