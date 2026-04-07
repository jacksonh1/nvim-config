-- config/repl-alternatives.lua - Alternative REPL configurations
-- Uncomment and use one of these configurations if the default tmux setup doesn't work

local M = {}

-- Option 1: For Kitty terminal users
function M.setup_kitty()
  vim.g.slime_target = 'kitty'
end

-- Option 2: For simple Neovim terminal (requires manual terminal setup)
function M.setup_neovim_terminal()
  vim.g.slime_target = 'neovim'
  
  -- Add helper function to create terminal for REPL
  vim.keymap.set('n', '<Leader>tp', function()
    -- Create a horizontal split with terminal
    vim.cmd('split')
    vim.cmd('resize 15')
    vim.cmd('terminal')
    -- Enter insert mode and start ipython
    vim.cmd('startinsert')
    vim.defer_fn(function()
      vim.api.nvim_feedkeys('ipython --matplotlib\r', 'n', false)
    end, 500)
  end, { desc = 'Open IPython terminal' })
end

-- Option 3: For tmux users (default in main config)
function M.setup_tmux()
  vim.g.slime_target = 'tmux'
  vim.g.slime_default_config = {
    socket_name = vim.fn.get(vim.fn.split(vim.env.TMUX or '', ','), 0),
    target_pane = '{right-of}'
  }
  vim.g.slime_dont_ask_default = 1
  vim.g.slime_python_ipython = 1
end

-- Option 4: For X11 (Linux)
function M.setup_x11()
  vim.g.slime_target = 'x11'
end

-- Option 5: For WezTerm users
function M.setup_wezterm()
  vim.g.slime_target = 'wezterm'
end

-- Simple fallback for just running Python files
function M.setup_simple_python()
  vim.keymap.set('n', '<Leader><CR>', function()
    vim.cmd('w')  -- Save file
    local file = vim.fn.expand('%:p')
    if vim.bo.filetype == 'python' then
      -- Run in a terminal split
      vim.cmd('vsplit')
      vim.cmd('terminal python3 ' .. vim.fn.shellescape(file))
    end
  end, { desc = 'Run Python file in terminal' })
end

return M
