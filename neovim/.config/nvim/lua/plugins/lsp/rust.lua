return {
	{
		"mrcjkb/rustaceanvim",
		version = "^5", -- Recommended
		lazy = false, -- This plugin is already lazy
		["rust-analyzer"] = {
			cargo = {
				allFeatures = true,
			},
		},
	},

	{
		"saecki/crates.nvim",
		tag = "stable",
		dependencies = {
			"nvim-cmp",
		},
		config = function()
			require("crates").setup({
				popup = {
					autofocus = true,
					border = "rounded",
				},
				completion = {
					cmp = {
						enabled = true,
					},
					crates = {
						enabled = true,
					},
				},
			})
		end,
	},
}
