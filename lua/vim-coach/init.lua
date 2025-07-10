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
  
  -- Format commands for snacks.picker with flattened structure
  local items = {}
  for i, cmd in ipairs(cmd_list) do
    if cmd then
      table.insert(items, {
        idx = i,
        name = cmd.name or "Unknown Command",
        keybind = cmd.keybind or "N/A",
        explanation = cmd.explanation or "No explanation",
        beginner_tip = cmd.beginner_tip,
        when_to_use = cmd.when_to_use,
        examples = cmd.examples,
        context_notes = cmd.context_notes,
        modes = cmd.modes or {},
        category = cmd.category or category,
        text = (cmd.name or "Unknown Command") .. " (" .. (cmd.keybind or "N/A") .. ")",
      })
    end
  end
  
  snacks.picker({
    title = "Vim Coach - " .. string.upper(category:sub(1,1)) .. category:sub(2) .. " Commands",
    items = items,
    format = function(item)
      local ret = {}
      
      -- Name with proper highlight
      ret[#ret + 1] = { string.format("%-25s", item.name), "SnacksPickerLabel" }
      
      -- Keybind
      ret[#ret + 1] = { string.format("%-12s", item.keybind), "SnacksPickerSpecial" }
      
      -- Truncated explanation
      local explanation = item.explanation or ""
      if #explanation > 50 then
        explanation = explanation:sub(1, 50) .. "..."
      end
      ret[#ret + 1] = { explanation, "SnacksPickerComment" }
      
      return ret
    end,
    preview = function(item)
      local lines = {}
      
      -- Header with command name
      table.insert(lines, "╭─ " .. item.name .. " ─╮")
      table.insert(lines, "")
      
      -- Basic info section
      table.insert(lines, "🔧 Keybind: " .. item.keybind)
      table.insert(lines, "📂 Category: " .. item.category)
      table.insert(lines, "🎯 Modes: " .. table.concat(item.modes, ", "))
      table.insert(lines, "")
      
      -- What it does section
      table.insert(lines, "📖 What it does:")
      
      -- Word wrap long explanations
      local explanation = item.explanation or "No explanation available"
      local words = {}
      for word in explanation:gmatch("%S+") do
        table.insert(words, word)
      end
      
      local current_line = ""
      for _, word in ipairs(words) do
        if string.len(current_line .. " " .. word) > 70 then
          table.insert(lines, current_line)
          current_line = word
        else
          current_line = current_line == "" and word or current_line .. " " .. word
        end
      end
      if current_line ~= "" then
        table.insert(lines, current_line)
      end
      table.insert(lines, "")
      
      -- Beginner tip section
      if item.beginner_tip then
        table.insert(lines, "💡 Beginner Tip:")
        
        -- Word wrap beginner tip
        local tip_words = {}
        for word in item.beginner_tip:gmatch("%S+") do
          table.insert(tip_words, word)
        end
        
        local tip_line = ""
        for _, word in ipairs(tip_words) do
          if string.len(tip_line .. " " .. word) > 70 then
            table.insert(lines, tip_line)
            tip_line = word
          else
            tip_line = tip_line == "" and word or tip_line .. " " .. word
          end
        end
        if tip_line ~= "" then
          table.insert(lines, tip_line)
        end
        table.insert(lines, "")
      end
      
      -- When to use section
      if item.when_to_use then
        table.insert(lines, "⏰ When to use:")
        
        -- Word wrap when_to_use
        local when_words = {}
        for word in item.when_to_use:gmatch("%S+") do
          table.insert(when_words, word)
        end
        
        local when_line = ""
        for _, word in ipairs(when_words) do
          if string.len(when_line .. " " .. word) > 70 then
            table.insert(lines, when_line)
            when_line = word
          else
            when_line = when_line == "" and word or when_line .. " " .. word
          end
        end
        if when_line ~= "" then
          table.insert(lines, when_line)
        end
        table.insert(lines, "")
      end
      
      -- Examples section
      if item.examples and #item.examples > 0 then
        table.insert(lines, "📝 Examples:")
        for _, example in ipairs(item.examples) do
          table.insert(lines, "  • " .. example)
        end
        table.insert(lines, "")
      end
      
      -- Context notes section
      if item.context_notes then
        table.insert(lines, "🌐 Context Notes:")
        for context, note in pairs(item.context_notes) do
          local formatted_note = context .. ": " .. note
          
          -- Word wrap context notes
          if string.len(formatted_note) > 70 then
            local context_words = {}
            for word in formatted_note:gmatch("%S+") do
              table.insert(context_words, word)
            end
            
            local context_line = ""
            for _, word in ipairs(context_words) do
              if string.len(context_line .. " " .. word) > 68 then -- Leave space for indentation
                table.insert(lines, "  " .. context_line)
                context_line = word
              else
                context_line = context_line == "" and word or context_line .. " " .. word
              end
            end
            if context_line ~= "" then
              table.insert(lines, "  " .. context_line)
            end
          else
            table.insert(lines, "  " .. formatted_note)
          end
        end
      end
      
      return lines
    end,
    confirm = function(picker, item)
      picker:close()
      if item.keybind and item.keybind ~= "N/A" and item.keybind ~= "" then
        vim.fn.setreg("+", item.keybind)
        vim.notify("Copied '" .. item.keybind .. "' to clipboard! 📋", vim.log.levels.INFO)
      end
    end,
    actions = {
      ["<C-y>"] = function(picker, item)
        if item.keybind and item.keybind ~= "N/A" and item.keybind ~= "" then
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