-- vim-coach.nvim picker orchestrator
-- File: lua/vim-coach/ui/picker.lua
--
-- This module orchestrates the picker UI.
-- It:
--   1. Loads commands from the loader
--   2. Formats them for display
--   3. Opens the snacks.picker interface
--   4. Handles user interactions (keypresses, selections)
--   5. Performs actions (copying to clipboard, etc.)

local M = {}

-- Import dependencies for building the UI
local loader = require("vim-coach.core.loader")
local preview = require("vim-coach.ui.preview")
local formatter = require("vim-coach.ui.formatter")
local config = require("vim-coach.config")

-- Copy a keybind to the clipboard
-- Also shows a notification to confirm the action
--
-- Args:
--   keybind (string): The keys to copy (e.g., "dw", "j", "<C-y>")
--   name (string): Command name (for display in notification)
--
-- Returns: nothing (side effect: copies to clipboard)
local function copy_to_clipboard(keybind, name)
  -- Validate the keybind
  if keybind and keybind ~= "N/A" and keybind ~= "" then
    -- vim.fn.setreg("+", text) copies to system clipboard
    -- "+" register is the system clipboard
    vim.fn.setreg("+", keybind)
    vim.notify("Copied '" .. keybind .. "' to clipboard!", vim.log.levels.INFO)
  else
    -- No valid keybind to copy
    vim.notify("No valid keybind to copy", vim.log.levels.WARN)
  end
end

-- Build items for the picker from a list of commands
-- Transforms raw command data into the format snacks.picker expects
--
-- Args:
--   commands (table): Array of command tables
--   category (string): Category being displayed
--
-- Returns: array of formatted items for picker
--   Each item includes:
--     - All command fields (name, keybind, etc.)
--     - text: Searchable text
--     - preview: Formatted preview content
local function build_items(commands, category)
  local items = {}

  -- Build an item for each command
  for i, cmd in ipairs(commands) do
    if cmd then
      table.insert(items, {
        -- Metadata
        idx = i,
        category = cmd.category or category,
        
        -- Command details (with fallbacks for missing data)
        name = cmd.name or "Unknown Command",
        keybind = cmd.keybind or "N/A",
        explanation = cmd.explanation or "No explanation",
        beginner_tip = cmd.beginner_tip,
        when_to_use = cmd.when_to_use,
        examples = cmd.examples,
        context_notes = cmd.context_notes,
        modes = cmd.modes or {},
        
        -- Display text (used for searching)
        -- Shows: "Command Name (keys)"
        text = (cmd.name or "Unknown Command") .. " (" .. (cmd.keybind or "N/A") .. ")",
        
        -- Preview panel content
        -- This is shown in the preview window when user selects an item
        preview = {
          text = preview.build_preview(cmd),  -- Formatted preview content
          ft = "text",                        -- File type (for syntax highlighting)
        },
      })
    end
  end

  return items
end

-- Handle when user presses Enter on a selected item
-- Closes the picker and copies the keybind
--
-- Args:
--   picker (snacks.picker): The picker object
--   item (table): The selected command item
local function on_confirm(picker, item)
  picker:close()
  copy_to_clipboard(item.keybind, item.name)
end

-- Open the picker UI with commands
-- This is the main function called when user runs :VimCoach
--
-- Args:
--   category (string, optional): Category to show
--                                 Default: "all"
--
-- Returns: nothing (side effect: opens picker UI)
--
-- Example:
--   M.open("motions")  -- Show only motion commands
--   M.open()          -- Show all commands
function M.open(category)
  category = category or "all"
  
  -- Load commands for this category
  local cmd_list = loader.get_by_category(category)

  -- Check if we found any commands
  if #cmd_list == 0 then
    vim.notify("No commands found for category: " .. category, vim.log.levels.WARN)
    return
  end

  -- Get plugin configuration
  local snacks = require("snacks")
  local cfg = config.get()
  
  -- Format commands for display
  local items = build_items(cmd_list, category)

  -- Open snacks.picker with configured options
  snacks.picker({
    -- UI configuration
    title = formatter.build_title(category),
    items = items,
    preview = "preview",
    
    -- Preview window settings
    win = {
      preview = {
        wo = cfg.preview,  -- Window options from config
      }
    },
    
    -- How to display each item in the list
    format = formatter.format_picker_item,
    
    -- What happens when user presses Enter
    confirm = on_confirm,
    
    -- Custom keyboard shortcuts
    actions = {
      -- Copy to clipboard (configurable key, default: Ctrl+Y)
      [cfg.keymaps.copy_keymap] = function(picker, item)
        copy_to_clipboard(item.keybind, item.name)
      end,
    },
  })
end

return M
