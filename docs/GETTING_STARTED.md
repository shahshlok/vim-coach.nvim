# Getting Started with vim-coach.nvim

Welcome! This guide is designed for **complete beginners** with no experience in Lua, Neovim, or plugin development. We'll walk through everything step-by-step.

## Table of Contents

1. [What You Need to Know](#what-you-need-to-know)
2. [Prerequisites](#prerequisites)
3. [Installation](#installation)
4. [First Use](#first-use)
5. [Basic Configuration](#basic-configuration)
6. [Next Steps](#next-steps)

---

## What You Need to Know

### What is Neovim?

**Neovim** is a modern version of Vim, a text editor that many programmers use. It's known for being very fast and powerful, but also has a steep learning curve—there are many commands to memorize.

**This is exactly why vim-coach.nvim exists!** It helps you remember Vim commands.

### What is Lua?

**Lua** is a simple programming language. Think of it like instructions you write to customize your editor. Don't worry if you've never coded before—we'll show you exactly what to copy and paste!

### What is a "plugin"?

A **plugin** is like an app for Neovim. It adds new features or improvements. vim-coach.nvim is a plugin that adds a searchable command reference menu.

### What is a "plugin manager"?

A **plugin manager** is software that automatically downloads and installs plugins for you. The most popular one is called **lazy.nvim**. It's like an app store for Neovim plugins.

---

## Prerequisites

Before we start, you need:

1. **Neovim** installed (version 0.7 or newer)
2. **A text editor** to edit your Neovim configuration file
3. **Terminal access** (to run commands and restart Neovim)

### Check if You Have Neovim

Open your terminal and type:

```bash
nvim --version
```

If you see a version number like `NVIM v0.9.0`, you have Neovim installed. ✓

**If not**, [install Neovim](https://github.com/neovim/neovim/wiki/Installing-Neovim).

---

## Installation

### Step 1: Find Your Neovim Configuration File

Neovim looks for a configuration file in a specific location on your computer. The path depends on your operating system.

#### On Mac or Linux:

The file is usually at:
```
~/.config/nvim/init.lua
```

This file might not exist yet—that's okay, we'll create it if needed.

#### On Windows:

The file is usually at:
```
%APPDATA%\nvim\init.lua
```

### Step 2: Install a Plugin Manager (if you don't have one)

Most people use **lazy.nvim**. Here's how to set it up:

1. Open your `init.lua` file in any text editor
2. Add this code at the **very beginning** of the file:

```lua
-- Bootstrap lazy.nvim
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
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

-- Setup lazy.nvim
require("lazy").setup("plugins", {
  -- options here
})
```

Don't understand what this means? That's okay! Just copy and paste it. We're telling Neovim to automatically download lazy.nvim.

### Step 3: Create a Plugins Folder

1. Open your terminal
2. Navigate to your Neovim config directory:

```bash
# Mac/Linux:
cd ~/.config/nvim

# Windows (use forward slashes):
cd %APPDATA%\nvim
```

3. Create a `plugins` folder:

```bash
mkdir plugins
```

### Step 4: Add vim-coach.nvim

1. Inside the `plugins` folder, create a new file called `vim-coach.lua`
2. Add this code:

```lua
return {
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

**What does this mean?**
- `"shahshlok/vim-coach.nvim"` - This tells lazy.nvim where to find the plugin
- `dependencies = { "folke/snacks.nvim" }` - vim-coach needs snacks.nvim to work, so install it too
- `config = function() ... end` - This code runs when vim-coach loads
- `keys = { ... }` - This creates a keyboard shortcut

### Step 5: Restart Neovim

1. Close Neovim (type `:q` and press Enter, or use `Ctrl+D`)
2. Reopen Neovim by typing `nvim` in your terminal
3. Wait a few seconds—lazy.nvim is downloading the plugins

You should see a message like `Lazy.nvim installing plugins...`

If you see errors, see the [Troubleshooting Guide](TROUBLESHOOTING.md).

---

## First Use

### Opening vim-coach

Press this key combination:
```
<leader>?
```

**What's `<leader>`?**

In Vim/Neovim, `<leader>` is a special key you configure. By default, it's the spacebar. So the shortcut is:

```
Space + ?
```

or

```
Hold Spacebar, then press Shift+/
```

### You Should See

A menu appears showing Vim commands with descriptions:

```
┌─ vim-coach ─────────────────────────┐
│  j - Move down one line             │
│  k - Move up one line               │
│  w - Jump to next word              │
│  b - Jump to previous word          │
│  [search box with cursor] █          │
└─────────────────────────────────────┘
```

### Try These Actions

1. **Type to search:** Type `delete` to find delete commands
2. **Move around:** Press `j` to go down, `k` to go up
3. **Copy a command:** Press `Enter` or `Ctrl+Y` to copy
4. **Close menu:** Press `Esc`

Congratulations! You've successfully installed and used vim-coach.nvim!

---

## Basic Configuration

### Understand the Default Setup

Your current setup already works great! But you can customize it. Here's what each part does:

```lua
return {
  "shahshlok/vim-coach.nvim",                    -- Plugin name
  
  dependencies = { "folke/snacks.nvim" },        -- Required dependency
  
  config = function()                            -- Setup code
    require("vim-coach").setup()                 -- Initialize plugin
  end,
  
  keys = {                                       -- Keyboard shortcuts
    { "<leader>?", "<cmd>VimCoach<cr>", desc = "Vim Coach" },
  },
}
```

### Common Customizations

#### Change the Keyboard Shortcut

Don't like `<leader>?`? Change it:

```lua
keys = {
  { "<leader>h", "<cmd>VimCoach<cr>", desc = "Vim Coach" },  -- Now <leader>h opens vim-coach
},
```

#### Customize the Window

```lua
config = function()
  require("vim-coach").setup({
    window = {
      border = "double",      -- Options: none, single, double, rounded, etc.
      title_pos = "left",     -- Options: left, center, right
    },
  })
end,
```

#### Add Quick Category Shortcuts

Want quick shortcuts for specific categories? Try this:

```lua
keys = {
  { "<leader>?", "<cmd>VimCoach<cr>", desc = "All Vim Commands" },
  { "<leader>wm", "<cmd>VimCoach motions<cr>", desc = "Motion Commands" },
  { "<leader>we", "<cmd>VimCoach editing<cr>", desc = "Editing Commands" },
},
```

Now you can press `<leader>wm` to see only motion commands!

---

## Next Steps

### Learn Vim Commands

Now that vim-coach is installed, use it to learn Vim! Every time you forget a command:

1. Press `<leader>?`
2. Search for what you want
3. Press `Enter` to copy
4. Use the command!

### Suggested Learning Path

1. **Start with motions:** `:VimCoach motions` - Learn how to move around
2. **Learn editing:** `:VimCoach editing` - Learn how to edit text
3. **Explore visual mode:** `:VimCoach visual` - Learn multi-line editing
4. **Discover plugins:** `:VimCoach plugins` - Learn plugin commands

### Advanced: Deeper Vim Learning

Once you're comfortable with vim-coach:

- Read the [Full Documentation](README.md)
- Learn about [Configuration](CONFIGURATION.md)
- Explore [How vim-coach Works](ARCHITECTURE.md)
- Check out the [API Reference](API_REFERENCE.md)

### Customization

Want to customize vim-coach further?

- [Configuration Guide](CONFIGURATION.md) - All customization options
- [Advanced Setup](docs/ADVANCED_SETUP.md) - More complex customizations

### Contributing

Want to help improve vim-coach?

- [Contributing Guide](CONTRIBUTING.md) - How to contribute
- [Development Setup](DEVELOPMENT.md) - Set up a development environment

---

## Troubleshooting

### "vim-coach command not found"

This means Neovim isn't finding the plugin. Try:

1. Check that `plugins/vim-coach.lua` exists
2. Restart Neovim completely
3. Try `:Lazy` to see if the plugin loaded

### "snacks.nvim not found"

lazy.nvim should install it automatically. Try:

1. Run `:Lazy sync` to manually install all plugins
2. Restart Neovim
3. Try again

### The menu doesn't open

Make sure:
1. Neovim has fully loaded (wait a few seconds)
2. You're pressing the right key (`Space+?`)
3. Run `:VimCoach` as a command instead

### Something else went wrong

Check the full [Troubleshooting Guide](TROUBLESHOOTING.md)

---

## What's Next?

You now have a powerful tool to learn Vim commands! The next step is to explore the other documentation:

- **Already comfortable?** → Read [Full Documentation](README.md)
- **Want to customize it?** → Read [Configuration Guide](CONFIGURATION.md)
- **Curious how it works?** → Read [Architecture Guide](ARCHITECTURE.md)
- **Want to help?** → Read [Contributing Guide](CONTRIBUTING.md)

---

## Questions?

If you have questions not covered here:

1. Check the [Troubleshooting Guide](TROUBLESHOOTING.md)
2. Read the [Full Documentation](README.md)
3. Search existing issues on GitHub
4. Open a new issue describing your problem

Welcome to the vim-coach community! Happy learning!
