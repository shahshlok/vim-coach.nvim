-- vim-coach.nvim - A comprehensive Vim command reference for beginners
-- Author: Shlok
-- License: MIT

-- Prevent loading twice
if vim.g.loaded_vim_coach == 1 then
  return
end
vim.g.loaded_vim_coach = 1

-- Check if Neovim version is supported
if vim.fn.has('nvim-0.7') == 0 then
  vim.api.nvim_err_writeln('vim-coach.nvim requires Neovim >= 0.7')
  return
end

-- Check for snacks.nvim dependency
local has_snacks = pcall(require, 'snacks')
if not has_snacks then
  vim.api.nvim_err_writeln('vim-coach.nvim requires snacks.nvim')
  return
end

-- Check if snacks.picker is available
local snacks = require('snacks')
if not snacks.picker then
  vim.api.nvim_err_writeln('vim-coach.nvim requires snacks.nvim with picker support enabled')
  return
end

-- Create user commands
vim.api.nvim_create_user_command('VimCoach', function(args)
  local category = args.args and args.args ~= "" and args.args or "all"
  require('vim-coach').coach_picker(category)
end, {
  nargs = "?",
  complete = function()
    return { "all", "motions", "editing", "visual", "plugins" }
  end,
  desc = "Open Vim Coach command reference"
})

-- Alternative command names for convenience
vim.api.nvim_create_user_command('Coach', function(args)
  vim.cmd('VimCoach ' .. (args.args or ''))
end, {
  nargs = "?",
  complete = function()
    return { "all", "motions", "editing", "visual", "plugins" }
  end,
  desc = "Open Vim Coach command reference (alias)"
})

-- Set up default keymaps if user hasn't disabled them
if vim.g.vim_coach_no_default_keymaps ~= 1 then
  vim.keymap.set('n', '<leader>?', '<cmd>VimCoach<cr>', { desc = 'Vim Coach - Comprehensive Help' })
  vim.keymap.set('n', '<leader>hm', '<cmd>VimCoach motions<cr>', { desc = 'Vim Motions Help' })
  vim.keymap.set('n', '<leader>he', '<cmd>VimCoach editing<cr>', { desc = 'Vim Editing Help' })
  vim.keymap.set('n', '<leader>hv', '<cmd>VimCoach visual<cr>', { desc = 'Vim Visual Mode Help' })
  vim.keymap.set('n', '<leader>hp', '<cmd>VimCoach plugins<cr>', { desc = 'Plugin Commands Help' })
  vim.keymap.set('n', '<leader>hh', '<cmd>VimCoach all<cr>', { desc = 'All Commands Help' })
end