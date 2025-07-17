# 🎯 vim-coach.nvim

> **Your personal Vim coach - A comprehensive, beginner-friendly command reference for Neovim**

A Neovim plugin that provides an interactive, searchable reference for all Vim commands with detailed explanations,
beginner tips, and context-aware guidance. Perfect for absolute beginners who want to master Vim efficiently.

![Neovim](https://img.shields.io/badge/NeoVim-%2357A143.svg?&style=for-the-badge&logo=neovim&logoColor=white)
![Lua](https://img.shields.io/badge/lua-%232C2D72.svg?style=for-the-badge&logo=lua&logoColor=white)
![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg?style=for-the-badge)

## ✨ Features

- 🔍 **Fuzzy searchable** - Find any command instantly with modern snacks.picker interface
- 📚 **120+ commands** - Comprehensive coverage of Vim motions, editing, visual mode, and plugins
- 🎓 **Beginner-focused** - Detailed explanations with "when to use" guidance
- 🌐 **Context-aware** - Different explanations for file vs explorer vs git contexts
- 💡 **Coaching tips** - Learn WHY and WHEN to use each command
- 📋 **Copy keybinds** - Press Enter or Ctrl+Y to copy commands to clipboard
- 📱 **Modern UI** - Clean interface with text wrapping and enhanced preview
- 🎯 **Categorized** - Browse by command type (motions, editing, visual, plugins)

## 🎪 Demo

```
<leader>? → Opens comprehensive command search
<leader>hm → Motion commands (h,j,k,l,w,b,f,etc.)
<leader>he → Editing commands (i,a,d,c,y,p,etc.)
<leader>hv → Visual mode commands
<leader>hp → Plugin-specific commands
<leader>hl → Lazyvim* commands (when enabled)
<leader>hn → NvChad* commands (when enabled)
```

## 📦 Installation

### [lazy.nvim](https://github.com/folke/lazy.nvim) (Recommended)

```lua
{
  "shahshlok/vim-coach.nvim",
  dependencies = {
    -- Install one of preferred picker
    -- Snacks
    "folke/snacks.nvim",
    -- OR
    -- Telescope
    "nvim-telescope/telescope.nvim",
    "nvim-lua/plenary.nvim",
  },
  opts = {},
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
    -- Install one of preferred picker
    -- Snacks
    "folke/snacks.nvim",
    -- OR
    -- Telescope
    "nvim-telescope/telescope.nvim",
    "nvim-lua/plenary.nvim",
  },
  config = function()
    require("vim-coach").setup()
  end
}
```

### [vim-plug](https://github.com/junegunn/vim-plug)

```vim
-- Install one of preferred picker
-- Snacks
Plug 'folke/snacks.nvim'
-- OR
-- Telescope
Plug 'nvim-telescope/telescope.nvim'
Plug 'nvim-lua/plenary.nvim'

Plug 'shahshlok/vim-coach.nvim'

" In your init.lua or init.vim:
lua require('vim-coach').setup()
```

## 🚀 Usage

### Commands

| Command             | Description           |
| ------------------- | --------------------- |
| `:VimCoach`         | Open all commands     |
| `:VimCoach motions` | Motion commands only  |
| `:VimCoach editing` | Editing commands only |
| `:VimCoach visual`  | Visual mode commands  |
| `:VimCoach plugins` | Plugin commands       |
| `:VimCoach lazyvim` | Lazyvim\* commands    |
| `:VimCoach nvchad`  | NvChad\* commands     |
| `:Coach`            | Alias for `:VimCoach` |

### Default Keybindings

| Key          | Command             | Description             |
| ------------ | ------------------- | ----------------------- |
| `<leader>?`  | `:VimCoach`         | Open comprehensive help |
| `<leader>hm` | `:VimCoach motions` | Motion commands         |
| `<leader>he` | `:VimCoach editing` | Editing commands        |
| `<leader>hv` | `:VimCoach visual`  | Visual mode commands    |
| `<leader>hp` | `:VimCoach plugins` | Plugin commands         |
| `<leader>hl` | `:VimCoach lazyvim` | Lazyvim\* commands      |
| `<leader>hn` | `:VimCoach nvchad`  | NvChad\* commands       |
| `<leader>hh` | `:VimCoach all`     | All commands            |

### In the Picker

| Key      | Action                    |
| -------- | ------------------------- |
| `Enter`  | Copy keybind to clipboard |
| `Ctrl+Y` | Copy keybind to clipboard |
| `Esc`    | Close picker              |

## ⚙️ Configuration

```lua
require("vim-coach").setup({
  -- Disable default keymaps
  -- Set vim.g.vim_coach_no_default_keymaps = 1 before setup

  window = {
    border = "rounded",
    title_pos = "center",
  },
  picker = "snacks", -- "snacks" (Default) | "telescope"
  distro_commands = {
    lazyvim = false,
    nvchad = false,
  },
  keymaps = {
    copy_keymap = "<C-y>",
    close = "<Esc>",
  },
  user_commands = {} -- Custom user commands
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

### 📋 Custom User Commands

1. A user can add their own commands or edit existing commands in the `user_commands` table in the plugin config.

2. Follow this format:

```lua
<category_name> = {
    {
    name = "Command Name",
    keybind = "key",
    modes = {"n", "v"},
    explanation = "What the command does",
    beginner_tip = "Helpful tip for beginners",
    when_to_use = "When this command is most useful",
    context_notes = {
        file = "Behavior in files",
        explorer = "Behavior in explorers",
    },
    examples = {"example1", "example2"}
    },
    ...,
},
...,
```

3. The `user_commands` table is merged with the default commands, so if a command already exists, it will be
   overwritten.

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

| Category     | Count | Description                                           |
| ------------ | ----- | ----------------------------------------------------- |
| **Motions**  | 20+   | Movement commands (h,j,k,l,w,b,f,etc.)                |
| **Editing**  | 30+   | Text manipulation (i,a,d,c,y,p,etc.)                  |
| **Visual**   | 25+   | Selection and visual mode operations                  |
| **Plugins**  | 25+   | Common plugin commands (telescope, snacks, git, etc.) |
| **Layvim\*** | 1+    | Lazyvim commands                                      |
| **Nvchad\*** | 1+    | NvChad commands                                       |

## 🛠️ Requirements

- Neovim >= 0.7
- Choose a picker. Either:
  - [snacks.nvim](https://github.com/folke/snacks.nvim) (with picker support)
- OR:
  - [telescope.nvim](https://github.com/nvim-telescope/telescope.nvim)
  - [plenary.nvim](https://github.com/nvim-lua/plenary.nvim)

## 🤝 Contributing

We welcome contributions!

### Reporting Issues

- 🐛 Found a bug? [Open an issue](https://github.com/your-username/vim-coach.nvim/issues)
- 💡 Have a suggestion? [Start a discussion](https://github.com/your-username/vim-coach.nvim/discussions)
- 📝 Missing a command? [Request it](https://github.com/your-username/vim-coach.nvim/issues)

## 📄 License

MIT License - see [LICENSE](LICENSE) file for details.

## 🙏 Acknowledgments

- Built with [snacks.nvim](https://github.com/folke/snacks.nvim) and/or
  [telescope.nvim](https://github.com/nvim-telescope/telescope.nvim)
- Inspired by the need for better Vim learning resources
- Created for the Neovim community

## ⭐ Show Your Support

If this plugin helps you learn Vim, please give it a star! ⭐

---

**Happy Vimming!** 🎉

_"The best way to learn Vim is with a good coach by your side."_
