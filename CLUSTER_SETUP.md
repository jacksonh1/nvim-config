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

## Notes

- `fzf` is also available at `~/.conda/envs/basic/bin/fzf` (installed via conda),
  but the lazy.nvim-managed copy is used by the neovim plugins.
- The `basic` conda environment must be active (or on PATH) for the Python provider
  and coc.nvim (Node.js) to work.
- If you update nvim-treesitter and it breaks again, check whether the module API
  has changed: `ls ~/.local/share/nvim/lazy/nvim-treesitter/lua/nvim-treesitter/`
