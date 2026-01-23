-- vim-coach.nvim - A comprehensive Vim command reference for beginners
-- File: lua/vim-coach/init.lua
--
-- This is the MAIN MODULE. It acts as the coordinator/orchestrator.
-- It doesn't do all the work itself - instead it delegates to specialized modules:
--
--   config.lua     - Handles configuration management
--   loader.lua     - Loads commands from database files
--   picker.lua     - Opens the UI and handles interactions
--   constants.lua  - Shared constants
--
-- LAZY LOADING: This file only loads when user runs :VimCoach command.
-- All the actual work is delegated to specialized modules that load on demand.

local M = {}

-- Import specialized modules
-- These modules handle specific tasks - we call them as needed
local config = require("vim-coach.config")
local loader = require("vim-coach.core.loader")
local picker = require("vim-coach.ui.picker")
local constants = require("vim-coach.constants")

-- Main entry point function
-- Delegates to picker module to open the UI
--
-- Args:
--   category (string, optional): Filter to specific category
--                               Options: "all", "motions", "editing", "visual", "plugins"
--                               Default: "all"
--
-- Example usage:
--   M.coach_picker()            -- Show all commands
--   M.coach_picker("motions")   -- Show only motion commands
function M.coach_picker(category)
  picker.open(category)
end

-- Setup function for plugin configuration
-- Called by users in their init.lua to customize the plugin
--
-- Args:
--   opts (table, optional): Configuration options
--
-- Example usage:
--   require("vim-coach").setup({
--     window = { border = "double" },
--     keymaps = { copy_keymap = "<C-c>" },
--   })
function M.setup(opts)
  opts = opts or {}

  -- Delegate to config module for handling options
  config.setup(opts)

  -- Optional: Re-register command if not already registered
  -- (This handles edge cases where plugin loads multiple times)
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

-- Get plugin metadata and information
-- Useful for debugging or displaying plugin info
--
-- Returns: table with plugin information
--   - name: Plugin name
--   - version: Plugin version
--   - description: Brief description
--   - total_commands: Number of commands in database
--   - categories: Available command categories
--   - picker: UI library being used
--
-- Example usage:
--   local info = require("vim-coach").info()
--   print(info.total_commands .. " commands available")
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

-- Public API: Functions for external use
-- These are exported from specialized modules for convenience

-- Get commands from a specific category
-- Delegates to loader module
M.get_commands = loader.get_by_category

-- Get all commands from all categories
-- Delegates to loader module
M.get_all_commands = loader.get_all_commands

return M
