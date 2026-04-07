-- config/keymaps.lua - Key mappings

local keymap = vim.keymap.set

-- Leader key mappings
keymap('n', '<Leader><Tab>', '<C-^>', { desc = 'Toggle between buffers' })

-- Code folding
keymap('n', '<Leader><Leader>f', 'za', { desc = 'Toggle fold' })
keymap('n', ';f', 'zA', { desc = 'Toggle fold' })

-- Split commands
keymap('n', '<Leader>-', ':sp<CR>', { desc = 'Horizontal split' })
keymap('n', '<Leader>|', ':vsp<CR>', { desc = 'Vertical split' })

-- Quick save/quit
keymap('n', '<Leader>w', ':w<CR>', { desc = 'Save' })
keymap('n', '<Leader>q', ':q<CR>', { desc = 'Quit' })
keymap('n', '<Leader>wq', ':wq<CR>', { desc = 'Save and quit' })
keymap('n', '<Leader>Q', ':q!<CR>', { desc = 'Force quit' })

-- Reload config
keymap('n', '<Leader>rn', ':source ~/.config/nvim/init.lua<CR>', { desc = 'Reload neovim config' })

-- Tab navigation
for i = 1, 9 do
    keymap('n', '<Leader>' .. i, i .. 'gt<CR>', { desc = 'Go to tab ' .. i })
end
keymap('n', '<Leader><Leader>n', ':tabnew<CR>', { desc = 'New tab' })
keymap('n', '<Leader>x', ':tabclose<CR>', { desc = 'Close tab' })

-- Search and replace current word
keymap('n', '<leader>rr', ':%s/\\<<C-r><C-w>\\>//gc<left><left><left>', { desc = 'Replace current word' })

-- Toggle relative line numbers
keymap('n', '<C-N>', ':set rnu!<CR>', { desc = 'Toggle relative numbers' })

-- Disable Q (Ex mode)
keymap('n', 'Q', '<Nop>')

-- Clear search highlight
keymap('n', '<C-h>', ':nohlsearch<CR>', { desc = 'Clear search highlight' })

-- Macros - Q to apply recorded macro
keymap('n', 'Q', '@q', { desc = 'Apply macro q' })
keymap('v', 'Q', ':norm @q<CR>', { desc = 'Apply macro q to selection' })

-- Window navigation
keymap('n', '<C-h>', '<C-w>h', { desc = 'Move to left window' })
keymap('n', '<C-j>', '<C-w>j', { desc = 'Move to bottom window' })
keymap('n', '<C-k>', '<C-w>k', { desc = 'Move to top window' })
keymap('n', '<C-l>', '<C-w>l', { desc = 'Move to right window' })

-- Insert mode window navigation
keymap('i', '<C-h>', '<Esc><C-w>h', { desc = 'Move to left window from insert' })
keymap('i', '<C-l>', '<Esc><C-w>l', { desc = 'Move to right window from insert' })

-- Window resizing
keymap('n', '<C-Left>', ':vertical resize +3<CR>', { desc = 'Increase window width', silent = true })
keymap('n', '<C-Right>', ':vertical resize -3<CR>', { desc = 'Decrease window width', silent = true })
keymap('n', '<C-Up>', ':resize -3<CR>', { desc = 'Decrease window height', silent = true })
keymap('n', '<C-Down>', ':resize +3<CR>', { desc = 'Increase window height', silent = true })

-- Move by visual lines
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

-- Exit insert mode
keymap('i', 'kj', '<Esc>', { desc = 'Exit insert mode' })

-- Terminal mappings
keymap('t', '<C-h>', '<C-\\><C-n><C-w>h', { desc = 'Move to left window from terminal' })
keymap('t', '<Esc>', '<C-\\><C-n>', { desc = 'Exit terminal mode' })

-- Unmap F17/F18 in insert mode
keymap('i', '<F18>', '<Nop>')
keymap('i', '<F17>', '<Nop>')

-- Python file execution
vim.api.nvim_create_autocmd('FileType', {
    pattern = 'python',
    callback = function()
        keymap('n', '<leader>P', ':w<CR>:exec "!python3" shellescape(@%, 1)<CR>',
               { buffer = true, desc = 'Save and run Python file' })
    end,
})

-- Disable c-u in insert mode (bind to nothing)
keymap('i', '<C-u>', '<Nop>')

-- Cell navigation and creation macros
keymap('n', '<Leader>m', 'i# %% [markdown]<Esc>', { desc = 'Insert markdown cell' })
keymap('n', '<Leader>n', 'i# %%<Esc>', { desc = 'Insert code cell' })
