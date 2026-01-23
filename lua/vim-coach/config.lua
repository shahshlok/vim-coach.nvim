-- vim-coach.nvim configuration management
-- File: lua/vim-coach/config.lua
--
-- This module handles all plugin configuration.
-- It provides:
--   1. Default configuration values
--   2. Configuration validation
--   3. Merging user options with defaults
--   4. Retrieval of current configuration

local M = {}

-- Default configuration
-- These are the built-in settings that users can override
local defaults = {
  -- Window appearance settings
  window = {
    border = "rounded",      -- Border style: none, single, double, rounded, etc.
    title_pos = "center",    -- Title position: left, center, right
  },
  
  -- Keyboard shortcut settings
  keymaps = {
    copy_keymap = "<C-y>",   -- Key to copy keybind to clipboard
    close = "<Esc>",         -- Key to close the picker
  },
  
  -- Preview window settings
  preview = {
    wrap = true,             -- Enable word wrapping
    linebreak = true,        -- Break long lines intelligently
    breakindent = true,      -- Maintain indentation on wrapped lines
  },
}

-- Current configuration (module state)
-- Starts as a deep copy of defaults
-- Gets merged with user options when setup() is called
local config = vim.deepcopy(defaults)

-- Validate user-provided configuration
-- Ensures user options are of the correct type
-- This prevents errors from invalid configuration
--
-- Returns: true if valid, raises error if invalid
local function validate(opts)
  -- Validate top-level options
  vim.validate({
    window = { opts.window, "table", true },     -- true = optional
    keymaps = { opts.keymaps, "table", true },
    preview = { opts.preview, "table", true },
  })

  -- Validate window options (if provided)
  if opts.window then
    vim.validate({
      border = { opts.window.border, "string", true },
      title_pos = { opts.window.title_pos, "string", true },
    })
  end

  -- Validate keymap options (if provided)
  if opts.keymaps then
    vim.validate({
      copy_keymap = { opts.keymaps.copy_keymap, "string", true },
      close = { opts.keymaps.close, "string", true },
    })
  end

  return true
end

-- Setup configuration with user options
-- Merges user options with defaults, with user options taking precedence
--
-- Args:
--   opts (table, optional): User configuration options
--
-- Example:
--   M.setup({
--     window = { border = "double" },
--     keymaps = { copy_keymap = "<C-c>" },
--   })
function M.setup(opts)
  opts = opts or {}
  
  -- Validate options before applying
  validate(opts)
  
  -- Deep merge: User options override defaults, but don't remove missing keys
  -- "force" means user values override defaults completely
  config = vim.tbl_deep_extend("force", config, opts)
end

-- Get current configuration
-- Returns the merged configuration (defaults + user options)
--
-- Returns: table with current configuration
--
-- Example:
--   local cfg = M.get()
--   print(cfg.window.border)
function M.get()
  return config
end

-- Get default configuration
-- Returns a fresh copy of default configuration (without user modifications)
-- Useful for resetting or comparing with current configuration
--
-- Returns: table with default configuration
function M.get_defaults()
  return vim.deepcopy(defaults)
end

return M
