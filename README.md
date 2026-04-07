# Neovim Lua Configuration

This is a converted Lua configuration from the original Vimscript configuration. The conversion maintains all the original functionality while leveraging modern Lua-based plugin management and configuration.

## Structure

```
~/.config/nvim/
├── init.lua                    # Main entry point
├── lua/
│   ├── config/
│   │   ├── options.lua         # Basic Neovim settings (from basic.vim)
│   │   ├── keymaps.lua         # Key mappings
│   │   ├── plugins.lua         # Plugin management with lazy.nvim
│   │   ├── coc.lua            # CoC configuration (from coc.vim)
│   │   ├── autocmds.lua       # Autocommands
│   │   └── vscode.lua         # VSCode extension configuration
│   └── vscode_settings.lua    # Additional VSCode settings
└── README.md                  # This file
```

## Key Changes

### Plugin Manager
- **Old**: vim-plug
- **New**: lazy.nvim (modern, faster, better lazy loading)

### Configuration Style
- **Old**: Scattered across multiple .vim files
- **New**: Modular Lua structure with clear separation of concerns

### Key Features Preserved
- All original key mappings
- Plugin configurations
- VSCode integration
- Python development setup
- CoC (Conquer of Completion) integration
- Theme switching
- REPL integration with vim-slime and vim-ipython-cell

## Installation

1. **Backup your current configuration:**
   ```bash
   mv ~/.config/nvim ~/.config/nvim.backup
   ```

2. **The new configuration is already in place**

3. **Install lazy.nvim and plugins:**
   - Open Neovim
   - lazy.nvim will automatically install on first run
   - Run `:Lazy sync` to install all plugins

## Plugin Management

The configuration uses [lazy.nvim](https://github.com/folke/lazy.nvim) for plugin management:

- `:Lazy` - Open plugin manager UI
- `:Lazy sync` - Install/update plugins
- `:Lazy clean` - Remove unused plugins
- `:Lazy profile` - View startup profiling

## Key Mappings

All original key mappings are preserved. Here are some highlights:

### Leader Key Mappings (Space)
- `<Space><Tab>` - Toggle between buffers
- `<Space>w` - Save file
- `<Space>q` - Quit
- `<Space>e` - FZF file search
- `<Space>g` - FZF grep search
- `<Space>b` - FZF buffer search

### EasyMotion
- `<Space>f` - Find character
- `<Space>s` - Find 2 characters
- `<Space>h/j/k/l` - EasyMotion navigation

### CoC (Code Completion)
- `<Space>cd` - Go to definition
- `<Space>cr` - Find references
- `<Space>cn` - Rename symbol
- `K` - Show documentation

### Python Development
- `<Space><CR>` - Execute current cell and jump to next
- `<Space>i` - Send line/selection to REPL
- `<Space>P` - Save and run Python file

## Themes

Theme switching commands:
- `<Space>tc` - Catppuccin theme
- `<Space>to` - OneDark theme
- `<Space>tl` - Light theme

## VSCode Integration

When running in VSCode, the configuration automatically loads a minimal setup optimized for the VSCode environment with:
- Essential key mappings
- Jupyter notebook integration
- VSCode command integration

## Troubleshooting

### Plugin Issues
1. Run `:checkhealth` to diagnose issues
2. Run `:Lazy sync` to update plugins
3. Check `:Lazy log` for installation logs

### Which-Key Not Showing
If which-key menu doesn't appear when pressing `<Space>`:
1. **Check timeout**: The menu appears after 300ms by default
2. **Verify leader key**: Run `:echo mapleader` (should show space)
3. **Test manually**: Run `:lua require('which-key').show(' ', {mode = 'n'})`
4. **Check conflicts**: Run `:verbose map <Space>` to see if other mappings conflict
5. **Reload config**: Run `:source ~/.config/nvim/init.lua`

### Startify Not Working
If startify doesn't show on startup or `:Startify` doesn't work:
1. **Check if loaded**: Run `:lua print(vim.fn.exists(':Startify'))`
2. **Manual trigger**: Run `:Startify` or `<Space>`` (backtick)
3. **Check configuration**: Run `:lua print(vim.g.startify_custom_header)`
4. **Create sessions dir**: Make sure `~/.config/nvim/sessions` exists
5. **Test plugin**: Run `:luafile ~/.config/nvim/test-plugins.lua`

### CoC Issues
1. Run `:CocInfo` to check CoC status
2. Install language servers: `:CocInstall coc-pyright coc-json`
3. Check `:CocConfig` for configuration

### Python Issues
1. Update Python path in `lua/config/options.lua`
2. Check virtual environment settings
3. Verify CoC Python configuration

### REPL/Slime Issues
The vim-slime configuration is set to use tmux by default. If you get "Terminal not found" errors:

1. **If you use tmux**: Make sure you're running Neovim inside a tmux session
2. **If you don't use tmux**: Edit `lua/config/plugins.lua` and change the slime target:
   ```lua
   -- For Kitty terminal:
   vim.g.slime_target = 'kitty'

   -- For simple Neovim terminal:
   vim.g.slime_target = 'neovim'
   -- Then use <Leader>tt to open a terminal with IPython

   -- For WezTerm:
   vim.g.slime_target = 'wezterm'
   ```
3. **Alternative**: Use the simple approach in `lua/config/repl-alternatives.lua`
4. **Quick fix**: Use `<Leader>tt` to open a terminal with IPython, then slime should work

## Migration Notes

- All original functionality is preserved
- Plugin lazy loading improves startup time
- Better error handling and debugging
- Modern Lua APIs used throughout
- Maintains compatibility with existing workflows

## Customization

To customize the configuration:
1. Edit files in `lua/config/` for specific areas
2. Add new plugins to `lua/config/plugins.lua`
3. Modify key mappings in `lua/config/keymaps.lua`
4. Adjust settings in `lua/config/options.lua`
