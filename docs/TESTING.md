# Testing Environment Documentation

This document explains how the isolated testing environment works for vim-coach.nvim. Perfect for contributors who want to understand the testing setup!

## Table of Contents
- [Overview](#overview)
- [Why an Isolated Environment?](#why-an-isolated-environment)
- [How It Works](#how-it-works)
- [Directory Structure](#directory-structure)
- [The Magic Behind test.sh](#the-magic-behind-testsh)
- [The Magic Behind test/minimal_init.lua](#the-magic-behind-testminimal_initlua)
- [What Gets Installed](#what-gets-installed)
- [Troubleshooting](#troubleshooting)

---

## Overview

The testing environment allows you to:
- Test vim-coach.nvim in a **real LazyVim environment**
- **No impact** on your personal Neovim configuration
- **Fast iteration** - make changes and test immediately
- **Reproducible** - same environment for all contributors

### Quick Start
```bash
./test.sh
```

That's it! But let's understand what happens under the hood...

---

## Why an Isolated Environment?

### The Problem
When developing a Neovim plugin, you face these challenges:

1. **Pollution Risk**: Testing plugins can mess up your daily Neovim setup
2. **Dependency Conflicts**: Your personal plugins might interfere with testing
3. **Reproducibility**: "Works on my machine" becomes a real issue
4. **Setup Complexity**: New contributors need a way to test without complex setup

### The Solution
Our testing environment uses Neovim's `-u` flag to create a completely separate instance:

```bash
nvim -u test/minimal_init.lua
```

This tells Neovim: "Ignore all user configs, only use this file"

---

## How It Works

### High-Level Flow

```
┌─────────────┐
│  ./test.sh  │
└──────┬──────┘
       │
       v
┌─────────────────────────────────────┐
│ nvim -u test/minimal_init.lua       │
└──────┬──────────────────────────────┘
       │
       v
┌─────────────────────────────────────┐
│ 1. Create temp directory:           │
│    ~/.cache/nvim/vim-coach-test/    │
└──────┬──────────────────────────────┘
       │
       v
┌─────────────────────────────────────┐
│ 2. Install lazy.nvim package mgr    │
│    (only on first run)              │
└──────┬──────────────────────────────┘
       │
       v
┌─────────────────────────────────────┐
│ 3. Install LazyVim + plugins        │
│    (only on first run, ~1-2 min)    │
└──────┬──────────────────────────────┘
       │
       v
┌─────────────────────────────────────┐
│ 4. Load vim-coach.nvim from         │
│    your local directory             │
│    (always uses your latest code!)  │
└──────┬──────────────────────────────┘
       │
       v
┌─────────────────────────────────────┐
│ 5. Open Neovim with full LazyVim    │
│    + your plugin ready to test      │
└─────────────────────────────────────┘
```

### Key Isolation Mechanisms

1. **Custom packpath**: `vim.opt.packpath = temp_dir`
   - Plugins install to temp directory, not your main location

2. **Custom runtime path**: `vim.opt.rtp:prepend(lazypath)`
   - Neovim searches temp directory first

3. **Custom lockfile**: `lockfile = temp_dir .. "/lazy-lock.json"`
   - Plugin versions tracked separately

4. **Local plugin loading**: `dir = plugin_path`
   - Your working directory code is used, not a GitHub version

---

## Directory Structure

### Your Repository
```
vim-coach.nvim/
├── test.sh                    # 🚀 Run this to start testing
├── test/
│   └── minimal_init.lua      # 🔧 LazyVim configuration
├── lua/vim-coach/            # 💻 Your plugin code (edit here!)
│   ├── init.lua
│   └── commands/
├── plugin/
│   └── vim-coach.lua
└── docs/                     # 📚 You are here!
    └── TESTING.md
```

### Temporary Test Environment
```
~/.cache/nvim/vim-coach-test/
├── plugins/                   # All test plugins go here
│   ├── lazy.nvim/            # Package manager
│   ├── LazyVim/              # LazyVim base
│   ├── snacks.nvim/          # Required dependency
│   ├── tokyonight.nvim/      # Colorscheme
│   ├── neo-tree.nvim/        # File explorer
│   └── ...                   # All other LazyVim plugins
└── lazy-lock.json            # Plugin version lockfile
```

**Important**: Your main config at `~/.config/nvim/` is **NEVER** touched!

---

## The Magic Behind test.sh

### Full Script Breakdown

```bash
#!/bin/bash
# Line 1: Shebang - tells system to use bash

# Colors for pretty output
GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[0;33m'
NC='\033[0m'  # No Color (reset)

# Print welcome message
echo -e "${BLUE}=====================================${NC}"
echo -e "${GREEN}vim-coach.nvim Test Environment${NC}"
echo -e "${YELLOW}(LazyVim Edition)${NC}"
echo -e "${BLUE}=====================================${NC}"

# Launch Neovim with custom config
# -u: Use this specific init file
# $(dirname "$0"): Get directory where test.sh is located
# "$@": Pass any additional arguments to nvim
nvim -u "$(dirname "$0")/test/minimal_init.lua" "$@"
```

### Why `$(dirname "$0")`?

- `$0` = path to test.sh script
- `dirname` = extracts directory portion
- Works no matter where you run test.sh from!

Examples:
```bash
# If you run: ./test.sh
# $0 = "./test.sh"
# dirname "$0" = "."
# Full path = "./test/minimal_init.lua"

# If you run: /home/user/vim-coach.nvim/test.sh
# $0 = "/home/user/vim-coach.nvim/test.sh"
# dirname "$0" = "/home/user/vim-coach.nvim"
# Full path = "/home/user/vim-coach.nvim/test/minimal_init.lua"
```

---

## The Magic Behind test/minimal_init.lua

This is where the real magic happens! Let's break it down section by section.

### Section 1: Leader Keys (Lines 4-6)

```lua
vim.g.mapleader = " "
vim.g.maplocalleader = "\\"
```

**Why first?** LazyVim requires leader keys to be set before loading. If you set them after, keymaps won't work correctly!

- `mapleader` = Space (most common choice)
- `maplocalleader` = Backslash (for buffer-local maps)

### Section 2: Temporary Directory Setup (Lines 8-16)

```lua
local temp_dir = vim.fn.stdpath("cache") .. "/vim-coach-test"
local plugin_dir = temp_dir .. "/plugins"

vim.fn.mkdir(plugin_dir, "p")
vim.opt.packpath = temp_dir
```

**What's happening:**
1. `vim.fn.stdpath("cache")` = `~/.cache/nvim` (OS-appropriate cache dir)
2. Creates subdirectory: `~/.cache/nvim/vim-coach-test/plugins`
3. `mkdir(plugin_dir, "p")` = like `mkdir -p`, creates parent dirs too
4. `packpath` = tells Neovim where to find plugins (isolated!)

### Section 3: Install lazy.nvim (Lines 18-31)

```lua
local lazypath = plugin_dir .. "/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  print("Installing lazy.nvim...")
  vim.fn.system({
    "git", "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable",
    lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)
```

**What's happening:**
1. `vim.loop.fs_stat(path)` = checks if path exists (returns nil if not)
2. If lazy.nvim not installed, clone it via git
3. `--filter=blob:none` = shallow clone (faster, smaller)
4. `--branch=stable` = use stable release
5. `rtp:prepend()` = add to runtime path (so Neovim can find it)

**This only runs once!** On subsequent runs, lazy.nvim is already there.

### Section 4: Get Plugin Path (Lines 33-34)

```lua
local plugin_path = vim.fn.fnamemodify(debug.getinfo(1).source:sub(2), ":p:h:h")
```

**This is advanced Lua magic!** Let's break it down:

```lua
debug.getinfo(1).source
-- Returns: "@/path/to/test/minimal_init.lua"

.source:sub(2)
-- Removes @ symbol
-- Returns: "/path/to/test/minimal_init.lua"

vim.fn.fnamemodify(..., ":p:h:h")
-- :p = full path
-- :h = head (remove last component) → "/path/to/test"
-- :h = head again → "/path/to"
-- Result: "/path/to/vim-coach.nvim"
```

**Why?** We need the parent directory of test/ to load the plugin from your working directory!

### Section 5: Setup LazyVim (Lines 36-90)

```lua
require("lazy").setup({
  -- Plugin 1: LazyVim base
  {
    "LazyVim/LazyVim",
    import = "lazyvim.plugins",  -- Load all default LazyVim plugins
    opts = {
      colorscheme = "tokyonight",
    },
  },

  -- Plugin 2: Your local vim-coach.nvim
  {
    dir = plugin_path,  -- Load from local directory, not GitHub!
    name = "vim-coach.nvim",
    dependencies = {
      "folke/snacks.nvim",  -- Required by vim-coach
    },
    config = function()
      require("vim-coach").setup()  -- Initialize the plugin
    end,
    keys = {  -- Lazy-load on these keymaps
      { "<leader>?", "<cmd>VimCoach<cr>", desc = "Vim Coach - All Commands" },
      -- ... more keymaps
    },
  },
}, {
  root = plugin_dir,  -- Install plugins here
  lockfile = temp_dir .. "/lazy-lock.json",  -- Version lock file
  install = { missing = true },  -- Auto-install missing plugins
  checker = { enabled = false },  -- Don't check for updates
})
```

**Key points:**
- `import = "lazyvim.plugins"` loads 40+ default LazyVim plugins
- `dir = plugin_path` loads YOUR code (not from GitHub)
- `config = function()` runs when plugin loads
- `keys = {...}` makes plugin lazy-load (faster startup)

### Section 6: Welcome Message (Lines 92-104)

```lua
vim.defer_fn(function()
  print("\n=== vim-coach.nvim Test Environment (LazyVim) ===")
  -- ... helpful messages
end, 1000)
```

**Why defer?** Waits 1000ms (1 second) so LazyVim finishes loading first, then prints message.

---

## What Gets Installed

### First Run Downloads (~100-200 MB)

1. **lazy.nvim** (Package manager) - ~500 KB
2. **LazyVim** (Neovim distribution) - ~2 MB
3. **Core plugins** (~40 plugins):
   - nvim-treesitter (Syntax highlighting)
   - telescope.nvim (Fuzzy finder)
   - neo-tree.nvim (File explorer)
   - nvim-lspconfig (LSP support)
   - mason.nvim (LSP/tool installer)
   - snacks.nvim (UI utilities)
   - tokyonight.nvim (Colorscheme)
   - And many more...

4. **Treesitter parsers** (~50 MB)
   - For syntax highlighting in various languages

5. **Icons and UI**
   - nvim-web-devicons
   - nui.nvim

### Subsequent Runs
- **0 MB** - Everything already installed!
- Opens instantly
- Only your plugin code reloads

---

## Troubleshooting

### Issue: Plugins not installing on first run

**Symptom**: Neovim opens but looks plain, no LazyVim UI

**Solution**:
```bash
# Inside Neovim:
:Lazy sync

# Or from terminal:
rm -rf ~/.cache/nvim/vim-coach-test/
./test.sh  # Fresh install
```

### Issue: Changes to plugin code not appearing

**Symptom**: Edited lua/vim-coach/init.lua but changes don't show

**Solution**:
```bash
# Inside test environment:
:Lazy reload vim-coach.nvim

# Or just restart:
# Press :qa! then run ./test.sh again
```

### Issue: Error about snacks.nvim not found

**Symptom**: Error message mentions snacks.picker

**Solution**:
```bash
# Inside Neovim:
:Lazy install snacks.nvim
:Lazy sync

# Or delete cache and retry:
rm -rf ~/.cache/nvim/vim-coach-test/
./test.sh
```

### Issue: test.sh permission denied

**Symptom**: `bash: ./test.sh: Permission denied`

**Solution**:
```bash
chmod +x test.sh
./test.sh
```

### Issue: Very slow on macOS

**Symptom**: First run takes 5+ minutes

**Possible causes**:
1. Slow network - downloads ~200 MB of plugins
2. Treesitter compilation - compiles parsers for all languages
3. macOS Gatekeeper - may scan downloaded files

**Solutions**:
```bash
# Check network speed:
# Downloads from: github.com, tree-sitter repos

# Disable some treesitter parsers to speed up:
# Edit test/minimal_init.lua and add to LazyVim opts:
opts = {
  colorscheme = "tokyonight",
  treesitter = {
    ensure_installed = { "lua", "vim", "vimdoc" },  -- Only these
  },
}
```

### Issue: Want to see debug info

**Symptom**: Something's wrong but not sure what

**Solution**:
```bash
# Run with verbose output:
nvim -V9test-debug.log -u test/minimal_init.lua

# Then check the log:
cat test-debug.log
```

### Issue: Completely stuck

**Nuclear option** - Start fresh:
```bash
# Delete entire test environment:
rm -rf ~/.cache/nvim/vim-coach-test/

# Verify it's gone:
ls ~/.cache/nvim/

# Start fresh:
./test.sh
```

---

## Advanced: Customizing the Test Environment

### Change Colorscheme

Edit `test/minimal_init.lua` line 43:
```lua
opts = {
  colorscheme = "catppuccin",  -- or "gruvbox", "nord", etc.
},
```

### Add More Plugins for Testing

Edit `test/minimal_init.lua`, add to the `require("lazy").setup({` block:
```lua
{
  "folke/which-key.nvim",
  config = function()
    require("which-key").setup()
  end,
},
```

### Change Leader Key

Edit `test/minimal_init.lua` line 5:
```lua
vim.g.mapleader = ","  -- Use comma instead of space
```

### Disable LazyVim (Go Minimal)

Comment out LazyVim import in `test/minimal_init.lua`:
```lua
-- {
--   "LazyVim/LazyVim",
--   import = "lazyvim.plugins",
-- },
```

Now you'll only have vim-coach.nvim + snacks.nvim (truly minimal!)

---

## Further Reading

- [LazyVim Documentation](https://lazyvim.org)
- [lazy.nvim Plugin Manager](https://github.com/folke/lazy.nvim)
- [Neovim Documentation](https://neovim.io/doc/)
- [Lua in Neovim Guide](https://github.com/nanotee/nvim-lua-guide)

---

## Questions?

If something's unclear or you hit an issue:
1. Check [DEVELOPMENT.md](DEVELOPMENT.md) for workflow examples
2. Check [ARCHITECTURE.md](ARCHITECTURE.md) to understand the plugin
3. Open an issue on GitHub
4. Ask in discussions!

Happy testing! 🚀
