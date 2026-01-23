-- vim-coach.nvim command loader
-- File: lua/vim-coach/core/loader.lua
--
-- This module handles loading commands from the database files.
-- It provides:
--   1. Lazy loading of command databases
--   2. Caching to avoid reloading files
--   3. Filtering commands by category
--   4. Merging commands from multiple sources
--
-- The command database is organized in files:
--   lua/vim-coach/commands/motions.lua  - Movement commands
--   lua/vim-coach/commands/editing.lua  - Text editing commands
--   lua/vim-coach/commands/visual.lua   - Visual mode commands
--   lua/vim-coach/commands/plugins.lua  - Plugin-specific commands

local M = {}
local constants = require("vim-coach.constants")

-- Command cache (module state)
-- Stores loaded commands to avoid reloading files repeatedly
-- nil = not yet loaded
-- table = loaded commands organized by category
local command_cache = nil

-- Load all command database files
-- Only loads once, then caches the result for performance
-- Subsequent calls return the cached result
--
-- Returns: table with commands organized by category
--   {
--     motions = {...},
--     editing = {...},
--     visual = {...},
--     plugins = {...},
--   }
local function load_all_commands()
  -- Return cached data if already loaded
  if command_cache then
    return command_cache
  end

  -- Load all command database files
  -- Each file returns a Lua table of commands for that category
  command_cache = {
    motions = require("vim-coach.commands.motions"),
    editing = require("vim-coach.commands.editing"),
    visual = require("vim-coach.commands.visual"),
    plugins = require("vim-coach.commands.plugins"),
  }

  return command_cache
end

-- Get merged list of all commands with category tags
-- Flattens all categories into one big list, tagging each with its category
--
-- Returns: array of commands (all categories merged)
--   [
--     {name = "...", keybind = "...", category = "motions"},
--     {name = "...", keybind = "...", category = "editing"},
--     ...
--   ]
function M.get_all_commands()
  local commands = load_all_commands()
  local all_commands = {}

  -- Iterate through each category
  for category, cmd_list in pairs(commands) do
    -- Iterate through each command in that category
    for _, cmd in ipairs(cmd_list) do
      -- Tag the command with its category (so we know where it came from)
      cmd.category = category
      -- Add to merged list
      table.insert(all_commands, cmd)
    end
  end

  return all_commands
end

-- Get commands filtered by a specific category
-- Returns all commands if category is "all"
-- Returns only commands from specified category otherwise
--
-- Args:
--   category (string): Category to filter by
--                      Options: "all", "motions", "editing", "visual", "plugins"
--
-- Returns: array of commands from that category
--
-- Example:
--   local motions = M.get_by_category("motions")  -- Only motion commands
--   local all = M.get_by_category("all")          -- All commands
function M.get_by_category(category)
  -- Special case: "all" means return all commands
  if category == "all" then
    return M.get_all_commands()
  end

  -- Load commands
  local commands = load_all_commands()
  -- Get commands from this category (empty table if category doesn't exist)
  local cmd_list = commands[category] or {}

  -- Tag each command with its category
  local tagged_commands = {}
  for _, cmd in ipairs(cmd_list) do
    cmd.category = category
    table.insert(tagged_commands, cmd)
  end

  return tagged_commands
end

-- Get list of available categories
-- Delegates to constants module
--
-- Returns: array of category names
function M.get_categories()
  return constants.CATEGORIES
end

-- Clear the command cache
-- Useful for:
--   - Testing (to force reload)
--   - Reloading command definitions at runtime
--   - Memory cleanup if running for a very long time
function M.clear_cache()
  command_cache = nil
end

return M
