-- Minimal init.lua for testing vim-coach.nvim
-- This creates an isolated environment that won't affect your main Neovim config

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

-- Set up lazy.nvim with minimal plugins
require("lazy").setup({
  -- Load snacks.nvim dependency
  {
    "folke/snacks.nvim",
    priority = 1000,
    config = function()
      require("snacks").setup({
        -- Minimal snacks config for testing
        picker = { enabled = true },
      })
    end,
  },

  -- Load vim-coach.nvim from local directory
  {
    dir = plugin_path,
    name = "vim-coach.nvim",
    config = function()
      require("vim-coach").setup()
    end,
  },
}, {
  root = plugin_dir,
  lockfile = temp_dir .. "/lazy-lock.json",
})

-- Set up some basic options for testing
vim.opt.termguicolors = true
vim.opt.number = true
vim.opt.relativenumber = true

-- Set leader key (if not already set)
vim.g.mapleader = " "
vim.g.maplocalleader = " "

-- Print helpful message
vim.defer_fn(function()
  print("\n=== vim-coach.nvim Test Environment ===")
  print("Plugin loaded from: " .. plugin_path)
  print("\nTry these commands:")
  print("  :VimCoach         - Open all commands")
  print("  <leader>?         - Open all commands")
  print("  <leader>hm        - Motion commands")
  print("  <leader>he        - Editing commands")
  print("\nPress 'q' to quit")
  print("=====================================\n")
end, 100)

-- Keymap to quickly quit
vim.keymap.set('n', 'q', '<cmd>qa!<cr>', { desc = 'Quit test environment' })
