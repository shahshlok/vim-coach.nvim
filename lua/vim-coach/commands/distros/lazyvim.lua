return {
	{
		name = "Toggle Auto Format (Global)",
		keybind = "<leader>uf",
		modes = { "n" },
		explanation = "Toggle Auto Format (Global)",
		beginner_tip = "Help keep your code clean and consistent",
		when_to_use = "When you want to toggle auto format on and off globally",
		context_notes = {
			file = "Toggle auto format on and off globally",
			explorer = "Usually not applicable in file explorers",
		},
		examples = { "<leader>uf - Toggle Auto Format (Global)", "Formatting is performed automatically" },
	},
	-- ...,
}
