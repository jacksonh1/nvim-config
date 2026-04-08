-- config/autocmds.lua - Autocommands

local autocmd = vim.api.nvim_create_autocmd
local augroup = vim.api.nvim_create_augroup

-- General settings group
local general = augroup('General', { clear = true })

-- Highlight on yank
autocmd('TextYankPost', {
  group = general,
  callback = function()
    vim.highlight.on_yank({ higroup = 'Visual', timeout = 150 })
  end,
})

-- Remove trailing whitespace on save
autocmd('BufWritePre', {
  group = general,
  pattern = '*',
  command = '%s/\\s\\+$//e',
})

-- Cursor line/column management
local cursor_group = augroup('CursorHighlight', { clear = true })

autocmd('WinLeave', {
  group = cursor_group,
  callback = function()
    vim.opt_local.cursorline = false
    vim.opt_local.cursorcolumn = false
  end,
})

autocmd('WinEnter', {
  group = cursor_group,
  callback = function()
    vim.opt_local.cursorline = true
    vim.opt_local.cursorcolumn = true
  end,
})

-- Markdown conceallevel
autocmd('BufEnter', {
  pattern = '*.md',
  callback = function()
    vim.opt_local.conceallevel = 0
  end,
})

-- Terminal settings
local term_group = augroup('Terminal', { clear = true })

-- Disable line numbers in terminal
autocmd('TermOpen', {
  group = term_group,
  callback = function()
    vim.opt_local.number = false
    vim.opt_local.relativenumber = false
  end,
})

-- Check for file changes when focus is gained or cursor is held
autocmd({ 'FocusGained', 'BufEnter', 'CursorHold' }, {
  group = general,
  callback = function() vim.cmd('checktime') end,
})

-- Python specific settings
local python_group = augroup('Python', { clear = true })

autocmd('FileType', {
  group = python_group,
  pattern = 'python',
  callback = function()
    vim.opt_local.tabstop = 4
    vim.opt_local.shiftwidth = 4
    vim.opt_local.expandtab = true
  end,
})
