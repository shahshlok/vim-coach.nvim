-- vim-coach.nvim picker orchestrator
-- Manages the snacks.picker UI and user interactions

local M = {}
local loader = require("vim-coach.core.loader")
local preview = require("vim-coach.ui.preview")
local formatter = require("vim-coach.ui.formatter")
local config = require("vim-coach.config")

-- Copy keybind to clipboard with notification
local function copy_to_clipboard(keybind, name)
  if keybind and keybind ~= "N/A" and keybind ~= "" then
    vim.fn.setreg("+", keybind)
    vim.notify("Copied '" .. keybind .. "' to clipboard! 📋", vim.log.levels.INFO)
  else
    vim.notify("No valid keybind to copy", vim.log.levels.WARN)
  end
end

-- Build picker items from command list
local function build_items(commands, category)
  local items = {}

  for i, cmd in ipairs(commands) do
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
        preview = {
          text = preview.build_preview(cmd),
          ft = "text",
        },
      })
    end
  end

  return items
end

-- Handle item confirmation (Enter key)
local function on_confirm(picker, item)
  picker:close()
  copy_to_clipboard(item.keybind, item.name)
end

-- Open the picker with commands for a specific category
function M.open(category)
  category = category or "all"
  local cmd_list = loader.get_by_category(category)

  if #cmd_list == 0 then
    vim.notify("No commands found for category: " .. category, vim.log.levels.WARN)
    return
  end

  local snacks = require("snacks")
  local cfg = config.get()
  local items = build_items(cmd_list, category)

  snacks.picker({
    title = formatter.build_title(category),
    items = items,
    preview = "preview",
    win = {
      preview = {
        wo = cfg.preview,
      }
    },
    format = formatter.format_picker_item,
    confirm = on_confirm,
    actions = {
      [cfg.keymaps.copy_keymap] = function(picker, item)
        copy_to_clipboard(item.keybind, item.name)
      end,
    },
  })
end

return M
