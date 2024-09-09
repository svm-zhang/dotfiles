return {

	-- which_key show avilable key bindings
	{
		"folke/which-key.nvim",
		event = "VeryLazy",
		opts = {
			-- your configuration comes here
			-- or leave it empty to use the default settings
			-- refer to the configuration section below
			defaults = {
				preset = "modern",
			},
			spec = {
				mode = { "n", "v" },
				{ "<leader>c", group = "code" },
				{ "<leader>f", group = "file/find" },
				{ "<leader>g", group = "git" },
				{ "<leader>h", group = "hunks" },
				{ "<leader>n", group = "notif" },
				{ "<leader>q", group = "quit/session" },
				{ "<leader>s", group = "search" },
				{ "<leader>t", group = "tabs" },
				{ "<leader>w", group = "window" },
				{ "<leader>x", group = "diagnostics" },
				{ "z", group = "fold" },
			},
		},
		keys = {
			{
				"<leader>?",
				function()
					require("which-key").show({ global = false })
				end,
				desc = "Buffer Local Keymaps (which-key)",
			},
		},
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

	-- code folding
	{
		"kevinhwang91/nvim-ufo",
		dependencies = {
			"kevinhwang91/promise-async",
		},
		config = function()
			local ufo = require("ufo")
			local capabilities = vim.lsp.protocol.make_client_capabilities()
			capabilities.textDocument.foldingRange = {
				dynamicRegistration = false,
				lineFoldingOnly = true,
			}
			local language_servers =
				require("lspconfig").util.available_servers() -- or list servers manually like {'gopls', 'clangd'}
			for _, ls in ipairs(language_servers) do
				require("lspconfig")[ls].setup({
					capabilities = capabilities,
					-- you can add other fields for setting up lsp server in this table
				})
			end

			ufo.setup({
				preview = {
					mappings = {
						scrollU = "<C-k>",
						scrollD = "<C-j>",
					},
				},
				-- explicitly set default value to avoid lua_ls complaints
				open_fold_hl_timeout = 400,
				close_fold_kinds_for_ft = {},
				enable_get_fold_virt_text = false,
				provider_selector = function()
					return { "lsp", "indent" }
				end,
			})
		end,
	},

	-- automatic session save and restore
	{
		"rmagatti/auto-session",
		lazy = false,
		config = function()
			require("auto-session").setup({
				auto_session_suppress_dirs = {
					"~/",
					"~/Desktop",
					"~/Downloads",
					"~/Documents",
				},
			})
		end,
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
			})
		end,
	},

	-- markdown live preview
	{
		"iamcco/markdown-preview.nvim",
		cmd = {
			"MarkdownPreviewToggle",
			"MarkdownPreview",
			"MarkdownPreviewStop",
		},
		ft = { "markdown" },
		-- https://github.com/iamcco/markdown-preview.nvim/issues/690
		build = function(plugin)
			if vim.fn.executable("npx") then
				vim.cmd(
					"!cd "
						.. plugin.dir
						.. " && cd app && npx --yes yarn install"
				)
			else
				vim.cmd([[Lazy load markdown-preview.nvim]])
				vim.fn["mkdp#util#install"]()
			end
		end,
		init = function()
			if vim.fn.executable("npx") then
				vim.g.mkdp_filetypes = { "markdown" }
			end
		end,
	},

	-- comment
	{
		"numToStr/Comment.nvim",
		event = { "BufReadPre", "BufNewFile" },
		config = true,
	},

	-- todo comment
	{
		"folke/todo-comments.nvim",
		event = { "BufReadPre", "BufNewFile" },
		dependencies = { "nvim-lua/plenary.nvim" },
		opts = {},
	},

	-- vim tmux navigation
	{
		"christoomey/vim-tmux-navigator",
		cmd = {
			"TmuxNavigateLeft",
			"TmuxNavigateDown",
			"TmuxNavigateUp",
			"TmuxNavigateRight",
			"TmuxNavigatePrevious",
		},
		keys = {
			{ "<c-h>", "<cmd><C-U>TmuxNavigateLeft<CR>" },
			{ "<c-j>", "<cmd><C-U>TmuxNavigateDown<CR>" },
			{ "<c-k>", "<cmd><C-U>TmuxNavigateUp<CR>" },
			{ "<c-l>", "<cmd><C-U>TmuxNavigteRight<CR>" },
			{ "<c-\\>", "<cmd><C-U>TmuxNavigatePrevious<CR>" },
		},
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

	-- show where troubles are
	{
		"folke/trouble.nvim",
		dependencies = {
			"nvim-tree/nvim-web-devicons",
			"folke/todo-comments.nvim",
		},
		opts = {
			focus = true,
			modes = {
				my_lsp = {
					mode = {
						"diagnostics",
						"lsp_references",
						"lsp_definitions",
					},
					filter = { buf = 0 },
				},
			},
		},
		cmd = "Trouble",
	},

	{
		"rmagatti/goto-preview",
		event = "BufEnter",
		config = function()
			local goto_preview = require("goto-preview")
			local keymap = vim.keymap

			keymap.set(
				"n",
				"gp",
				"<cmd>lua require('goto-preview').goto_preview_definition()<CR>",
				{ desc = "Preview definition in float window" }
			)
			keymap.set(
				"n",
				"gr",
				"<cmd>lua require('goto-preview').goto_preview_references()<CR>",
				{ desc = "Preview references in float window" }
			)
			keymap.set(
				"n",
				"gd",
				"<cmd>lua require('goto-preview').close_all_win()<CR>",
				{ desc = "Preview definition in float window" }
			)

			goto_preview.setup()
		end,
	},

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
			require("neo-tree").setup({
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
			})
		end,
	},
}
