return {

	{
		"nvim-neo-tree/neo-tree.nvim",
		branch = "v3.x",
		cmd = { "Neotree" },
		dependencies = {
			"nvim-lua/plenary.nvim",
			"nvim-tree/nvim-web-devicons",
			"MunifTanjim/nui.nvim",
		},
		config = function()
			local neotree = require("neo-tree")
			local neotree_cmd = require("neo-tree.command")

			neotree.setup({
				close_if_last_window = true,
				filesystem = {
					filtered_items = {
						hide_dotfiles = false,
					},
					follow_current_file = {
						enabled = true,
						leave_dirs_open = true,
					},
				},
				event_handlers = {
					{
						event = "file_open_requested",
						handler = function()
							neotree_cmd.execute({
								action = "close",
							})
						end,
					},
				},
			})
		end,
	},

	-- indentation highlight
	{
		"lukas-reineke/indent-blankline.nvim",
		main = "ibl",
		event = {
			"BufReadPre",
			"BufNewFile",
		},
		config = function()
			require("ibl").setup({
				indent = {
					char = "┊",
				},
			})
		end,
	},

	-- colorcolumn
	{
		"lukas-reineke/virt-column.nvim",
		opts = {
			char = "┊",
			virtcolumn = "79",
			exclude = {
				filetypes = {
					"markdown",
					"text",
					"gitcommit",
					"rmd",
					"Rmd",
				},
			},
		},
	},

	-- buffer tabs
	{
		"akinsho/bufferline.nvim",
		version = "*",
		dependencies = { "nvim-tree/nvim-web-devicons" },
		config = function()
			local bufferline = require("bufferline")

			bufferline.setup({
				options = {
					diagnostics = "nvim_lsp",
					mode = "tabs",
					numbers = "ordinal",
					separator_style = "padded_slope",
				},
			})
		end,
	},

	-- snipe to quickly switch between buffers
	{
		"leath-dub/snipe.nvim",
		opts = {
			ui = {
				position = "bottomleft",
			},
		},
	},

	-- status line
	{
		"nvim-lualine/lualine.nvim",
		dependencies = { "nvim-tree/nvim-web-devicons" },
		config = function()
			require("lualine").setup({
				options = {
					theme = "catppuccin-nvim",
				},
				sections = {
					lualine_a = { "mode" },
					lualine_b = { "branch" },
					lualine_c = {
						{
							"diagnostics",
							symbols = {
								error = " ",
								warn = " ",
								hint = " ",
								info = " ",
							},
						},
						{
							"filetype",
							icon_only = true,
							separator = "",
							padding = { left = 1, right = 0 },
						},
					},
					lualine_x = {
						{
							"diff",
							symbols = {
								added = " ",
								modified = " ",
								removed = " ",
							},
							source = function()
								local gitsigns = vim.b.gitsigns_status_dict
								if gitsigns then
									return {
										added = gitsigns.added,
										modified = gitsigns.changed,
										removed = gitsigns.removed,
									}
								end
							end,
						},
					},
					lualine_y = {
						{
							"progress",
							separator = " ",
							padding = { left = 1, right = 0 },
						},
						{ "location", padding = { left = 0, right = 1 } },
					},
					lualine_z = {
						function()
							return " " .. os.date("%R")
						end,
					},
				},
				extensions = { "neo-tree", "lazy" },
			})
		end,
	},
}
