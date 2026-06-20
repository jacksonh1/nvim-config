# Neovim Cluster Setup Notes (ORCD Engaging)

Steps taken to get this config working on the ORCD engaging cluster (Rocky Linux 8, x86_64).

---

## 1. Install Neovim from Source

The community module (`module load neovim/0.11.0`) has another user's build paths
baked into LuaJIT, which breaks plugin `require()` calls. Build your own instead.

```bash
git clone https://github.com/neovim/neovim.git ~/.local/src/neovim --depth 1 --branch stable
cd ~/.local/src/neovim
make CMAKE_BUILD_TYPE=Release CMAKE_INSTALL_PREFIX=$HOME/.local
make install
```

Requires: `gcc` (available via `module load community-modules`) and `cmake`
(installed at `~/opt/cmake-4.0/bin`). Neovim bundles all other dependencies.

Note: The AppImage from GitHub releases requires GLIBC 2.29, but the cluster
only has GLIBC 2.28, so the source build is necessary.

---

## 2. Ensure `~/.local/bin` Takes Priority in PATH

Add this at the **end** of `~/.bashrc` (after all `module load` lines) so the
personal neovim binary takes precedence over the community module:

```bash
# Personal binaries take priority over system/module installs
export PATH="$HOME/.local/bin:$PATH"
```

---

## 3. Install Node.js for coc.nvim

`coc.nvim` requires Node.js, which is not available on the cluster by default.

```bash
conda install -n basic -c conda-forge nodejs
```

---

## 4. Config File Changes

### `lua/config/options.lua`

Fix the hardcoded macOS Python path:

```lua
-- Before (macOS path, doesn't exist on cluster):
g.python3_host_prog = '/Users/jackson/miniforge3/bin/python'

-- After:
g.python3_host_prog = '/home/jhalpin/.conda/envs/basic/bin/python3'
```

### `lua/config/plugins.lua` — FZF plugin

The `dir = '~/.fzf'` field tells lazy.nvim the plugin is at that local path, but
that directory doesn't exist. Removing it lets lazy.nvim manage fzf normally:

```lua
-- Before:
{
  'junegunn/fzf',
  dir = '~/.fzf',
  build = './install --all',
  lazy = false,
},

-- After:
{
  'junegunn/fzf',
  -- dir = '~/.fzf',
  build = './install --all',
  lazy = false,
},
```

### `lua/config/plugins.lua` — nvim-treesitter plugin

Two changes:
1. Add `lazy = false` so lazy.nvim loads the plugin at startup
2. The nvim-treesitter API changed — `nvim-treesitter.configs` no longer exists;
   use `require('nvim-treesitter')` directly

```lua
-- Before:
{
  "nvim-treesitter/nvim-treesitter",
  build = ":TSUpdate",
  config = function()
    require("nvim-treesitter.configs").setup {
      ensure_installed = { "python", "lua", "vim", "bash" },
      highlight = { enable = true },
      indent = { enable = true },
    }
  end,
},

-- After:
{
  "nvim-treesitter/nvim-treesitter",
  lazy = false,
  build = ":TSUpdate",
  config = function()
    require("nvim-treesitter").setup {
      ensure_installed = { "python", "lua", "vim", "bash" },
      highlight = { enable = true },
      indent = { enable = true },
    }
  end,
},
```

### `queries/lua/highlights.scm` — Lua treesitter query override

Neovim's built-in Lua highlight query references `operator:` as a named field on
`binary_expression` and `unary_expression` nodes, but the Lua parser installed by
nvim-treesitter doesn't expose that field. This causes an error when opening Lua
files via oil.nvim (the built-in `ftplugin/lua.lua` runs before nvim-treesitter's
highlight autocmd in that code path).

Fix: create `~/.config/nvim/queries/lua/highlights.scm` (without `; extends`) to
completely replace the built-in query, substituting the two broken operator captures
with anonymous node matches:

```scheme
; Instead of:
(binary_expression
  operator: _ @operator)
(unary_expression
  operator: _ @operator)

; Use:
(binary_expression
  [
    "+" "-" "*" "/" "//" "%" "^" ".."
    "<" "<=" ">" ">=" "==" "~="
    "&" "|" "~" "<<" ">>"
  ] @operator)
(unary_expression
  ["-" "#" "~"] @operator)
```

The full override file is at `queries/lua/highlights.scm` in this repo.

---

## 5. First-Time Plugin Sync

After all of the above, open neovim and run:

```
:Lazy sync
```

This installs/rebuilds all plugins including the fzf binary and treesitter parsers.

---

## 6. Provider Setup (`checkhealth` fixes)

Run these after initial plugin sync to clear provider errors:

### Python provider

```bash
pip install pynvim
```

### Node.js provider (for coc.nvim)

```bash
npm install -g neovim
```

### ripgrep (for telescope and grep integration)

```bash
conda install -c conda-forge ripgrep
```

### `lua/config/options.lua` — disable unused providers

