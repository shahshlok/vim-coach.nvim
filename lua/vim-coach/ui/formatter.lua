-- vim-coach.nvim item formatter
-- Formats items for display in the picker

local M = {}

-- Format a command item for picker display
-- Returns table of {text, highlight_group} pairs
function M.format_picker_item(item)
  local ret = {}

  -- Command name (left-aligned, 25 chars)
  ret[#ret + 1] = {
    string.format("%-25s", item.name),
    "SnacksPickerLabel"
  }

  -- Keybind (left-aligned, 12 chars)
  ret[#ret + 1] = {
    string.format("%-12s", item.keybind),
    "SnacksPickerSpecial"
  }

  -- Explanation (truncated to 50 chars if needed)
  local explanation = item.explanation or ""
  if #explanation > 50 then
    explanation = explanation:sub(1, 50) .. "..."
  end
  ret[#ret + 1] = { explanation, "SnacksPickerComment" }

  return ret
end

-- Build title for picker based on category
function M.build_title(category)
  -- Capitalize first letter of category
  return "Vim Coach - "
    .. string.upper(category:sub(1, 1))
    .. category:sub(2)
    .. " Commands"
end

return M
