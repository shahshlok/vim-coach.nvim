-- Snacks.picker backend for vim-coach
local M = {}

-- Check if snacks is available
function M.is_available()
  local ok, snacks = pcall(require, "snacks")
  return ok and snacks.picker ~= nil
end

-- Get backend name
function M.get_name()
  return "snacks"
end

-- Show picker using snacks.picker
function M.show_picker(opts)
  local snacks = require("snacks")
  local commands = opts.commands or {}
  local title = opts.title or "Vim Coach"
  
  if #commands == 0 then
    vim.notify("No commands found", vim.log.levels.WARN)
    return
  end
  
  -- Format commands for snacks.picker
  local items = {}
  for _, cmd in ipairs(commands) do
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
  
  snacks.picker.pick({
    source = {
      name = title,
      items = items,
    },
    format = function(item)
      return string.format("%-20s %-15s %s", 
        item.text or "", 
        item.keybind or "", 
        (item.explanation or ""):sub(1, 80) .. (string.len(item.explanation or "") > 80 and "..." or ""))
    end,
    preview = function(item)
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
      if item.keybind and item.keybind ~= "" then
        vim.fn.setreg("+", item.keybind)
        vim.notify("Copied '" .. item.keybind .. "' to clipboard! 📋", vim.log.levels.INFO)
      end
    end,
    actions = {
      ["<C-y>"] = function(item)
        if item.keybind and item.keybind ~= "" then
          vim.fn.setreg("+", item.keybind)
          vim.notify("Copied '" .. item.keybind .. "' to clipboard! 📋", vim.log.levels.INFO)
        end
      end,
    },
  })
end

return M