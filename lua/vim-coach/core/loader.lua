-- vim-coach.nvim command loader
-- Handles loading and caching of command databases

local M = {}
local constants = require("vim-coach.constants")

-- Cache for loaded commands (nil until first load)
local command_cache = nil

-- Load all command databases from commands/ directory
local function load_all_commands()
  if command_cache then
    return command_cache
  end

  command_cache = {
    motions = require("vim-coach.commands.motions"),
    editing = require("vim-coach.commands.editing"),
    visual = require("vim-coach.commands.visual"),
    plugins = require("vim-coach.commands.plugins"),
  }

  return command_cache
end

-- Get merged list of all commands with category tags
function M.get_all_commands()
  local commands = load_all_commands()
  local all_commands = {}

  for category, cmd_list in pairs(commands) do
    for _, cmd in ipairs(cmd_list) do
      -- Add category to each command
      cmd.category = category
      table.insert(all_commands, cmd)
    end
  end

  return all_commands
end

-- Get commands filtered by category
function M.get_by_category(category)
  if category == "all" then
    return M.get_all_commands()
  end

  local commands = load_all_commands()
  local cmd_list = commands[category] or {}

  -- Add category tag to each command
  local tagged_commands = {}
  for _, cmd in ipairs(cmd_list) do
    cmd.category = category
    table.insert(tagged_commands, cmd)
  end

  return tagged_commands
end

-- Get list of available categories
function M.get_categories()
  return constants.CATEGORIES
end

-- Clear cache (useful for testing or reloading)
function M.clear_cache()
  command_cache = nil
end

return M
