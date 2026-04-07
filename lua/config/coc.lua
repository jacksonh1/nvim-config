-- config/coc.lua - CoC (Conquer of Completion) configuration

local keymap = vim.keymap.set

-- CoC extensions and settings
vim.g.coc_global_extensions = {
  -- 'coc-pyright',
  'coc-json',
  'coc-yaml',
  'coc-html',
  'coc-css',
  'coc-tsserver',
}

-- Trigger completion
if vim.fn.has('nvim') == 1 then
  keymap('i', '<c-space>', 'coc#refresh()', { expr = true, silent = true })
else
  keymap('i', '<c-@>', 'coc#refresh()', { expr = true, silent = true })
end

-- Use K to show documentation
keymap('n', 'K', '<CMD>lua _G.show_docs()<CR>', { silent = true })

function _G.show_docs()
  local cw = vim.fn.expand('<cword>')
  if vim.fn.index({'vim', 'help'}, vim.bo.filetype) >= 0 then
    vim.api.nvim_command('h ' .. cw)
  elseif vim.api.nvim_eval('coc#rpc#ready()') then
    vim.fn.CocActionAsync('doHover')
  else
    vim.api.nvim_command('!' .. vim.o.keywordprg .. ' ' .. cw)
  end
end

-- Highlight symbol under cursor
vim.api.nvim_create_autocmd('CursorHold', {
  callback = function()
    vim.fn.CocActionAsync('highlight')
  end,
})

-- Scroll float windows
if vim.fn.has('nvim-0.4.0') == 1 or vim.fn.has('patch-8.2.0750') == 1 then
  keymap('n', '<C-f>', 'coc#float#has_scroll() ? coc#float#scroll(1) : "<C-f>"',
         { expr = true, silent = true })
  keymap('n', '<C-b>', 'coc#float#has_scroll() ? coc#float#scroll(0) : "<C-b>"',
         { expr = true, silent = true })
  keymap('i', '<C-f>', 'coc#float#has_scroll() ? "<c-r>=coc#float#scroll(1)<cr>" : "<Right>"',
         { expr = true, silent = true })
  keymap('i', '<C-b>', 'coc#float#has_scroll() ? "<c-r>=coc#float#scroll(0)<cr>" : "<Left>"',
         { expr = true, silent = true })
  keymap('v', '<C-f>', 'coc#float#has_scroll() ? coc#float#scroll(1) : "<C-f>"',
         { expr = true, silent = true })
  keymap('v', '<C-b>', 'coc#float#has_scroll() ? coc#float#scroll(0) : "<C-b>"',
         { expr = true, silent = true })
end

-- Selection ranges
keymap({'n', 'x'}, '<C-s>', '<Plug>(coc-range-select)', { silent = true })

-- Commands
vim.api.nvim_create_user_command('Fold', function(opts)
  vim.fn.CocAction('fold', opts.fargs)
end, { nargs = '?' })

-- Tab completion
keymap('i', '<TAB>', 'coc#pum#visible() ? coc#pum#insert() : "<TAB>"',
       { expr = true, silent = true })

-- CoC commands
keymap('n', '<leader>cc', ':<C-u>CocList commands<cr>', { desc = 'CoC commands' })
keymap('n', '<leader>ch', ':<C-u>CocList diagnostics<cr>', { desc = 'CoC diagnostics' })
keymap('n', '<leader>ce', ':<C-u>CocList extensions<cr>', { desc = 'CoC extensions' })
keymap('n', '<leader>cn', '<Plug>(coc-rename)', { desc = 'CoC rename' })
keymap('n', '<leader>cd', '<Plug>(coc-definition)', { desc = 'CoC definition' })
keymap('n', '<leader>cr', '<Plug>(coc-references)', { desc = 'CoC references' })

-- Python root patterns
vim.api.nvim_create_autocmd('FileType', {
  pattern = 'python',
  callback = function()
    vim.b.coc_root_patterns = {'.env', 'venv', '.venv', 'setup.cfg', 'setup.py', 'pyproject.toml', 'pyrightconfig.json'}
  end,
})
