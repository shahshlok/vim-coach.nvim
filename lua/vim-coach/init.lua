-- vim-coach.nvim - A comprehensive Vim command reference for beginners
-- Main plugin module (coordinator)

local M = {}
local config = require("vim-coach.config")
local loader = require("vim-coach.core.loader")
local picker = require("vim-coach.ui.picker")
local constants = require("vim-coach.constants")

-- Main picker function - opens the command picker UI
function M.coach_picker(category)
  picker.open(category)
end

-- Setup function for plugin configuration
function M.setup(opts)
  opts = opts or {}

  -- Configure the plugin with user options
  config.setup(opts)

  -- Optional: Add user commands if not already added by plugin file
  if vim.fn.exists(':VimCoach') == 0 then
    vim.api.nvim_create_user_command("VimCoach", function(args)
      local category = args.args and args.args ~= "" and args.args or "all"
      M.coach_picker(category)
    end, {
      nargs = "?",
      complete = function()
        return loader.get_categories()
      end,
    })
  end
end

-- Get plugin info and metadata
function M.info()
  return {
    name = constants.PLUGIN_NAME,
    version = constants.VERSION,
    description = "A comprehensive Vim command reference for beginners",
    total_commands = #loader.get_all_commands(),
    categories = loader.get_categories(),
    picker = "snacks.nvim",
  }
end

-- Export functions for external use
M.get_commands = loader.get_by_category
M.get_all_commands = loader.get_all_commands

return M
