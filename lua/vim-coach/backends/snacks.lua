-- Snacks.picker backend for vim-coach
local M = {}

-- Check if snacks is available
function M.is_available()
	local ok, snacks = pcall(require, "snacks")

	return ok and snacks.picker ~= nil
end

-- Get backend name
function M.get_name()
	return "snacks"
end

-- Show picker using snacks.picker
function M.show_picker(opts)
	local snacks = require("snacks")

	local title = opts.title or "Vim Coach"
	local category = opts.category or "all"
	local commands = require("vim-coach").get_commands_by_category(category)

	if #commands == 0 then
		vim.notify("No commands found", vim.log.levels.WARN, { title = "vim-coach.nvim" })

		return
	end

	-- Format commands for snacks.picker with flattened structure
	local items = {}
	for i, cmd in ipairs(commands) do
		if cmd then
			-- Build preview content
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
			table.insert(preview_content, cmd.explanation or "No explanation available")
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
					text = table.concat(preview_content, "\n"),
					ft = "text",
				},
			})
		end
	end

	snacks.picker({
		title = title
			.. " - "
			.. string.upper(category:sub(1, 1))
			.. category:sub(2)
			.. " Commands ("
			.. #commands
			.. ")",
		items = items,
		preview = "preview",
		win = {
			preview = {
				wo = {
					wrap = true,
					linebreak = true,
					breakindent = true,
				},
			},
		},
		format = function(item)
			local ret = {}

			-- Name with proper highlight
			ret[#ret + 1] = { string.format("%-25s", item.name), "SnacksPickerLabel" }

			-- Keybind
			ret[#ret + 1] = { string.format("%-12s", item.keybind), "SnacksPickerSpecial" }

			-- Truncated explanation
			local explanation = item.explanation or ""
			if #explanation > 50 then
				explanation = explanation:sub(1, 50) .. "..."
			end
			ret[#ret + 1] = { explanation, "SnacksPickerComment" }

			return ret
		end,
		confirm = function(picker, item)
			picker:close()
			if item.keybind and item.keybind ~= "N/A" and item.keybind ~= "" then
				vim.fn.setreg("+", item.keybind)
				vim.notify(
					"Copied '" .. item.keybind .. "' to clipboard! 📋",
					vim.log.levels.INFO,
					{ title = "vim-coach.nvim" }
				)
			end
		end,
		actions = {
			["<C-y>"] = function(picker, item)
				if item.keybind and item.keybind ~= "N/A" and item.keybind ~= "" then
					vim.fn.setreg("+", item.keybind)
					vim.notify(
						"Copied '" .. item.keybind .. "' to clipboard! 📋",
						vim.log.levels.INFO,
						{ title = "vim-coach.nvim" }
					)
				end
			end,
		},
	})
end

return M
