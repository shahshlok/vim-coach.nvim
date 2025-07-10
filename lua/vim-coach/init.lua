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
        text = cmd.name or "",
        keybind = cmd.keybind or "",
        explanation = cmd.explanation or "",
        category = cmd.category or "unknown",
        modes = cmd.modes or {},
        beginner_tip = cmd.beginner_tip,
        when_to_use = cmd.when_to_use,
        examples = cmd.examples,
        context_notes = cmd.context_notes,
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
      if not item then
        return "ERROR: nil item"
      end
      
      local text = item.text or ""
      local keybind = item.keybind or ""
      local explanation = item.explanation or ""
      
      -- Safely truncate explanation
      local truncated = explanation
      if #explanation > 80 then
        truncated = explanation:sub(1, 80) .. "..."
      end
      
      return string.format("%-20s %-15s %s", text, keybind, truncated)
    end,
    preview = function(item)
      -- Debug protection against nil items
      if not item then
        return { lines = {"ERROR: nil item in preview"}, ft = "text" }
      end
      
      local lines = {}
      
      table.insert(lines, "╭─ " .. (item.text or "Unknown Command") .. " ─╮")
      table.insert(lines, "")
      table.insert(lines, "🔧 Keybind: " .. (item.keybind or "N/A"))
      table.insert(lines, "📂 Category: " .. (item.category or "unknown"))
      table.insert(lines, "🎯 Modes: " .. table.concat(item.modes or {}, ", "))
      table.insert(lines, "")
      table.insert(lines, "📖 What it does:")
      
      -- Wrap long explanations
      local explanation = item.explanation or "No explanation available"
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
      
      if item.beginner_tip then
        table.insert(lines, "💡 Beginner Tip:")
        table.insert(lines, item.beginner_tip)
        table.insert(lines, "")
      end
      
      if item.when_to_use then
        table.insert(lines, "⏰ When to use:")
        table.insert(lines, item.when_to_use)
        table.insert(lines, "")
      end
      
      if item.examples then
        table.insert(lines, "📝 Examples:")
        for _, example in ipairs(item.examples) do
          table.insert(lines, "  • " .. example)
        end
        table.insert(lines, "")
      end
      
      if item.context_notes then
        table.insert(lines, "🌐 Context Notes:")
        for context, note in pairs(item.context_notes) do
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
      if item and item.keybind and item.keybind ~= "" then
        vim.fn.setreg("+", item.keybind)
        vim.notify("Copied '" .. item.keybind .. "' to clipboard! 📋", vim.log.levels.INFO)
      end
    end,
    actions = {
      ["<C-y>"] = function(item)
        if item and item.keybind and item.keybind ~= "" then
          vim.fn.setreg("+", item.keybind)
          vim.notify("Copied '" .. item.keybind .. "' to clipboard! 📋", vim.log.levels.INFO)
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