-- config/repl-config.lua - Easy REPL configuration switcher

local M = {}

-- Current REPL mode
local current_mode = nil

function M.setup()
  local repl_alternatives = require('config.repl-alternatives')
  
  -- Create commands to switch REPL modes
  vim.api.nvim_create_user_command('ReplTmux', function()
    repl_alternatives.setup_tmux()
    current_mode = 'tmux'
    print('REPL mode: tmux')
  end, { desc = 'Set REPL to tmux mode' })
  
  vim.api.nvim_create_user_command('ReplKitty', function()
    repl_alternatives.setup_kitty()
    current_mode = 'kitty'
    print('REPL mode: kitty')
  end, { desc = 'Set REPL to kitty mode' })
  
  vim.api.nvim_create_user_command('ReplNeovim', function()
    repl_alternatives.setup_neovim_terminal()
    current_mode = 'neovim'
    print('REPL mode: neovim terminal')
  end, { desc = 'Set REPL to neovim terminal mode' })
  
  vim.api.nvim_create_user_command('ReplWezterm', function()
    repl_alternatives.setup_wezterm()
    current_mode = 'wezterm'
    print('REPL mode: wezterm')
  end, { desc = 'Set REPL to wezterm mode' })
  
  vim.api.nvim_create_user_command('ReplSimple', function()
    repl_alternatives.setup_simple_python()
    current_mode = 'simple'
    print('REPL mode: simple python execution')
  end, { desc = 'Set REPL to simple python mode' })
  
  vim.api.nvim_create_user_command('ReplStatus', function()
    if current_mode then
      print('Current REPL mode: ' .. current_mode)
    else
      print('No REPL mode set (using default)')
    end
    print('Slime target: ' .. (vim.g.slime_target or 'not set'))
  end, { desc = 'Show current REPL status' })
  
  -- Create key mappings for quick switching
  vim.keymap.set('n', '<leader>rt', ':ReplTmux<CR>', { desc = 'Switch to tmux REPL' })
  vim.keymap.set('n', '<leader>rk', ':ReplKitty<CR>', { desc = 'Switch to kitty REPL' })
  vim.keymap.set('n', '<leader>rn', ':ReplNeovim<CR>', { desc = 'Switch to neovim REPL' })
  vim.keymap.set('n', '<leader>rs', ':ReplSimple<CR>', { desc = 'Switch to simple REPL' })
  vim.keymap.set('n', '<leader>r?', ':ReplStatus<CR>', { desc = 'Show REPL status' })
end

return M
