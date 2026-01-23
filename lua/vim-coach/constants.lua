-- vim-coach.nvim constants
-- File: lua/vim-coach/constants.lua
--
-- This module defines constants (fixed values) used throughout the plugin.
-- Putting constants in one place makes it easy to:
--   1. Update values without searching the entire codebase
--   2. Keep configuration consistent
--   3. Reuse values in multiple modules

local M = {}

-- Available command categories
-- These are the ways users can filter commands
-- Usage: :VimCoach motions (shows only motion commands)
M.CATEGORIES = { "all", "motions", "editing", "visual", "plugins" }

-- Icons used in the preview display
-- These appear in the preview panel to visually distinguish different sections
M.ICONS = {
  keybind = "🔧",        -- Shows the keyboard shortcut
  category = "📂",        -- Shows the command category
  modes = "🎯",          -- Shows which modes the command works in
  explanation = "📖",     -- Marks the explanation section
  tip = "💡",            -- Highlights beginner tips
  when = "⏰",            -- Shows when to use this command
  examples = "📝",        -- Marks usage examples
  context = "🌐",        -- Shows context-specific notes
}

-- Plugin metadata
-- Version follows semantic versioning: MAJOR.MINOR.PATCH
M.VERSION = "2.0.1"
M.PLUGIN_NAME = "vim-coach.nvim"

return M
