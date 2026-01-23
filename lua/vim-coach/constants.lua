-- vim-coach.nvim constants
-- Shared constants across the plugin

local M = {}

-- Available command categories
M.CATEGORIES = { "all", "motions", "editing", "visual", "plugins" }

-- Icons used in UI
M.ICONS = {
  keybind = "🔧",
  category = "📂",
  modes = "🎯",
  explanation = "📖",
  tip = "💡",
  when = "⏰",
  examples = "📝",
  context = "🌐",
}

-- Plugin metadata
M.VERSION = "2.0.0"
M.PLUGIN_NAME = "vim-coach.nvim"

return M
