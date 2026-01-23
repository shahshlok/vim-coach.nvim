-- vim-coach.nvim preview builder
-- Generates preview content for commands

local M = {}
local constants = require("vim-coach.constants")

-- Build formatted preview content for a command
function M.build_preview(cmd)
  local lines = {}
  local icons = constants.ICONS

  -- Header with command name
  table.insert(lines, "╭─ " .. (cmd.name or "Unknown Command") .. " ─╮")
  table.insert(lines, "")

  -- Basic command information
  table.insert(lines, icons.keybind .. " Keybind: " .. (cmd.keybind or "N/A"))
  table.insert(lines, icons.category .. " Category: " .. (cmd.category or "unknown"))
  table.insert(lines, icons.modes .. " Modes: " .. table.concat(cmd.modes or {}, ", "))
  table.insert(lines, "")

  -- Detailed explanation
  table.insert(lines, icons.explanation .. " What it does:")
  table.insert(lines, cmd.explanation or "No explanation available")
  table.insert(lines, "")

  -- Beginner tip (optional)
  if cmd.beginner_tip then
    table.insert(lines, icons.tip .. " Beginner Tip:")
    table.insert(lines, cmd.beginner_tip)
    table.insert(lines, "")
  end

  -- When to use (optional)
  if cmd.when_to_use then
    table.insert(lines, icons.when .. " When to use:")
    table.insert(lines, cmd.when_to_use)
    table.insert(lines, "")
  end

  -- Usage examples (optional)
  if cmd.examples and #cmd.examples > 0 then
    table.insert(lines, icons.examples .. " Examples:")
    for _, example in ipairs(cmd.examples) do
      table.insert(lines, "  • " .. example)
    end
    table.insert(lines, "")
  end

  -- Context-specific notes (optional)
  if cmd.context_notes then
    table.insert(lines, icons.context .. " Context Notes:")
    for context, note in pairs(cmd.context_notes) do
      table.insert(lines, "  " .. context .. ": " .. note)
    end
  end

  return table.concat(lines, "\n")
end

return M
