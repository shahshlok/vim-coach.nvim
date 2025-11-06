# 🎯 vim-coach.nvim

> **Your personal Vim coach - A comprehensive, beginner-friendly command reference for Neovim**

A Neovim plugin that provides an interactive, searchable reference for all Vim commands with detailed explanations, beginner tips, and context-aware guidance. Perfect for absolute beginners who want to master Vim efficiently.

![Neovim](https://img.shields.io/badge/NeoVim-%2357A143.svg?&style=for-the-badge&logo=neovim&logoColor=white)
![Lua](https://img.shields.io/badge/lua-%232C2D72.svg?style=for-the-badge&logo=lua&logoColor=white)
![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg?style=for-the-badge)

## 📖 Table of Contents

- [Features](#-features)
- [Quick Start](#-quick-start)
- [Why vim-coach.nvim?](#-why-vim-coachnvim)
- [Installation](#-installation)
- [Usage](#-usage)
- [Configuration](#️-configuration)
- [Command Categories](#-command-categories)
- [Documentation](#-documentation)
- [Contributing](#-contributing)
- [Roadmap](#️-roadmap)
- [License](#-license)

## ✨ Features

- 🔍 **Fuzzy searchable** - Find any command instantly with modern snacks.picker interface
- 📚 **120+ commands** - Comprehensive coverage of Vim motions, editing, visual mode, and plugins
- 🎓 **Beginner-focused** - Detailed explanations with "when to use" guidance
- 🌐 **Context-aware** - Different explanations for file vs explorer vs git contexts
- 💡 **Coaching tips** - Learn WHY and WHEN to use each command
- 📋 **Copy keybinds** - Press Enter or Ctrl+Y to copy commands to clipboard
- 📱 **Modern UI** - Clean interface with text wrapping and enhanced preview
- 🎯 **Categorized** - Browse by command type (motions, editing, visual, plugins)

## 🚀 Quick Start

```lua
-- Install with lazy.nvim
{
  "shahshlok/vim-coach.nvim",
  dependencies = { "folke/snacks.nvim" },
  config = function()
    require("vim-coach").setup()
  end,
  keys = {
    { "<leader>?", "<cmd>VimCoach<cr>", desc = "Vim Coach" },
  },
}
```

Then in Neovim:
- Press `<leader>?` (usually Space + ?) to open the command picker
- Type to search (e.g., "delete", "dd", "motion")
- Press `Enter` to copy the keybind to clipboard
- Start using Vim commands like a pro!

## 🤔 Why vim-coach.nvim?

Learning Vim can be overwhelming. You've probably experienced:

- 😵 **Information overload** - `:help` is comprehensive but intimidating for beginners
- 🤷 **Not knowing what exists** - Hard to discover commands you don't know about
- ❓ **Understanding when to use what** - Knowing a command exists ≠ knowing when to use it
- 🔍 **Slow lookup** - Context switching to docs breaks your flow

**vim-coach.nvim solves this by providing:**

✅ **Instant, searchable reference** - Find commands as fast as you can think of them
✅ **Beginner-friendly explanations** - Not just "what" but "why" and "when"
✅ **Context-aware guidance** - Commands behave differently in different contexts
✅ **Practical examples** - See real usage, not just syntax
✅ **Zero context switching** - Stay in your editor, stay in flow

Unlike cheatsheets (static, hard to search) or `:help` (comprehensive but dense), vim-coach.nvim is your **interactive learning companion** that grows with you.

## 🎪 Demo

**Default Keybindings:**
```
<leader>? → Opens comprehensive command search
<leader>hm → Motion commands (h,j,k,l,w,b,f,etc.)
<leader>he → Editing commands (i,a,d,c,y,p,etc.)
<leader>hv → Visual mode commands
<leader>hp → Plugin-specific commands
```

**Search Examples:**
```
Type "delete" → Shows: Delete Line (dd), Delete Word (dw), etc.
Type "dd" → Shows: Delete Line command with full explanation
Type "motion" → Shows all movement-related commands
```

> **Note**: Screenshots coming soon! Want to contribute? See [Contributing](#-contributing)

## 📦 Installation

### [lazy.nvim](https://github.com/folke/lazy.nvim) (Recommended)

```lua
{
  "shahshlok/vim-coach.nvim",
  dependencies = {
    "folke/snacks.nvim",
  },
  config = function()
    require("vim-coach").setup()
  end,
  keys = {
    { "<leader>?", "<cmd>VimCoach<cr>", desc = "Vim Coach" },
  },
}
```

### [packer.nvim](https://github.com/wbthomason/packer.nvim)

```lua
use {
  "shahshlok/vim-coach.nvim",
  requires = {
    "folke/snacks.nvim",
  },
  config = function()
    require("vim-coach").setup()
  end
}
```

### [vim-plug](https://github.com/junegunn/vim-plug)

```vim
Plug 'folke/snacks.nvim'
Plug 'shahshlok/vim-coach.nvim'

" In your init.lua or init.vim:
lua require('vim-coach').setup()
```

## 🚀 Usage

### Commands

| Command | Description |
|---------|-------------|
| `:VimCoach` | Open all commands |
| `:VimCoach motions` | Motion commands only |
| `:VimCoach editing` | Editing commands only |
| `:VimCoach visual` | Visual mode commands |
| `:VimCoach plugins` | Plugin commands |
| `:Coach` | Alias for `:VimCoach` |

### Default Keybindings

| Key | Command | Description |
|-----|---------|-------------|
| `<leader>?` | `:VimCoach` | Open comprehensive help |
| `<leader>hm` | `:VimCoach motions` | Motion commands |
| `<leader>he` | `:VimCoach editing` | Editing commands |
| `<leader>hv` | `:VimCoach visual` | Visual mode commands |
| `<leader>hp` | `:VimCoach plugins` | Plugin commands |
| `<leader>hh` | `:VimCoach all` | All commands |

### In the Picker

| Key | Action |
|-----|--------|
| `Enter` | Copy keybind to clipboard |
| `Ctrl+Y` | Copy keybind to clipboard |
| `Esc` | Close picker |

## ⚙️ Configuration

```lua
require("vim-coach").setup({
  -- Disable default keymaps
  -- Set vim.g.vim_coach_no_default_keymaps = 1 before setup
  
  window = {
    border = "rounded",
    title_pos = "center",
  },
  keymaps = {
    copy_keymap = "<C-y>",
    close = "<Esc>",
  },
})
```

### Disable Default Keymaps

If you want to set your own keymaps:

```lua
vim.g.vim_coach_no_default_keymaps = 1
require("vim-coach").setup()

-- Set your own keymaps
vim.keymap.set('n', '<F1>', '<cmd>VimCoach<cr>', { desc = 'Vim Coach' })
```

## 🎯 What Makes This Different?

Unlike other cheatsheet plugins, vim-coach.nvim provides:

### 📖 Comprehensive Explanations
```
Delete Line (dd)
├─ What: Deletes entire current line  
├─ When: Removing code lines, empty lines
├─ Tip: Cursor can be anywhere on the line
├─ Context: In file: removes code | In explorer: may delete files
└─ Examples: dd, 2dd (delete 2 lines)
```

### 🧠 Beginner Coaching
- **WHY** use each command
- **WHEN** it's most effective  
- **WHERE** it works (file vs explorer context)
- **HOW** it differs from similar commands

### 🔍 Smart Search
- Search by command name: "delete line"
- Search by keybind: "dd"
- Search by purpose: "remove text"
- Fuzzy matching finds everything

## 📚 Command Categories

| Category | Count | Description |
|----------|-------|-------------|
| **Motions** | 20+ | Movement commands (h,j,k,l,w,b,f,etc.) |
| **Editing** | 30+ | Text manipulation (i,a,d,c,y,p,etc.) |
| **Visual** | 25+ | Selection and visual mode operations |
| **Plugins** | 25+ | Common plugin commands (telescope, git, etc.) |

## 📖 Documentation

We've created comprehensive documentation for both beginners and experienced developers!

### For Users

**[Main README](README.md)** (you are here!)
- Installation and usage
- Configuration options
- Feature overview

### For Contributors

#### 🌱 Beginner-Friendly

Perfect if you're new to Neovim plugin development:

- **[Contributing Guide](docs/CONTRIBUTING.md)** - Start here! Complete guide to contributing
- **[Development Workflow](docs/DEVELOPMENT.md)** - Step-by-step development tasks and examples
- **[Testing Guide](docs/TESTING.md)** - Deep dive into the testing environment
- **[Architecture](docs/ARCHITECTURE.md)** - How the plugin works internally

#### ⚡ For Experienced Developers

Get up to speed quickly:

- **[Quick Start](docs/QUICK_START.md)** - TL;DR for experienced Neovim plugin devs
- **[Technical Reference](docs/TECHNICAL.md)** - Performance, optimization, advanced patterns

**[📚 Full Documentation Index](docs/README.md)**

## 🛠️ Requirements

- **Neovim** >= 0.7
- **[snacks.nvim](https://github.com/folke/snacks.nvim)** - For picker UI (auto-installed as dependency)

## 🤝 Contributing

We ❤️ contributions! vim-coach.nvim aims to be a welcoming project for developers of all skill levels.

### Quick Start for Contributors

```bash
# 1. Fork and clone
git clone https://github.com/YOUR_USERNAME/vim-coach.nvim.git
cd vim-coach.nvim

# 2. Run the isolated test environment
./test.sh

# 3. Make your changes and test
# Edit files, then ./test.sh to test

# 4. Submit a pull request!
```

### Ways to Contribute

- ✅ **Add commands** - Expand the command database ([Guide](docs/DEVELOPMENT.md#adding-a-new-command))
- 🐛 **Fix bugs** - Check [open issues](https://github.com/shahshlok/vim-coach.nvim/issues)
- 📝 **Improve docs** - Help make docs clearer
- ✨ **Add features** - Propose ideas in [discussions](https://github.com/shahshlok/vim-coach.nvim/discussions)
- 🧪 **Add tests** - Help build automated testing
- 🎨 **Improve UI** - Make the picker even better

### New to Contributing?

Check out our **[Contributing Guide](docs/CONTRIBUTING.md)** - it's beginner-friendly and walks you through everything!

**Documentation:**
- [Contributing Guide](docs/CONTRIBUTING.md) - Complete guide for new contributors
- [Development Workflow](docs/DEVELOPMENT.md) - How to make changes
- [Testing Guide](docs/TESTING.md) - Understanding the test environment
- [Architecture](docs/ARCHITECTURE.md) - How the code works

### Reporting Issues

- 🐛 **Found a bug?** [Open an issue](https://github.com/shahshlok/vim-coach.nvim/issues)
- 💡 **Have an idea?** [Start a discussion](https://github.com/shahshlok/vim-coach.nvim/discussions)
- 📝 **Missing a command?** [Request it](https://github.com/shahshlok/vim-coach.nvim/issues)

## 📄 License

MIT License - see [LICENSE](LICENSE) file for details.

## 🗺️ Roadmap

Planned features and improvements:

- [ ] **Interactive Tutorial Mode** - Guided lessons for beginners
- [ ] **Command History** - Track your most-used commands
- [ ] **Custom Command Sources** - Load commands from external files
- [ ] **Telescope Integration** - Alternative picker option
- [ ] **Treesitter Integration** - Context-aware suggestions
- [ ] **Command Relationships** - Show related/similar commands
- [ ] **Automated Tests** - CI/CD with test coverage
- [ ] **Screenshots/GIFs** - Visual documentation
- [ ] **Localization** - Multi-language support

Want to work on any of these? Check out [open issues](https://github.com/shahshlok/vim-coach.nvim/issues) or [start a discussion](https://github.com/shahshlok/vim-coach.nvim/discussions)!

## 🙏 Acknowledgments

- Built with [snacks.nvim](https://github.com/folke/snacks.nvim) by [@folke](https://github.com/folke)
- Inspired by the need for better Vim learning resources
- Created for the Neovim community with ❤️
- Thanks to all [contributors](https://github.com/shahshlok/vim-coach.nvim/graphs/contributors)!

## 🌟 Show Your Support

If vim-coach.nvim helps you master Vim:
- ⭐ **Star this repo** on GitHub
- 🐛 **Report bugs** or suggest features
- 💬 **Share** with other Vim learners
- 🤝 **Contribute** - all skill levels welcome!

---

## 💬 Community

- **Issues**: [Bug reports & feature requests](https://github.com/shahshlok/vim-coach.nvim/issues)
- **Discussions**: [Questions & ideas](https://github.com/shahshlok/vim-coach.nvim/discussions)
- **Pull Requests**: [Contributions welcome!](https://github.com/shahshlok/vim-coach.nvim/pulls)

---

**Happy Vimming!** 🎉

> *"The best way to learn Vim is with a good coach by your side."*

---

<div align="center">
  Made with ❤️ by the Neovim community
  <br><br>
  <sub>If you find this useful, consider starring ⭐ the repo!</sub>
</div>
