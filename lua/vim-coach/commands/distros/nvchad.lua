return {
	{
		name = "Toggle line number",
		keybind = "<leader>n",
		modes = { "n" },
		explanation = "Toggles showing line numbers",
		beginner_tip = "Show or hide line numbers",
		when_to_use = "When you want to Show or hide line numbers. eg. in markdown",
		context_notes = {
			file = "When viewing markdown files especially",
			explorer = "Usually not applicable in file explorers",
		},
		examples = { "<leader>n - Toggle line number", "Show or hide line numbers" },
	},
	-- ...,
}
