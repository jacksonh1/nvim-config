-- config/vscode.lua - VSCode Neovim extension configuration

local keymap = vim.keymap.set

-- Leader key
vim.g.mapleader = ' '

-- Basic settings for VSCode
local opt = vim.opt
opt.ignorecase = true
opt.smartcase = true
opt.hlsearch = true
opt.wildmenu = true
opt.wildignore:append({'*/.git/*', '*/tmp/*', '*.swp'})
opt.backspace = {'indent', 'eol', 'start'}
opt.errorbells = false
opt.visualbell = true
opt.showcmd = true
opt.clipboard = 'unnamedplus'

-- Disable cursor line/column for VSCode
opt.cursorline = false
opt.cursorcolumn = false

-- Basic keymaps
keymap('n', '<Leader><Tab>', '<c-^>', { desc = 'Toggle between buffers' })
keymap('n', '<Leader>-', ':sp<CR>', { desc = 'Horizontal split' })
keymap('n', '<Leader>|', ':vsp<CR>', { desc = 'Vertical split' })
keymap('n', '<Leader>w', ':w<CR>', { desc = 'Save' })
keymap('n', '<Leader>q', ':q<CR>', { desc = 'Quit' })
keymap('n', '<Leader>wq', ':wq<CR>', { desc = 'Save and quit' })
keymap('n', '<Leader>Q', ':q!<CR>', { desc = 'Force quit' })
keymap('n', '<Leader><Leader>n', ':tabnew<CR>', { desc = 'New tab' })

-- Search and replace
keymap('n', '<leader>rr', ':%s/\\<<C-r><C-w>\\>//gc<left><left><left>', { desc = 'Replace current word' })

-- VSCode specific commands
keymap('n', '<leader>b', '<Cmd>lua require("vscode").call("workbench.action.quickOpenPreviousRecentlyUsedEditor")<CR>', 
       { desc = 'Quick open recent' })

-- Jupyter/Notebook commands
keymap('n', '<leader><CR>', '<Cmd>lua require("vscode").call("jupyter.runcurrentcelladvance")<CR>', 
       { desc = 'Run current cell and advance' })
keymap({'n', 'v'}, '<leader>i', '<Cmd>lua require("vscode").call("jupyter.execSelectionInteractive")<CR>', 
       { desc = 'Execute selection interactively' })

-- File explorer
keymap('n', '<leader>;', '<Cmd>lua require("vscode").call("workbench.files.action.showActiveFileInExplorer")<CR>', 
       { desc = 'Show file in explorer' })

-- Code navigation
keymap('n', '<leader>cd', '<Cmd>lua require("vscode").call("editor.action.revealDefinition")<CR>', 
       { desc = 'Go to definition' })
keymap('n', '<leader>cD', '<Cmd>lua require("vscode").action("editor.action.revealDefinitionAside")<CR>', 
       { desc = 'Go to definition aside' })
keymap('n', '<leader>cr', '<Cmd>lua require("vscode").call("references-view.findReferences")<CR>', 
       { desc = 'Find references' })

-- Undo/Redo
keymap('n', 'u', '<Cmd>lua require("vscode").call("undo")<CR>', { desc = 'Undo' })
keymap('n', '<C-r>', '<Cmd>lua require("vscode").call("redo")<CR>', { desc = 'Redo' })

-- Commentary mappings
keymap({'x', 'n', 'o'}, 'gc', '<Plug>VSCodeCommentary', { desc = 'Toggle comment' })
keymap('n', 'gcc', '<Plug>VSCodeCommentaryLine', { desc = 'Toggle comment line' })

-- Cell creation macros
keymap('n', '<Leader><Leader>m', 'i# %% [markdown]<Esc>', { desc = 'Insert markdown cell' })
keymap('n', '<Leader>n', 'o# %%<Esc>', { desc = 'Insert code cell' })

-- Movement - move by visual lines
keymap('n', 'j', 'gj', { desc = 'Move down by visual line' })
keymap('n', 'k', 'gk', { desc = 'Move up by visual line' })

-- Jump to start/end of line
keymap({'n', 'v'}, 'H', '^', { desc = 'Jump to start of line' })
keymap({'n', 'v'}, 'L', '$', { desc = 'Jump to end of line' })

-- Indentation in visual mode
keymap('v', '<Tab>', '>', { desc = 'Indent' })
keymap('v', '<S-Tab>', '<', { desc = 'Unindent' })

-- Insert blank lines
keymap('n', '<C-Enter>', 'O<Esc>j', { desc = 'Insert line above' })
keymap('n', '<CR>', 'o<Esc>k', { desc = 'Insert line below' })

-- Disable Q and some mappings
keymap('n', 'Q', '<Nop>')
keymap('i', '<C-u>', '<Nop>')

-- Macros
keymap('n', 'Q', '@q', { desc = 'Apply macro q' })
keymap('v', 'Q', ':norm @q<CR>', { desc = 'Apply macro q to selection' })

-- Load VSCode settings from separate lua file if it exists
pcall(require, 'vscode_settings')
