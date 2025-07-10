-- vim-coach.nvim - A comprehensive Vim command reference for beginners
-- Main plugin module

local M = {}

-- Load command databases
local commands = {
  motions = require("vim-coach.commands.motions"),
  editing = require("vim-coach.commands.editing"),
  visual = require("vim-coach.commands.visual"),
  plugins = require("vim-coach.commands.plugins"),
}

-- Plugin configuration
local config = {
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

-- Main picker function using snacks.picker
function M.coach_picker(category)
  category = category or "all"
  local cmd_list = get_commands_by_category(category)
  
  if #cmd_list == 0 then
    vim.notify("No commands found for category: " .. category, vim.log.levels.WARN)
    return
  end
  
  local snacks = require("snacks")
  
  -- Format commands for snacks.picker
  local items = {}
  for i, cmd in ipairs(cmd_list) do
    if not cmd then
      print("WARNING: Command " .. i .. " is nil")
    else
      table.insert(items, {
        text = (cmd.name or "") .. " (" .. (cmd.keybind or "") .. ")",
        cmd = cmd, -- Store original command data
      })
    end
  end
  
  print("DEBUG: Created " .. #items .. " items for picker")
  
  snacks.picker.pick({
    source = "vim-coach",
    items = items,
    title = "Vim Coach - " .. string.upper(category:sub(1,1)) .. category:sub(2) .. " Commands",
    format = function(item)
      -- Debug protection against nil items
      if not item or not item.cmd then
        return "ERROR: malformed item"
      end
      
      local cmd = item.cmd
      local name = cmd.name or ""
      local keybind = cmd.keybind or ""
      local explanation = cmd.explanation or ""
      
      -- Safely truncate explanation
      local truncated = explanation
      if #explanation > 60 then
        truncated = explanation:sub(1, 60) .. "..."
      end
      
      return string.format("%-20s %-15s %s", name, keybind, truncated)
    end,
    preview = function(item)
      -- Debug protection against nil items
      if not item or not item.cmd then
        return { lines = {"ERROR: malformed item in preview"}, ft = "text" }
      end
      
      local cmd = item.cmd
      local lines = {}
      
      table.insert(lines, "╭─ " .. (cmd.name or "Unknown Command") .. " ─╮")
      table.insert(lines, "")
      table.insert(lines, "🔧 Keybind: " .. (cmd.keybind or "N/A"))
      table.insert(lines, "📂 Category: " .. (cmd.category or "unknown"))
      table.insert(lines, "🎯 Modes: " .. table.concat(cmd.modes or {}, ", "))
      table.insert(lines, "")
      table.insert(lines, "📖 What it does:")
      
      -- Wrap long explanations
      local explanation = cmd.explanation or "No explanation available"
      local wrapped_explanation = {}
      for line in explanation:gmatch("[^\r\n]+") do
        if string.len(line) > 70 then
          -- Simple word wrapping
          local words = {}
          for word in line:gmatch("%S+") do
            table.insert(words, word)
          end
          
          local current_line = ""
          for _, word in ipairs(words) do
            if string.len(current_line .. " " .. word) > 70 then
              table.insert(wrapped_explanation, current_line)
              current_line = word
            else
              current_line = current_line == "" and word or current_line .. " " .. word
            end
          end
          if current_line ~= "" then
            table.insert(wrapped_explanation, current_line)
          end
        else
          table.insert(wrapped_explanation, line)
        end
      end
      
      for _, line in ipairs(wrapped_explanation) do
        table.insert(lines, line)
      end
      table.insert(lines, "")
      
      if cmd.beginner_tip then
        table.insert(lines, "💡 Beginner Tip:")
        table.insert(lines, cmd.beginner_tip)
        table.insert(lines, "")
      end
      
      if cmd.when_to_use then
        table.insert(lines, "⏰ When to use:")
        table.insert(lines, cmd.when_to_use)
        table.insert(lines, "")
      end
      
      if cmd.examples then
        table.insert(lines, "📝 Examples:")
        for _, example in ipairs(cmd.examples) do
          table.insert(lines, "  • " .. example)
        end
        table.insert(lines, "")
      end
      
      if cmd.context_notes then
        table.insert(lines, "🌐 Context Notes:")
        for context, note in pairs(cmd.context_notes) do
          table.insert(lines, "  " .. context .. ": " .. note)
        end
      end
      
      return {
        lines = lines,
        ft = "markdown",
      }
    end,
    on_select = function(item)
      -- Copy keybind to clipboard if available
      if item and item.cmd and item.cmd.keybind and item.cmd.keybind ~= "" then
        vim.fn.setreg("+", item.cmd.keybind)
        vim.notify("Copied '" .. item.cmd.keybind .. "' to clipboard! 📋", vim.log.levels.INFO)
      end
    end,
    actions = {
      ["<C-y>"] = function(item)
        if item and item.cmd and item.cmd.keybind and item.cmd.keybind ~= "" then
          vim.fn.setreg("+", item.cmd.keybind)
          vim.notify("Copied '" .. item.cmd.keybind .. "' to clipboard! 📋", vim.log.levels.INFO)
        end
      end,
    },
  })
end

-- Setup function for plugin configuration
function M.setup(opts)
  opts = opts or {}
  
  -- Merge user config with defaults
  config = vim.tbl_deep_extend("force", config, opts)
  
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
    version = "2.0.0", -- Bump version for snacks migration
    description = "A comprehensive Vim command reference for beginners",
    total_commands = #get_all_commands(),
    categories = vim.tbl_keys(commands),
    picker = "snacks.nvim",
  }
end

-- Export functions for external use
M.get_commands = get_commands_by_category
M.get_all_commands = get_all_commands

return M