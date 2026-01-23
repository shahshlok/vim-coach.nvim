-- vim-coach.nvim configuration management
-- Handles plugin configuration with validation and defaults

local M = {}

-- Default configuration
local defaults = {
  window = {
    border = "rounded",
    title_pos = "center",
  },
  keymaps = {
    copy_keymap = "<C-y>",
    close = "<Esc>",
  },
  preview = {
    wrap = true,
    linebreak = true,
    breakindent = true,
  },
}

-- Current configuration (starts as copy of defaults)
local config = vim.deepcopy(defaults)

-- Validate configuration options
local function validate(opts)
  vim.validate({
    window = { opts.window, "table", true },
    keymaps = { opts.keymaps, "table", true },
    preview = { opts.preview, "table", true },
  })

  if opts.window then
    vim.validate({
      border = { opts.window.border, "string", true },
      title_pos = { opts.window.title_pos, "string", true },
    })
  end

  if opts.keymaps then
    vim.validate({
      copy_keymap = { opts.keymaps.copy_keymap, "string", true },
      close = { opts.keymaps.close, "string", true },
    })
  end

  return true
end

-- Setup configuration with user options
function M.setup(opts)
  opts = opts or {}
  validate(opts)
  config = vim.tbl_deep_extend("force", config, opts)
end

-- Get current configuration
function M.get()
  return config
end

-- Get default configuration
function M.get_defaults()
  return vim.deepcopy(defaults)
end

return M
