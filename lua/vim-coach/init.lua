-- vim-coach.nvim - A comprehensive Vim command reference for beginners
-- Main plugin module

local M = {}

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
	picker = "snacks", -- "snacks" (Default) | "telescope"
	keymaps = {
		copy_keymap = "<C-y>",
		close = "<Esc>",
	},
	user_commands = {},
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

-- Register custom user commands (or override existing)
local function register(cmds)
	for cat, content in pairs(cmds) do
		if commands[cat] == nil then
			commands[cat] = #content > 0 and content or nil
		else
			commands[cat] = vim.tbl_deep_extend("force", commands[cat], content or {})
		end
	end
end

-- Main picker function using snacks.picker
function M.coach_picker(category)
	category = category or "all"
	require("vim-coach.backends").show_picker({ category = category })
end

-- Setup function for plugin configuration
function M.setup(opts)
	opts = opts or {}

	-- Merge user config with defaults
	config = vim.tbl_deep_extend("force", config, opts)

	-- Notify user about selected backend
	if config.picker ~= "snacks" and config.picker ~= "telescope" then
		vim.notify(
			"Selected picker: " .. config.picker .. " isn't available. Using default or installed picker",
			vim.log.levels.INFO,
			{ title = "vim-coach.nvim" }
		)
		config.picker = "snacks"
		require("vim-coach.backends").set_backend("snacks")
	else
		require("vim-coach.backends").set_backend(config.picker)
	end

	-- Check for at least one picker backend
	local has_picker = pcall(require, config.picker)
	if has_picker then
		if config.picker == "snacks" then
			local has_snacks_picker = has_picker and pcall(function()
				return require("snacks").picker
			end)
			if not has_snacks_picker then
				vim.notify(
					"vim-coach.nvim requires snacks.nvim with picker support enabled",
					vim.log.levels.ERROR,
					{ title = "vim-coach.nvim" }
				)
				return
			end
		end
	else
		vim.notify(
			"vim-coach.nvim requires " .. config.picker .. " to be installed",
			vim.log.levels.ERROR,
			{ title = "vim-coach.nvim" }
		)
		return
	end

	-- Register custom user commands
	register(config.user_commands)

	-- Optional: Add user commands if not already added by plugin file
	if not vim.fn.exists(":VimCoach") then
		vim.api.nvim_create_user_command("VimCoach", function(args)
			local category = args.args and args.args ~= "" and args.args or "all"
			M.coach_picker(category)
		end, {
			nargs = "?",
			complete = function()
				return M.get_categories()
			end,
		})
	end
end

-- Get all categories
local function get_categories()
	local categories = {}
	for category, _ in pairs(commands) do
		table.insert(categories, category)
	end
	return categories
end

-- Get plugin info
function M.info()
	return {
		name = "vim-coach.nvim",
		version = "2.2.0",
		description = "A comprehensive Vim command reference for beginners",
		total_commands = #get_all_commands(),
		categories = vim.tbl_keys(commands),
		picker = config.picker .. ".nvim",
	}
end

-- Export functions for external use
M.register_commands = register
M.get_commands = get_commands_by_category
M.get_all_commands = get_all_commands
M.get_categories = get_categories

return M
