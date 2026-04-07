-- config/plugins.lua - Plugin configuration using lazy.nvim

-- Bootstrap lazy.nvim
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable",
    lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)

-- Plugin specifications
local plugins = {

  --{
  --  "nvim-neo-tree/neo-tree.nvim",
  --  branch = "v3.x",
  --  dependencies = {
  --    "nvim-lua/plenary.nvim",
  --    "nvim-tree/nvim-web-devicons", -- not strictly required, but recommended
  --    "MunifTanjim/nui.nvim",
  --    -- {"3rd/image.nvim", opts = {}}, -- Optional image support in preview window: See `# Preview Mode` for more information
  --  },
  --  lazy = false, -- neo-tree will lazily load itself
  --  ---@module "neo-tree"
  --  ---@type neotree.Config?
  --  opts = {
  --    -- fill any relevant options here
  --  },
  --},
  -- run :lua require("neo-tree").paste_default_config() to paste the default config in the current buffer
  --
  -- {
  --   'scrooloose/nerdtree',
  --   keys = {
  --     { '<C-T>', ':NERDTreeToggle<CR>', desc = 'Toggle NERDTree' },
  --     { '<Leader>;', ':NERDTreeFind<CR>', desc = 'Find current file in NERDTree' },
  --   },
  --   config = function()
  --     -- Close vim if NERDTree is the only window left
  --     vim.api.nvim_create_autocmd('BufEnter', {
  --       callback = function()
  --         if vim.fn.winnr('$') == 1 and vim.fn.exists('b:NERDTree') == 1 and vim.b.NERDTree.isTabTree() then
  --           vim.cmd('q')
  --         end
  --       end,
  --     })
  --   end,
  -- },

  -- {
  --   "nvim-tree/nvim-tree.lua",
  --   version = "*",
  --   lazy = false,
  --   dependencies = {
  --     "nvim-tree/nvim-web-devicons",
  --   },
  --   config = function()
  --     require("nvim-tree").setup {
  --       -- config
  --     }
  --   end,
  -- },

  {
    'stevearc/oil.nvim',
    ---@module 'oil'
    ---@type oil.SetupOpts
    opts = {},
    -- Optional dependencies
    dependencies = { { "echasnovski/mini.icons", opts = {} } },
    -- dependencies = { "nvim-tree/nvim-web-devicons" }, -- use if you prefer nvim-web-devicons
    -- Lazy loading is not recommended because it is very tricky to make it work correctly in all situations.
    lazy = false,
    config = function()
      require('oil').setup {
        -- config
        view_options = {
          show_hidden = true, -- Show hidden files
        },
      }
      vim.keymap.set('n', '<C-t>', ':Oil<CR>', { desc = 'Open Oil file manager' })
    end,
  },

  {
    "nvim-treesitter/nvim-treesitter",
    build = ":TSUpdate",
    config = function()
      require("nvim-treesitter.configs").setup {
        ensure_installed = { "python", "lua", "vim", "bash" }, -- add more as needed
        highlight = { enable = true },
        indent = { enable = true },
      }
    end,
  },

  -- Search enhancements
  {
    'romainl/vim-cool',
    lazy = false,
    -- event = 'VeryLazy',
  },

  -- { 'echasnovski/mini.starter', version = false },
  {
    'echasnovski/mini.sessions',
    version = false,
    config = function()
      require('mini.sessions').setup {
        -- config
      }
    end,
  },
  {
    'echasnovski/mini.icons',
    version = false,
    config = function()
      require('mini.icons').setup {
        -- config
      }
    end,
  },

  {
    'nvimdev/dashboard-nvim',
    event = 'VimEnter',
    config = function()
      require('dashboard').setup {
        -- config
      }
    end,
    dependencies = { {'nvim-tree/nvim-web-devicons'}}
  },


  -- Movement
  {
    'easymotion/vim-easymotion',
    keys = {
      { '<Leader>h', '<Plug>(easymotion-linebackward)', mode = {'n', 'v'}, desc = 'EasyMotion line backward' },
      { '<Leader>j', '<Plug>(easymotion-j)', mode = {'n', 'v'}, desc = 'EasyMotion down' },
      { '<Leader>k', '<Plug>(easymotion-k)', mode = {'n', 'v'}, desc = 'EasyMotion up' },
      { '<Leader>l', '<Plug>(easymotion-lineforward)', mode = {'n', 'v'}, desc = 'EasyMotion line forward' },
      { '<Leader>f', '<Plug>(easymotion-bd-f)', mode = {'n', 'v'}, desc = 'EasyMotion find char' },
      { '<Leader>f', '<Plug>(easymotion-overwin-f)', desc = 'EasyMotion find char (overwin)' },
      { '<Leader>s', '<Plug>(easymotion-f2)', mode = {'n', 'v'}, desc = 'EasyMotion find 2 chars' },
      { '<Leader>s', '<Plug>(easymotion-overwin-f2)', desc = 'EasyMotion find 2 chars (overwin)' },
    },
    config = function()
      vim.g.EasyMotion_smartcase = 1
    end,
  },

  -- Text manipulation
  {
    'tpope/vim-surround',
    event = 'VeryLazy',
  },

  {
    'tpope/vim-commentary',
    event = 'VeryLazy',
  },

  -- GUI enhancements
  {
    'vim-airline/vim-airline',
    dependencies = {
      'vim-airline/vim-airline-themes',
    },
    config = function()
      vim.g['airline#extensions#coc#show_coc_status'] = 1
      vim.g['airline#extensions#coc#enabled'] = 1
      vim.g.airline_theme = 'bubblegum'
    end,
  },


  {
    'kshenoy/vim-signature',
    event = 'VeryLazy',
  },

  -- Colorschemes
  {
    'morhetz/gruvbox',
    lazy = true,
  },

  {
    'catppuccin/nvim',
    name = 'catppuccin',
    lazy = false,
    priority = 1000,
    config = function()
      vim.cmd.colorscheme 'catppuccin-frappe'
      -- Theme switching keymaps
      vim.keymap.set('n', '<Leader>tc', ':colorscheme catppuccin-frappe<CR>', { desc = 'Catppuccin theme' })
      vim.keymap.set('n', '<Leader>to', ':colorscheme onedark<CR>', { desc = 'OneDark theme' })
      vim.keymap.set('n', '<Leader>tl', ':colorscheme tony_light<CR>', { desc = 'Light theme' })
    end,
  },

  {
    'joshdick/onedark.vim',
    lazy = true,
  },

  -- LSP and completion
  {
    'neoclide/coc.nvim',
    branch = 'release',
    event = 'VeryLazy',
    config = function()
      require('config.coc')
    end,
  },

  -- FZF
  {
    'junegunn/fzf',
    dir = '~/.fzf',
    build = './install --all',
    lazy = false,
  },

  {
    'junegunn/fzf.vim',
    dependencies = { 'junegunn/fzf' },
    keys = {
      { '<Leader>b', ':Buffers<CR>', desc = 'FZF buffers' },
      { '<Leader>g', ':Rg<CR>', desc = 'FZF ripgrep' },
      { '<Leader>e', ':Files<CR>', desc = 'FZF files' },
      { '<Leader>H', ':History<CR>', desc = 'FZF history' },
    },
    config = function()
      vim.g.fzf_layout = { down = '~40%' }
      vim.env.FZF_DEFAULT_OPTS = '--bind ctrl-a:select-all'
    end,
  },

  -- Smooth scrolling
  {
    'psliwka/vim-smoothie',
    event = 'VeryLazy',
  },

  -- Color highlighting
  {
    'ap/vim-css-color',
    ft = { 'css', 'scss', 'html', 'javascript', 'typescript' },
  },

  -- REPL integration
  {
    'jpalardy/vim-slime',
    ft = 'python',
    config = function()
      -- Load alternative REPL configurations
      local repl_alternatives = require('config.repl-alternatives')

      -- Choose one of these options by uncommenting:

      -- Option 1: For tmux users (default, works best)
      -- repl_alternatives.setup_tmux()

      -- Option 2: For Kitty terminal users
      -- repl_alternatives.setup_kitty()

      -- Option 3: For simple Neovim terminal
      repl_alternatives.setup_neovim_terminal()

      -- Option 4: For WezTerm users
      -- repl_alternatives.setup_wezterm()

      -- Option 5: For X11 (Linux)
      -- repl_alternatives.setup_x11()

      -- Add a keymap to open terminal and start IPython
      vim.keymap.set('n', '<Leader>tt', function()
        -- Open a vertical split with a terminal
        vim.cmd('vsplit')
        vim.cmd('terminal')
        -- Send 'ipython --matplotlib' to the terminal
        vim.defer_fn(function()
          vim.api.nvim_feedkeys('iipython --matplotlib<CR>', 'n', false)
        end, 100)
      end, { desc = 'Open terminal with IPython' })
    end,
  },

  {
    'hanschen/vim-ipython-cell',
    ft = 'python',
    dependencies = { 'jpalardy/vim-slime' },
    config = function()
      -- IPython cell mappings
      vim.keymap.set('n', '<Leader><Leader>s', ':SlimeSend1 ipython --matplotlib<CR>', { desc = 'Start IPython' })
      vim.keymap.set('n', '<Leader><Leader>c', ':IPythonCellClear<CR>', { desc = 'Clear IPython' })
      vim.keymap.set('n', '<Leader><Leader>x', ':IPythonCellClose<CR>', { desc = 'Close figures' })
      vim.keymap.set('n', '<Leader><Leader>r', ':IPythonCellRestart<CR>', { desc = 'Restart IPython' })
      vim.keymap.set('n', '<Leader><Leader>a', ':IPythonCellInsertAbove<CR>', { desc = 'Insert cell above' })
      vim.keymap.set('n', '<Leader><Leader>b', ':IPythonCellInsertBelow<CR>', { desc = 'Insert cell below' })
      vim.keymap.set('n', '<Leader>i', '<Plug>SlimeLineSend', { desc = 'Send line to REPL' })
      vim.keymap.set('x', '<Leader>i', '<Plug>SlimeRegionSend', { desc = 'Send selection to REPL' })
      vim.keymap.set('n', '<Leader><CR>', ':IPythonCellExecuteCellJump<CR>', { desc = 'Execute cell and jump' })
    end,
  },

  -- Syntax highlighting
  {
    'sheerun/vim-polyglot',
    event = 'VeryLazy',
  },

  -- GitHub Copilot
  {
    'github/copilot.vim',
    lazy = false,
    event = 'InsertEnter',
    config = function()
      vim.keymap.set('i', '<c-y>', 'copilot#Accept("")', { expr = true, silent = true, script = true, replace_keycodes = false })
      vim.keymap.set('i', '<c-u>', 'copilot#Accept("")', { expr = true, silent = true, script = true, replace_keycodes = false })
      vim.g.copilot_no_tab_map = true
    end,
  },

  -- Highlight yanked text
  {
    'machakann/vim-highlightedyank',
    lazy = false,
    config = function()
      vim.g.highlightedyank_highlight_duration = 150
    end,
  },

  -- File manager
  {
    'ptzz/lf.vim',
    lazy = false,
    dependencies = { 'voldikss/vim-floaterm' },
    keys = {
      { '<leader>o', ':Lf<CR>', desc = 'Open lf file manager' },
    },
    config = function()
      vim.g.lf_map_keys = 0
    end,
  },

  {
    'voldikss/vim-floaterm',
    event = 'VeryLazy',
    init = function()
      vim.g.floaterm_opener = 'edit'
    end,
  },

  {
    "folke/which-key.nvim",
    event = "VeryLazy",
    opts = {
      -- your configuration comes here
      -- or leave it empty to use the default settings
      -- refer to the configuration section below
    },
    keys = {
      {
        "<leader>?",
        function()
          require("which-key").show({ global = false })
        end,
        desc = "Buffer Local Keymaps (which-key)",
      },
    },
  }
}



-- Setup lazy.nvim
require('lazy').setup(plugins, {
  ui = {
    border = 'rounded',
  },
  performance = {
    rtp = {
      disabled_plugins = {
        'gzip',
        'matchit',
        'matchparen',
        'netrwPlugin',
        'tarPlugin',
        'tohtml',
        'tutor',
        'zipPlugin',
      },
    },
  },
})
