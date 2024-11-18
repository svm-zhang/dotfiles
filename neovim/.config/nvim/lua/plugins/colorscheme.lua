return {
	{
		"catppuccin/nvim",
		lazy = false,
		name = "catppuccin",
		priority = 1000,
		config = function()
			require("catppuccin").setup({
				flavour = "macchiato",
				transparent_background = true,
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
				integrations = {
					bufferline = true,
					cmp = true,
					diffview = true,
					gitsigns = true,
					indent_blankline = {
						enabled = true,
						scope_color = "lavender",
					},
					lsp_trouble = true,
					mason = true,
					native_lsp = {
						enabled = true,
						underlines = {
							errors = { "undercurl" },
							hints = { "undercurl" },
							warnings = { "undercurl" },
							information = { "undercurl" },
						},
					},
					neogit = true,
					neotree = true,
					noice = true,
					notify = true,
					nvim_surround = true,
					telescope = true,
					treesitter = true,
					ufo = true,
					which_key = true,
				},
			})

			vim.cmd.colorscheme("catppuccin")
		end,
	},
}
