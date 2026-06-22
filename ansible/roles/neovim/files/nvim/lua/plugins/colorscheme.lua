return {
	{
		"catppuccin/nvim",
		lazy = false,
		name = "catppuccin",
		priority = 1000,
		config = function()
			require("catppuccin").setup({
				flavour = "macchiato",
				auto_integrations = true,
				transparent_background = true,
				float = {
					transparent = true,
					solid = true,
				},
				custom_highlights = function(colors)
					local u = require("catppuccin.utils.colors")
					return {
						DiffAdd = { bg = "" },
						DiffChange = { bg = "" },
						DiffDelete = { bg = "" },
						Visual = {
							bg = u.blend(colors.overlay0, colors.base, 0.7),
						},
						CursorLine = {
							bg = u.blend(colors.overlay0, colors.base, 0.7),
						},
						-- colors.mantle under Latte theme
						LineNr = { fg = "#e6e9ef" },
						Comment = { fg = colors.flamingo },
					}
				end,
				term_colors = true,
				lsp_styles = {
					underlines = {
						errors = { "undercurl" },
						hints = { "underline" },
						warnings = { "undercurl" },
						information = { "underline" },
						ok = { "underline" },
					},
				},
				integrations = {
					indent_blankline = {
						enabled = true,
						scope_color = "lavender",
					},
				},
			})

			vim.cmd.colorscheme("catppuccin")
		end,
	},

	{
		"folke/tokyonight.nvim",
		lazy = true,
	},

	{ "EdenEast/nightfox.nvim", lazy = true },
}
