-- vim-coach.nvim - A comprehensive Vim command reference for beginners
-- File: plugin/vim-coach.lua
--
-- This is the ENTRY POINT file. Neovim loads this automatically when it starts.
-- It handles plugin registration, version checking, and setup.
--
-- Key responsibilities:
--   1. Check if plugin is already loaded (prevent double-loading)
--   2. Verify Neovim version is supported (>= 0.7)
--   3. Check for required dependencies (snacks.nvim)
--   4. Register user commands (:VimCoach, :Coach)
--   5. Set up default keymaps (unless disabled)
--
-- LAZY LOADING NOTE: This file runs at Neovim startup, but the actual plugin
-- logic in lua/vim-coach/ doesn't load until the user runs a command.
-- This keeps Neovim startup fast.
--
-- Author: Shlok
-- License: MIT

-- Guard clause: Prevent loading the plugin twice
-- This is important if Neovim reloads plugins or if lazy.nvim loads it twice
if vim.g.loaded_vim_coach == 1 then
  return
end
vim.g.loaded_vim_coach = 1

-- Version check: Ensure Neovim >= 0.7
-- vim.fn.has('nvim-0.7') returns 1 if true, 0 if false
-- Earlier versions don't support all the Lua APIs we use
if vim.fn.has('nvim-0.7') == 0 then
  vim.api.nvim_err_writeln('vim-coach.nvim requires Neovim >= 0.7')
  return
end

-- Dependency check: Verify snacks.nvim is installed
-- pcall() catches errors - if require fails, has_snacks is false
local has_snacks = pcall(require, 'snacks')
if not has_snacks then
  vim.api.nvim_err_writeln('vim-coach.nvim requires snacks.nvim')
  return
end

-- Picker check: Verify snacks has picker component enabled
-- Even if snacks is installed, it might not have the picker module
local snacks = require('snacks')
if not snacks.picker then
  vim.api.nvim_err_writeln('vim-coach.nvim requires snacks.nvim with picker support enabled')
  return
end

-- Main command: :VimCoach
-- Usage:
--   :VimCoach           - Open with all commands
--   :VimCoach motions   - Open only motion commands
--   :VimCoach editing   - Open only editing commands
--   :VimCoach visual    - Open only visual mode commands
--   :VimCoach plugins   - Open only plugin commands
vim.api.nvim_create_user_command('VimCoach', function(args)
  -- args.args contains what the user typed after :VimCoach
  -- If empty, default to "all"
  local category = args.args and args.args ~= "" and args.args or "all"
  -- Lazy load and call the main plugin function
  require('vim-coach').coach_picker(category)
end, {
  nargs = "?",  -- Allow zero or one argument
  complete = function()  -- Tab completion options
    return { "all", "motions", "editing", "visual", "plugins" }
  end,
  desc = "Open Vim Coach command reference"
})

-- Alternative command name for convenience
-- Users can type :Coach instead of :VimCoach
vim.api.nvim_create_user_command('Coach', function(args)
  vim.cmd('VimCoach ' .. (args.args or ''))
end, {
  nargs = "?",
  complete = function()
    return { "all", "motions", "editing", "visual", "plugins" }
  end,
  desc = "Open Vim Coach command reference (alias)"
})

-- Set up default keymaps (keyboard shortcuts)
-- Users can disable these by setting: vim.g.vim_coach_no_default_keymaps = 1
if vim.g.vim_coach_no_default_keymaps ~= 1 then
  -- Main shortcut: Open vim-coach with all commands
  vim.keymap.set('n', '<leader>?', '<cmd>VimCoach<cr>', { 
    desc = 'Vim Coach - Comprehensive Help' 
  })
  
  -- Category-specific shortcuts for quick access
  vim.keymap.set('n', '<leader>hm', '<cmd>VimCoach motions<cr>', { 
    desc = 'Vim Motions Help' 
  })
  vim.keymap.set('n', '<leader>he', '<cmd>VimCoach editing<cr>', { 
    desc = 'Vim Editing Help' 
  })
  vim.keymap.set('n', '<leader>hv', '<cmd>VimCoach visual<cr>', { 
    desc = 'Vim Visual Mode Help' 
  })
  vim.keymap.set('n', '<leader>hp', '<cmd>VimCoach plugins<cr>', { 
    desc = 'Plugin Commands Help' 
  })
  vim.keymap.set('n', '<leader>hh', '<cmd>VimCoach all<cr>', { 
    desc = 'All Commands Help' 
  })
end