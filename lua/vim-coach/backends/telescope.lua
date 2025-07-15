-- Telescope backend for vim-coach
local M = {}

-- Check if telescope is available
function M.is_available()
	return pcall(require, "telescope")
end

-- Get backend name
function M.get_name()
	return "telescope"
end

-- Show picker using telescope
function M.show_picker(opts)
	local pickers = require("telescope.pickers")
	local finders = require("telescope.finders")
	local conf = require("telescope.config").values
	local actions = require("telescope.actions")
	local action_state = require("telescope.actions.state")
	local previewers = require("telescope.previewers")

	local title = opts.title or "Vim Coach"
	local category = opts.category or "all"
	local commands = require("vim-coach").get_commands(category)

	-- Custom entry maker for better display
	local function make_entry(command)
		return {
			value = command,
			display = function(entry)
				local cmd = entry.value
				local display_text = string.format(
					"%-20s %-15s %s",
					cmd.name or "",
					cmd.keybind or "",
					(cmd.explanation or ""):sub(1, 80) .. (string.len(cmd.explanation or "") > 80 and "..." or "")
				)

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
				local preview_content = {}

				-- Header
				table.insert(preview_content, "╭─ " .. (cmd.name or "Unknown Command") .. " ─╮")
				table.insert(preview_content, "")

				-- Basic info
				table.insert(preview_content, "🔧 Keybind: " .. (cmd.keybind or "N/A"))
				table.insert(preview_content, "📂 Category: " .. (cmd.category or category))
				table.insert(preview_content, "🎯 Modes: " .. table.concat(cmd.modes or {}, ", "))
				table.insert(preview_content, "")

				-- Explanation
				table.insert(preview_content, "📖 What it does:")
				-- table.insert(preview_content, cmd.explanation or "No explanation available")
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
					table.insert(preview_content, line)
				end
				table.insert(preview_content, "")

				-- Beginner tip
				if cmd.beginner_tip then
					table.insert(preview_content, "💡 Beginner Tip:")
					table.insert(preview_content, cmd.beginner_tip)
					table.insert(preview_content, "")
				end

				-- When to use
				if cmd.when_to_use then
					table.insert(preview_content, "⏰ When to use:")
					table.insert(preview_content, cmd.when_to_use)
					table.insert(preview_content, "")
				end

				-- Examples
				if cmd.examples and #cmd.examples > 0 then
					table.insert(preview_content, "📝 Examples:")
					for _, example in ipairs(cmd.examples) do
						table.insert(preview_content, "  • " .. example)
					end
					table.insert(preview_content, "")
				end

				-- Context notes
				if cmd.context_notes then
					table.insert(preview_content, "🌐 Context Notes:")
					for context, note in pairs(cmd.context_notes) do
						table.insert(preview_content, "  " .. context .. ": " .. note)
					end
				end

				vim.api.nvim_buf_set_lines(self.state.bufnr, 0, -1, false, preview_content)
				vim.api.nvim_set_option_value("filetype", "text", { buf = self.state.bufnr })
			end,
		})
	end

	if #commands == 0 then
		vim.notify("No commands found", vim.log.levels.WARN, { title = "vim-coach.nvim" })

		return
	end

	pickers
		.new({}, {
			prompt_title = title
				.. " - "
				.. string.upper(category:sub(1, 1))
				.. category:sub(2)
				.. " Commands ("
				.. #commands
				.. ")",
			finder = finders.new_table({
				results = commands,
				entry_maker = make_entry,
			}),
			sorter = conf.generic_sorter({}),
			previewer = create_help_previewer(),
			layout_config = {
				horizontal = {
					preview_width = 0.75,
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
						vim.notify(
							"Copied '" .. cmd.keybind .. "' to clipboard! 📋",
							vim.log.levels.INFO,
							{ title = "vim-coach.nvim" }
						)
					end
				end)

				-- Custom keymap to copy keybind
				map("i", "<C-y>", function()
					local selection = action_state.get_selected_entry()

					if selection and selection.value.keybind then
						vim.fn.setreg("+", selection.value.keybind)
						vim.notify(
							"Copied '" .. selection.value.keybind .. "' to clipboard! 📋",
							vim.log.levels.INFO,
							{ title = "vim-coach.nvim" }
						)
					end
				end)

				map("n", "<C-y>", function()
					local selection = action_state.get_selected_entry()

					if selection and selection.value.keybind then
						vim.fn.setreg("+", selection.value.keybind)
						vim.notify(
							"Copied '" .. selection.value.keybind .. "' to clipboard! 📋",
							vim.log.levels.INFO,
							{ title = "vim-coach.nvim" }
						)
					end
				end)

				return true
			end,
		})
		:find()
end

return M
