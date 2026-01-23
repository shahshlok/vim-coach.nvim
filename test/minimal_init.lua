-- Minimal test environment for vim-coach.nvim (no LazyVim)
-- Loads only snacks.nvim and the local plugin in an isolated setup

-- Set leader keys early
vim.g.mapleader = " "
vim.g.maplocalleader = "\\"

-- Isolated, minimal cache directory
local temp_dir = vim.fn.stdpath("cache") .. "/vim-coach-test-minimal"
local plugin_dir = temp_dir .. "/plugins"
vim.fn.mkdir(plugin_dir, "p")

-- Use isolated packpath
vim.opt.packpath = temp_dir

-- Bootstrap lazy.nvim if missing
local lazypath = plugin_dir .. "/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  print("Installing lazy.nvim (minimal test)...")
  vim.fn.system({
    "git", "clone", "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git", "--branch=stable", lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)

-- Local plugin path (repo root)
local plugin_path = vim.fn.fnamemodify(debug.getinfo(1).source:sub(2), ":p:h:h")

-- Minimal plugin set: snacks.nvim + local vim-coach
require("lazy").setup({
  {
    dir = plugin_path,
    name = "vim-coach.nvim",
    dependencies = {
      "folke/snacks.nvim",
    },
    config = function()
      require("vim-coach").setup()
    end,
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
  install = { missing = true },
  checker = { enabled = false },
  performance = {
    rtp = { disabled_plugins = { "gzip", "tarPlugin", "tohtml", "tutor", "zipPlugin" } },
  },
})

vim.defer_fn(function()
  print("\n=== vim-coach.nvim Test Environment (Minimal) ===")
  print("Plugin loaded from: " .. plugin_path)
  print("\nTry these commands:")
  print("  :VimCoach         - Open all commands")
  print("  <leader>?         - Open all commands (space + ?)")
  print("  <leader>hm        - Motion commands")
  print("  <leader>he        - Editing commands")
  print("\nThis is a minimal Neovim setup (no LazyVim).")
  print("====================================================\n")
end, 1000)

