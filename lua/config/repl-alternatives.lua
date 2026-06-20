-- config/repl-alternatives.lua - Alternative REPL configurations
-- Uncomment and use one of these configurations if the default tmux setup doesn't work

local M = {}

-- Option 1: For Kitty terminal users
function M.setup_kitty()
  vim.g.slime_target = 'kitty'
end

-- Option 2: For simple Neovim terminal (requires manual terminal setup)
function M.setup_neovim_terminal()
  vim.g.slime_python_ipython = 1
  vim.g.slime_dont_ask_default = 1
  vim.g.slime_neovim_ignore_unlisted = 1

  local function open_ipython_terminal(split_cmd)
    vim.cmd(split_cmd)
    vim.cmd('terminal')
    local job_id = vim.b.terminal_job_id
    vim.g.slime_default_config = { jobid = job_id }
    local prefix = vim.env.CONDA_PREFIX
    local ipy = (prefix and prefix ~= '') and (prefix .. '/bin/ipython') or 'ipython'
    vim.defer_fn(function()
      vim.fn.chansend(job_id, ipy .. ' --matplotlib\n')
      vim.cmd('wincmd p')
    end, 500)
  end

  vim.keymap.set('n', '<Leader>tp', function()
    open_ipython_terminal('split | resize 15')
  end, { desc = 'Open IPython in horizontal split' })

  vim.keymap.set('n', '<Leader>tt', function()
    open_ipython_terminal('vsplit')
  end, { desc = 'Open IPython in vertical split' })
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