```lua
-- Disable unused providers (not available on cluster)
vim.g.loaded_perl_provider = 0
vim.g.loaded_ruby_provider = 0
```

### `lua/config/plugins.lua` — disable luarocks support

Add to the `require('lazy').setup(plugins, { ... })` options table:

```lua
rocks = {
  enabled = false,  -- luarocks/hererocks not available on cluster
},
```

### `lua/config/options.lua` — OSC 52 clipboard (works over SSH via kitty)

Replace the plain `opt.clipboard = 'unnamedplus'` line with:

```lua
vim.g.clipboard = {
  name = 'OSC 52',
  copy = {
    ['+'] = require('vim.ui.clipboard.osc52').copy('+'),
    ['*'] = require('vim.ui.clipboard.osc52').copy('*'),
  },
  paste = {
    ['+'] = require('vim.ui.clipboard.osc52').paste('+'),
    ['*'] = require('vim.ui.clipboard.osc52').paste('*'),
  },
}
opt.clipboard = 'unnamedplus'
```

This uses the OSC 52 terminal escape sequence, which kitty supports natively. No
X11 forwarding required. OSC 52 paste reads hang over SSH, so paste is disabled —
`y`/`p` use neovim's internal registers. Use `"+y` to explicitly copy to your local
system clipboard. To paste from system clipboard into neovim, use kitty's
`ctrl+shift+v` in insert mode.

### Known remaining warnings after the above

- **tree-sitter-cli**: Only needed to compile parsers from grammar source. Pre-built parsers (downloaded by nvim-treesitter) work fine without it.

---

## 7. vim-slime + IPython Workflow

`vim-slime` is configured for the neovim terminal target (`slime_target = 'neovim'`).

### Fixes applied

The following bugs were fixed to get vim-slime + vim-ipython-cell working on the cluster:

1. **`slime_python_ipython = 1` was missing** from `setup_neovim_terminal()` — without
   this, vim-slime doesn't use IPython's `%cpaste` magic, so multi-line code blocks
   paste incorrectly.
2. **`slime_target` set too late** — it was set in the plugin's `config` callback, which
   runs after the plugin's vimscript is sourced. vim-slime's `config.vim` conditionally
   populates neovim-specific defaults (including `neovim_ignore_unlisted`) only if the
   target is already `"neovim"` at source time. Moved to the `init` callback, which
   runs before sourcing.
3. **`%paste -q` used instead of `%cpaste`** — `IPythonCellExecuteCellJump` copies the
   cell to the system clipboard then sends `%paste -q`, which requires a display
   (`$DISPLAY`). On the cluster this fails with a `TclError`. Changed to
   `IPythonCellExecuteCellVerboseJump`, which with `slime_python_ipython=1` sends the
   cell through vim-slime's `_EscapeText_python`, wrapping it in `%cpaste -q ... --`
   over stdin — no display needed.
4. **Conda env not inherited** — `:terminal` spawns a new shell that sources `.bashrc`
   and `module load` commands, which can clobber the conda PATH. IPython is launched
   via `$CONDA_PREFIX/bin/ipython` (full path read at call time) so the right
   interpreter is always used regardless of what the shell does to PATH.
5. **Terminal input sent via `chansend` not `feedkeys`** — `chansend` writes directly
   to the terminal's pty; `feedkeys` fakes keystrokes and is fragile with timing.
   `vim.g.slime_default_config` is set globally (not buffer-local) so all python
   buffers share the same terminal without needing per-buffer configuration.

### Usage

From a `.py` file:

| Key | Action |
|-----|--------|
| `<Leader>tt` | Open vertical split terminal, start IPython, configure slime |
| `<Leader>tp` | Open horizontal split terminal (15 lines), start IPython, configure slime |
| `<Leader>i` | Send current line to IPython |
| `<Leader>i` (visual) | Send selection to IPython |
| `<Leader><CR>` | Execute current `# %%` cell and jump to next |
| `<Leader>n` | Insert a `# %%` code cell marker |
| `<Leader>m` | Insert a `# %% [markdown]` cell marker |
| `<Leader><Leader>c` | Clear IPython output |
| `<Leader><Leader>r` | Restart IPython |

### Cell format

Use `# %%` to delimit cells (VS Code notebook style):

```python
# %%
import numpy as np
x = np.linspace(0, 10, 100)

# %%
import matplotlib.pyplot as plt
plt.plot(x, np.sin(x))
plt.show()
```

---

## Notes

- `fzf` is also available at `~/.conda/envs/basic/bin/fzf` (installed via conda),
  but the lazy.nvim-managed copy is used by the neovim plugins.
- The `basic` conda environment must be active (or on PATH) for the Python provider
  and coc.nvim (Node.js) to work.
- If you update nvim-treesitter and it breaks again, check whether the module API
  has changed: `ls ~/.local/share/nvim/lazy/nvim-treesitter/lua/nvim-treesitter/`
