-- vim-coach.nvim - A comprehensive Vim command reference for beginners
-- Main plugin module

local M = {}

local telescope = require("telescope")
local pickers = require("telescope.pickers")
local finders = require("telescope.finders")
local conf = require("telescope.config").values
local actions = require("telescope.actions")
local action_state = require("telescope.actions.state")
local previewers = require("telescope.previewers")

-- Load command databases
local commands = {
  motions = require("vim-coach.commands.motions"),
  editing = require("vim-coach.commands.editing"),
  visual = require("vim-coach.commands.visual"),
  plugins = require("vim-coach.commands.plugins"),
}

-- Plugin configuration
local config = {
  window = {
    border = "rounded",
    title_pos = "center",
  },
  keymaps = {
    copy_keymap = "<C-y>",
    close = "<Esc>",
  },
}

-- Merge all commands into one searchable database
local function get_all_commands()
  local all_commands = {}
  for category, cmd_list in pairs(commands) do
    for _, cmd in ipairs(cmd_list) do
      cmd.category = category
      table.insert(all_commands, cmd)
    end
  end
  return all_commands
end

-- Get commands by category
local function get_commands_by_category(category)
  if category == "all" then
    return get_all_commands()
  end
  return commands[category] or {}
end

-- Custom entry maker for better display
local function make_entry(command)
  return {
    value = command,
    display = function(entry)
      local cmd = entry.value
      local display_text = string.format("%-20s %-15s %s", 
        cmd.name or "", 
        cmd.keybind or "", 
        (cmd.explanation or ""):sub(1, 80) .. (string.len(cmd.explanation or "") > 80 and "..." or ""))
      return display_text
    end,
    ordinal = (command.name or "") .. " " .. (command.keybind or "") .. " " .. (command.explanation or ""),
  }
end

-- Custom previewer to show detailed help
local function create_help_previewer()
  return previewers.new_buffer_previewer({
    title = "Command Details",
    define_preview = function(self, entry, status)
      local cmd = entry.value
      local lines = {}
      
      table.insert(lines, "╭─ " .. (cmd.name or "Unknown Command") .. " ─╮")
      table.insert(lines, "")
      table.insert(lines, "🔧 Keybind: " .. (cmd.keybind or "N/A"))
      table.insert(lines, "📂 Category: " .. (cmd.category or "unknown"))
      table.insert(lines, "🎯 Modes: " .. table.concat(cmd.modes or {}, ", "))
      table.insert(lines, "")
      table.insert(lines, "📖 What it does:")
      
      -- Wrap long explanations
      local explanation = cmd.explanation or "No explanation available"
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
      
      if cmd.beginner_tip then
        table.insert(lines, "💡 Beginner Tip:")
        table.insert(lines, cmd.beginner_tip)
        table.insert(lines, "")
      end
      
      if cmd.when_to_use then
        table.insert(lines, "⏰ When to use:")
        table.insert(lines, cmd.when_to_use)
        table.insert(lines, "")
      end
      
      if cmd.examples then
        table.insert(lines, "📝 Examples:")
        for _, example in ipairs(cmd.examples) do
          table.insert(lines, "  • " .. example)
        end
        table.insert(lines, "")
      end
      
      if cmd.context_notes then
        table.insert(lines, "🌐 Context Notes:")
        for context, note in pairs(cmd.context_notes) do
          table.insert(lines, "  " .. context .. ": " .. note)
        end
      end
      
      vim.api.nvim_buf_set_lines(self.state.bufnr, 0, -1, false, lines)
      vim.api.nvim_buf_set_option(self.state.bufnr, "filetype", "markdown")
    end,
  })
end

-- Main picker function
function M.coach_picker(category)
  category = category or "all"
  local cmd_list = get_commands_by_category(category)
  
  if #cmd_list == 0 then
    vim.notify("No commands found for category: " .. category, vim.log.levels.WARN)
    return
  end
  
  pickers.new({}, {
    prompt_title = "Vim Coach - " .. string.upper(category:sub(1,1)) .. category:sub(2) .. " Commands (" .. #cmd_list .. " total)",
    finder = finders.new_table({
      results = cmd_list,
      entry_maker = make_entry,
    }),
    sorter = conf.generic_sorter({}),
    previewer = create_help_previewer(),
    layout_config = {
      horizontal = {
        preview_width = 0.6,
      },
    },
    attach_mappings = function(prompt_bufnr, map)
      actions.select_default:replace(function()
        actions.close(prompt_bufnr)
        local selection = action_state.get_selected_entry()
        local cmd = selection.value
        
        -- Copy keybind to clipboard if available
        if cmd.keybind then
          vim.fn.setreg("+", cmd.keybind)
          vim.notify("Copied '" .. cmd.keybind .. "' to clipboard! 📋", vim.log.levels.INFO)
        end
      end)
      
      -- Custom keymap to copy keybind
      map('i', '<C-y>', function()
        local selection = action_state.get_selected_entry()
        if selection and selection.value.keybind then
          vim.fn.setreg("+", selection.value.keybind)
          vim.notify("Copied '" .. selection.value.keybind .. "' to clipboard! 📋", vim.log.levels.INFO)
        end
      end)
      
      map('n', '<C-y>', function()
        local selection = action_state.get_selected_entry()
        if selection and selection.value.keybind then
          vim.fn.setreg("+", selection.value.keybind)
          vim.notify("Copied '" .. selection.value.keybind .. "' to clipboard! 📋", vim.log.levels.INFO)
        end
      end)
      
      return true
    end,
  }):find()
end

-- Setup function for plugin configuration
function M.setup(opts)
  opts = opts or {}
  
  -- Merge user config with defaults
  config = vim.tbl_deep_extend("force", config, opts)
  
  -- Optional: Add user commands if not already added by plugin file
  if not vim.fn.exists(':VimCoach') then
    vim.api.nvim_create_user_command("VimCoach", function(args)
      local category = args.args and args.args ~= "" and args.args or "all"
      M.coach_picker(category)
    end, {
      nargs = "?",
      complete = function()
        return { "all", "motions", "editing", "visual", "plugins" }
      end,
    })
  end
end

-- Get plugin info
function M.info()
  return {
    name = "vim-coach.nvim",
    version = "1.0.0",
    description = "A comprehensive Vim command reference for beginners",
    total_commands = #get_all_commands(),
    categories = vim.tbl_keys(commands),
  }
end

-- Export functions for external use
M.get_commands = get_commands_by_category
M.get_all_commands = get_all_commands

return M