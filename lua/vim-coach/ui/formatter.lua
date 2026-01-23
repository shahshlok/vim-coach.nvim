-- vim-coach.nvim item formatter
-- File: lua/vim-coach/ui/formatter.lua
--
-- This module formats commands for display in the picker.
-- It controls:
--   1. How each line appears in the picker list
--   2. Column widths and alignment
--   3. The title of the picker window
--   4. Text truncation and formatting

local M = {}

-- Format a single command item for display in the picker list
-- Creates a nicely formatted line with columns
--
-- Returns: array of {text, highlight_group} pairs
--   Each pair is a segment of the line with its styling
--
-- The formatted line looks like:
--   "Move Right              j            Moves cursor one character to the right..."
--    <---- 25 chars ----> <-- 12 chars --> <---------- ~50 chars ---------->
--
-- Args:
--   item (table): Command item with name, keybind, explanation
function M.format_picker_item(item)
  local ret = {}

  -- Column 1: Command name (left-aligned in 25 character field)
  -- string.format("%-25s", text) pads text to 25 chars with spaces on the right
  ret[#ret + 1] = {
    string.format("%-25s", item.name),
    "SnacksPickerLabel"  -- Highlighting: appears as label color
  }

  -- Column 2: Keybind (left-aligned in 12 character field)
  -- The actual keys to press (e.g., "dw", "j", "<C-y>")
  ret[#ret + 1] = {
    string.format("%-12s", item.keybind),
    "SnacksPickerSpecial"  -- Highlighting: appears as special/important color
  }

  -- Column 3: Explanation (truncated to 50 chars)
  -- This is the brief description of what the command does
  local explanation = item.explanation or ""
  
  -- Truncate if too long
  if #explanation > 50 then
    explanation = explanation:sub(1, 50) .. "..."  -- sub() extracts substring
  end
  
  ret[#ret + 1] = { explanation, "SnacksPickerComment" }  -- Grayed out

  return ret
end

-- Build the title for the picker window
-- Shows which category is being displayed
--
-- Args:
--   category (string): Category name (e.g., "motions", "editing")
--
-- Returns: formatted title string
--
-- Example:
--   M.build_title("motions") returns "Vim Coach - Motions Commands"
--   M.build_title("all")     returns "Vim Coach - All Commands"
function M.build_title(category)
  -- Capitalize first letter: "motions" -> "Motions"
  -- string.upper(category:sub(1, 1)) gets first char and makes uppercase
  -- category:sub(2) gets rest of string starting from char 2
  return "Vim Coach - "
    .. string.upper(category:sub(1, 1))
    .. category:sub(2)
    .. " Commands"
end

return M
