-- LazyVim-based test environment for vim-coach.nvim
-- This creates an isolated LazyVim environment that won't affect your main Neovim config

-- Set leader keys before loading LazyVim (required)
vim.g.mapleader = " "
vim.g.maplocalleader = "\\"

-- Set up temporary paths for plugins
local temp_dir = vim.fn.stdpath("cache") .. "/vim-coach-test"
local plugin_dir = temp_dir .. "/plugins"

-- Create directories if they don't exist
vim.fn.mkdir(plugin_dir, "p")

-- Set packpath to use our temporary directory
vim.opt.packpath = temp_dir

-- Clone/install lazy.nvim if not present
local lazypath = plugin_dir .. "/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  print("Installing lazy.nvim...")
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

-- Get the path to the vim-coach.nvim repo (parent of test directory)
local plugin_path = vim.fn.fnamemodify(debug.getinfo(1).source:sub(2), ":p:h:h")

-- Set up LazyVim with your plugin
require("lazy").setup({
  -- Import LazyVim base (this gives you the full LazyVim experience)
  {
    "LazyVim/LazyVim",
    import = "lazyvim.plugins",
    opts = {
      colorscheme = "tokyonight",
      -- Disable LazyVim keymaps that might conflict
      defaults = {
        keymaps = true,
      },
    },
  },

  -- Load vim-coach.nvim from local directory
  {
    dir = plugin_path,
    name = "vim-coach.nvim",
    dependencies = {
      "folke/snacks.nvim", -- Required dependency
    },
    config = function()
      require("vim-coach").setup()
    end,
    -- Add keymaps for easy access
    keys = {
      { "<leader>?", "<cmd>VimCoach<cr>", desc = "Vim Coach - All Commands" },
      { "<leader>hm", "<cmd>VimCoach motions<cr>", desc = "Vim Coach - Motions" },
      { "<leader>he", "<cmd>VimCoach editing<cr>", desc = "Vim Coach - Editing" },
      { "<leader>hv", "<cmd>VimCoach visual<cr>", desc = "Vim Coach - Visual" },
      { "<leader>hp", "<cmd>VimCoach plugins<cr>", desc = "Vim Coach - Plugins" },
    },
  },
}, {
  root = plugin_dir,
  lockfile = temp_dir .. "/lazy-lock.json",
  install = {
    missing = true,
  },
  checker = {
    enabled = false, -- Don't check for updates in test environment
  },
  performance = {
    rtp = {
      disabled_plugins = {
        "gzip",
        "tarPlugin",
        "tohtml",
        "tutor",
        "zipPlugin",
      },
    },
  },
})

-- Print helpful message
vim.defer_fn(function()
  print("\n=== vim-coach.nvim Test Environment (LazyVim) ===")
  print("Plugin loaded from: " .. plugin_path)
  print("\nTry these commands:")
  print("  :VimCoach         - Open all commands")
  print("  <leader>?         - Open all commands (space + ?)")
  print("  <leader>hm        - Motion commands")
  print("  <leader>he        - Editing commands")
  print("\nThis is a full LazyVim environment!")
  print("Press 'qq' to quit (normal LazyVim quit)")
  print("====================================================\n")
end, 1000)
