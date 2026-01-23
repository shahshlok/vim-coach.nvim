-- vim-coach.nvim preview builder
-- File: lua/vim-coach/ui/preview.lua
--
-- This module generates the detailed preview content shown when
-- a user selects a command in the picker.
--
-- The preview displays all relevant information about a command:
--   - Name and keybind
--   - Category and modes where it works
--   - Detailed explanation
--   - Beginner tips (if available)
--   - Usage examples (if available)
--   - Context-specific notes (if available)

local M = {}
local constants = require("vim-coach.constants")

-- Build formatted preview content for a command
-- Displays comprehensive information about the selected command
--
-- Args:
--   cmd (table): Command object with all properties
--
-- Returns: string of formatted preview text
--
-- The preview text includes icons and sections:
--   * Header with command name
--   * Basic info (keybind, category, modes)
--   * Detailed explanation
--   * Beginner tips (if available)
--   * When to use (if available)
--   * Examples (if available)
--   * Context notes (if available)
function M.build_preview(cmd)
  -- Start with empty lines table
  local lines = {}
  
  -- Get icons from constants for visual section marking
  local icons = constants.ICONS

  -- Header: Command name in a box
  table.insert(lines, "╭─ " .. (cmd.name or "Unknown Command") .. " ─╮")
  table.insert(lines, "")

  -- Section 1: Basic information
  table.insert(lines, icons.keybind .. " Keybind: " .. (cmd.keybind or "N/A"))
  table.insert(lines, icons.category .. " Category: " .. (cmd.category or "unknown"))
  
  -- Modes: which modes this command works in (normal, visual, insert, etc.)
  -- table.concat joins an array with a delimiter
  table.insert(lines, icons.modes .. " Modes: " .. table.concat(cmd.modes or {}, ", "))
  table.insert(lines, "")

  -- Section 2: What this command does (main explanation)
  table.insert(lines, icons.explanation .. " What it does:")
  table.insert(lines, cmd.explanation or "No explanation available")
  table.insert(lines, "")

  -- Section 3: Beginner tip (optional - only if present in command data)
  if cmd.beginner_tip then
    table.insert(lines, icons.tip .. " Beginner Tip:")
    table.insert(lines, cmd.beginner_tip)
    table.insert(lines, "")
  end

  -- Section 4: When to use (optional)
  -- Helps users understand practical use cases
  if cmd.when_to_use then
    table.insert(lines, icons.when .. " When to use:")
    table.insert(lines, cmd.when_to_use)
    table.insert(lines, "")
  end

  -- Section 5: Usage examples (optional)
  -- Shows practical examples of how to use this command
  if cmd.examples and #cmd.examples > 0 then
    table.insert(lines, icons.examples .. " Examples:")
    -- Loop through each example and add with bullet point
    for _, example in ipairs(cmd.examples) do
      table.insert(lines, "  • " .. example)
    end
    table.insert(lines, "")
  end

  -- Section 6: Context-specific notes (optional)
  -- Shows how this command behaves differently in different situations
  if cmd.context_notes then
    table.insert(lines, icons.context .. " Context Notes:")
    -- Loop through context notes (these are key-value pairs)
    for context, note in pairs(cmd.context_notes) do
      table.insert(lines, "  " .. context .. ": " .. note)
    end
  end

  -- Join all lines with newlines and return
  -- table.concat(array, "\n") joins elements with newline between them
  return table.concat(lines, "\n")
end

return M
