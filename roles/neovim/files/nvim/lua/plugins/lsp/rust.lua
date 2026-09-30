return {
	{
		"mrcjkb/rustaceanvim",
		version = "^5",
		lazy = false,
		config = function()
			vim.g.rustaceanvim = {
				server = {
					default_settings = {
						["rust-analyzer"] = {
							cargo = {
								allFeatures = true,
							},
						},
					},
				},
			}
		end,
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
