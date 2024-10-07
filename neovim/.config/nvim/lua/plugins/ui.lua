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
					theme = "catppuccin",
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

	{
		"folke/noice.nvim",
		event = "VeryLazy",
		dependencies = {
			"MunifTanjim/nui.nvim",
			"rcarriga/nvim-notify",
		},
		config = function()
			local noice = require("noice")

			noice.setup({
				views = {
					cmdline_popup = {
						position = {
							row = 15,
							col = "50%",
						},
						size = {
							width = 60,
							height = "auto",
						},
					},
					-- need to set cmdline_popupmenu
					-- rather than popupmenu
					-- https://github.com/folke/noice.nvim/issues/507
					cmdline_popupmenu = {
						relative = "editor",
						position = {
							row = 17,
							col = "50%",
						},
						size = {
							width = 60,
							height = 10,
						},
						border = {
							style = "rounded",
							pading = { 0, 1 },
						},
					},
				},
				lsp = {
					-- override markdown rendering so that **cmp** and other plugins use **Treesitter**
					override = {
						["vim.lsp.util.convert_input_to_markdown_lines"] = true,
						["vim.lsp.util.stylize_markdown"] = true,
						["cmp.entry.get_documentation"] = true, -- requires hrsh7th/nvim-cmp
					},
				},
				presets = {
					command_palette = true,
					long_message_to_split = true,
				},
				routes = {
					-- this still bugged
					filter = {
						event = "msg_show",
						kind = "",
						any = {
							{ find = "%d+L, %d+B" },
							{ find = "; after #%d+" },
							{ find = "; before #%d+" },
							{ find = "%d fewer line" },
							{ find = "%d more line" },
						},
					},
					opts = { skip = true },
				},
			})
		end,
	},
}
