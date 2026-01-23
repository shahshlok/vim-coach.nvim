# vim-coach.nvim

![Neovim](https://img.shields.io/badge/NeoVim-%2357A143.svg?&style=for-the-badge&logo=neovim&logoColor=white)
![Lua](https://img.shields.io/badge/lua-%232C2D72.svg?style=for-the-badge&logo=lua&logoColor=white)
![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg?style=for-the-badge)

## What is vim-coach.nvim?

**vim-coach.nvim** is a helpful assistant that lives inside Neovim. It's like having a cheat sheet for Vim commands built right into your editor!

Forget Vim commands? Don't remember if it's `w` or `W` to jump words? Just press `<leader>?` and a searchable menu pops up with:
- **What** each command does (in plain English)
- **When** to use it (practical scenarios)
- **Why** it's useful (context and tips)
- **How** to use it (examples)

Then you can copy the keybind directly with one keystroke. Learning Vim has never been easier!

---

## How It Works (Visual Guide)

```
┌─────────────────────────────────────────────────────────┐
│  Your Neovim Editor                                     │
│                                                          │
│  You press: <leader>?                                   │
│                     ↓                                    │
│  ┌──────────────────────────────────────────────────┐   │
│  │  vim-coach Picker Menu                            │   │
│  │  ─────────────────────────────────────────────── │   │
│  │  ○ j - Move down one line                       │   │
│  │  ○ k - Move up one line                         │   │
│  ○ w - Jump to next word                           │   │
│  │  ○ b - Jump to previous word                    │   │
│  │  ○ d - Delete (with motion)                     │   │
│  │                                                   │   │
│  │  [Type to search] █                              │   │
│  └──────────────────────────────────────────────────┘   │
│                     ↓                                    │
│  Press Enter or Ctrl+Y to copy "dw" to clipboard      │
│                                                          │
└─────────────────────────────────────────────────────────┘
```

---

## Features

What makes vim-coach.nvim special:

- **Smart Search** - Fuzzy search through hundreds of Vim commands instantly
- **Clear Explanations** - Each command explained with "what/when/why" in beginner-friendly language
- **Fast** - Find what you need in seconds, not minutes
- **Copy Commands** - Press Enter to copy keybinds to your clipboard
- **Clean Interface** - Beautiful, easy-to-read picker menu
- **Works Out-of-Box** - No complicated setup, just install and use
- **Organized** - Commands grouped into categories: Motions, Editing, Visual, Plugins

---

## Quick Start (3 Minutes)

### Step 1: Install the Plugin

If you're using **lazy.nvim** (most common):

```lua
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

**Don't know what this means?** See [Getting Started Guide](docs/GETTING_STARTED.md) for detailed step-by-step instructions.

### Step 2: Restart Neovim

After adding the plugin config, restart your editor.

### Step 3: Use It!

Press `<leader>?` (usually `Space + ?`) to open vim-coach and start learning!

---

## Usage

### Opening vim-coach

Method 1: Keyboard shortcut
```
Press: <leader>?  (usually Space + ?)
```

Method 2: Vim command
```
:VimCoach
```

### Inside the Picker Menu

| Key | Action |
|-----|--------|
| `Enter` or `Ctrl+Y` | Copy the keybind to clipboard |
| `Esc` | Close the menu |
| Type anything | Search for commands (e.g., type "delete" to find delete commands) |
| `j` / `k` | Move up/down in list |

### Filter by Category

Want to only see motion commands? Use:

```vim
:VimCoach motions
```

Available categories: `all`, `motions`, `editing`, `visual`, `plugins`

---

## Configuration (Optional)

Want to customize vim-coach? Here's how:

```lua
require("vim-coach").setup({
  -- Customize the window appearance
  window = {
    border = "rounded",      -- Can be: none, single, double, rounded, etc.
    title_pos = "center",    -- Window title position
  },
  
  -- Customize keyboard shortcuts
  keymaps = {
    copy_keymap = "<C-y>",   -- Change copy shortcut
    close = "<Esc>",         -- Change close shortcut
  },
})

-- Don't want default keymaps? Disable them:
vim.g.vim_coach_no_default_keymaps = 1
```

**New to Neovim configuration?** Check out the [Configuration Guide](docs/CONFIGURATION.md).

---

## Requirements

- **Neovim** 0.7 or newer (check with `:version`)
- **snacks.nvim** (automatically installed by lazy.nvim)

---

## Documentation

Start here based on your experience level:

### Complete Beginner?
- **[Getting Started Guide](docs/GETTING_STARTED.md)** - Start here! Setup from scratch, Lua basics, Neovim intro

### Ready to Use It?
- **[Quick Start](docs/QUICK_START.md)** - Install and start using vim-coach in 5 minutes
- **[Configuration Guide](docs/CONFIGURATION.md)** - Customize vim-coach to your preferences

### Want to Learn More?
- **[Full Documentation](docs/README.md)** - Complete guide and overview
- **[How vim-coach Works](docs/ARCHITECTURE.md)** - Guide to architecture (beginner-friendly!)
- **[API Reference](docs/API_REFERENCE.md)** - For developers adding features

### Want to Contribute?
- **[Contributing Guide](docs/CONTRIBUTING.md)** - How to help make vim-coach better
- **[Development Setup](docs/DEVELOPMENT.md)** - Set up development environment
- **[Code Guide](docs/CODE_GUIDE.md)** - Understand the codebase

### Advanced
- **[Testing Guide](docs/TESTING.md)** - Writing and running tests
- **[Technical Details](docs/TECHNICAL.md)** - Deep dive into implementation

---

## Examples

### Example 1: Finding How to Delete Words

**Scenario:** You keep forgetting the command to delete a word.

1. Press `<leader>?` to open vim-coach
2. Type `delete word` in the search box
3. You see: `dw - Delete to end of word`
4. Press `Enter` to copy it
5. Now `dw` is in your clipboard—paste it anywhere!

### Example 2: Searching for a Command

**Scenario:** You know it involves the letter 'v' but can't remember what.

1. Press `<leader>?`
2. Type `v` in search
3. See all commands with 'v': visual mode, various motions, etc.
4. Read the explanations and pick what you need

### Example 3: Learning Visual Mode Commands

**Scenario:** You want to learn visual mode commands today.

1. Press `:VimCoach visual`
2. See all visual mode commands in one place
3. Read through them to learn!

---

## Local Testing

Want to try vim-coach in a sandboxed environment before installing it?

```bash
./test.sh --lazyvim    # Full environment
# or
./test.sh --minimal    # Minimal setup
```

For more details, see [Testing Guide](docs/TESTING.md).

---

## Troubleshooting

### "vim-coach command not found"
See [Troubleshooting Guide](docs/TROUBLESHOOTING.md)

### "I don't understand how to install this"
See [Getting Started Guide](docs/GETTING_STARTED.md) - it has step-by-step instructions

### Something else?
Check [Troubleshooting Guide](docs/TROUBLESHOOTING.md) or open an issue

---

## Contributing

We'd love your help! Whether you want to:
- Add new commands to the database
- Improve explanations
- Fix bugs
- Add features

Start with [Contributing Guide](docs/CONTRIBUTING.md).

---

## License

MIT — see `LICENSE`.

---

## Questions?

- Read the docs
- Search for your question in existing issues
- Open a new issue if you can't find an answer
