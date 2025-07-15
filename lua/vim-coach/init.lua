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
	distro_commands = {
		lazyvim = false,
		nvchad = false,
	},
	keymaps = {
		copy_keymap = "<C-y>",
		close = "<Esc>",
	},
}

-- Merge all commands into one searchable database
local function get_all_commands()
	local all_commands = {}
	if config.distro_commands.lazyvim then
		commands["lazyvim"] = require("vim-coach.commands.distros.lazyvim")
	end
	if config.distro_commands.nvchad then
		commands["nvchad"] = require("vim-coach.commands.distros.lazyvim")
	end
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

-- Main picker function using snacks.picker
function M.coach_picker(category)
	category = category or "all"
	require("vim-coach.backends").show_picker({ category = category })
end

-- Setup function for plugin configuration
function M.setup(opts)
	opts = opts or {}

	-- Notify user about selected backend
	if opts.picker ~= "snacks" and opts.picker ~= "telescope" then
		vim.notify(
			"Selected picker: " .. opts.picker .. " isn't available. Using default or installed picker",
			vim.log.levels.INFO,
			{ title = "vim-coach.nvim" }
		)
		opts.picker = "snacks"
		require("vim-coach.backends").set_backend("snacks")
	end

	-- Check for at least one picker backend
	local has_picker = pcall(require, opts.picker)
	if has_picker then
		if opts.picker == "snacks" then
			local has_snacks_picker = has_picker and pcall(function()
				return require("snacks").picker
			end)
			if not has_snacks_picker then
				vim.notify(
					"vim-coach.nvim requires snacks.nvim with picker support enabled",
					vim.log.levels.ERROR,
					{ title = "vim-coach.nvim" }
				)
				-- vim.api.nvim_err_writeln('vim-coach.nvim requires snacks.nvim with picker support enabled')
				return
			end
		end
	else
		vim.notify(
			"vim-coach.nvim requires " .. opts.picker .. " to be installed",
			vim.log.levels.ERROR,
			{ title = "vim-coach.nvim" }
		)
		-- vim.api.nvim_err_writeln("vim-coach.nvim requires either telescope.nvim or snacks.nvim with picker support")

		return
	end

	-- Merge user config with defaults
	config = vim.tbl_deep_extend("force", config, opts)

	-- Optional: Add user commands if not already added by plugin file
	if not vim.fn.exists(":VimCoach") then
		vim.api.nvim_create_user_command("VimCoach", function(args)
			local category = args.args and args.args ~= "" and args.args or "all"
			M.coach_picker(category)
		end, {
			nargs = "?",
			complete = function()
				local categories = { "all", "motions", "editing", "visual", "plugins" }
				if config.distro_commands.lazyvim then
					table.insert(categories, "lazyvim")
				end
				if config.distro_commands.nvchad then
					table.insert(categories, "nvchad")
				end
				return categories
			end,
		})
	end
end

-- Get plugin info
function M.info()
	return {
		name = "vim-coach.nvim",
		version = "2.1.0",
		description = "A comprehensive Vim command reference for beginners",
		total_commands = #get_all_commands(),
		categories = vim.tbl_keys(commands),
		picker = "snacks.nvim(default)", -- "telescope.nvim"
	}
end

-- Export functions for external use
M.get_commands = get_commands_by_category
M.get_all_commands = get_all_commands

return M
