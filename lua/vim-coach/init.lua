-- vim-coach.nvim - A comprehensive Vim command reference for beginners
-- Main plugin module

local M = {}

-- Load backends
local backends = require("vim-coach.backends")

-- Load command databases
local commands = {
  motions = require("vim-coach.commands.motions"),
  editing = require("vim-coach.commands.editing"),
  visual = require("vim-coach.commands.visual"),
  plugins = require("vim-coach.commands.plugins"),
}

-- Plugin configuration
local config = {
  picker = "auto", -- "auto", "telescope", "snacks"
  window = {
    border = "rounded",
    title_pos = "center",
  },
  keymaps = {
    copy_keymap = "<C-y>",
    close = "<Esc>",
  },
}

-- Merge all commands into one searchable database
local function get_all_commands()
  local all_commands = {}
  for category, cmd_list in pairs(commands) do
    for _, cmd in ipairs(cmd_list) do
      cmd.category = category
      table.insert(all_commands, cmd)
    end
  end
  return all_commands
end

-- Get commands by category
local function get_commands_by_category(category)
  if category == "all" then
    return get_all_commands()
  end
  return commands[category] or {}
end

-- Main picker function
function M.coach_picker(category)
  category = category or "all"
  local cmd_list = get_commands_by_category(category)
  
  if #cmd_list == 0 then
    vim.notify("No commands found for category: " .. category, vim.log.levels.WARN)
    return
  end
  
  -- Use backend system to show picker
  backends.show_picker({
    commands = cmd_list,
    title = "Vim Coach - " .. string.upper(category:sub(1,1)) .. category:sub(2) .. " Commands",
  })
end

-- Setup function for plugin configuration
function M.setup(opts)
  opts = opts or {}
  
  -- Merge user config with defaults
  config = vim.tbl_deep_extend("force", config, opts)
  
  -- Set up picker backend
  local picker_name = config.picker or "auto"
  local selected_backend = backends.set_backend(picker_name)
  
  -- Notify user about selected backend
  if selected_backend then
    vim.notify("vim-coach.nvim: Using " .. selected_backend .. " picker", vim.log.levels.INFO)
  end
  
  -- Optional: Add user commands if not already added by plugin file
  if not vim.fn.exists(':VimCoach') then
    vim.api.nvim_create_user_command("VimCoach", function(args)
      local category = args.args and args.args ~= "" and args.args or "all"
      M.coach_picker(category)
    end, {
      nargs = "?",
      complete = function()
        return { "all", "motions", "editing", "visual", "plugins" }
      end,
    })
  end
end

-- Get plugin info
function M.info()
  return {
    name = "vim-coach.nvim",
    version = "1.0.0",
    description = "A comprehensive Vim command reference for beginners",
    total_commands = #get_all_commands(),
    categories = vim.tbl_keys(commands),
  }
end

-- Export functions for external use
M.get_commands = get_commands_by_category
M.get_all_commands = get_all_commands

return M