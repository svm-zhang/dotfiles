return {
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
			local language_servers = require("lspconfig").util.available_servers() -- or list servers manually like {'gopls', 'clangd'}
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
				provider_selector = function(bufnr, filetype, buftype)
					return { "lsp", "indent" }
				end,
			})

			local keymap = vim.keymap

			keymap.set("n", "zR", ufo.openAllFolds, { desc = "Open all folds" })
			keymap.set("n", "zM", ufo.closeAllFolds, { desc = "Close all folds" })
			keymap.set("n", "zK", function()
				local winid = ufo.peekFoldedLinesUnderCursor()
				if not winid then
					vim.lsp.buf.hover()
				end
			end, { desc = "Peek Folds" })
		end,
	},

	-- automatic session save and restore
	{
		"rmagatti/auto-session",
		lazy = false,
		config = function()
			require("auto-session").setup({
				auto_session_suppress_dirs = { "~/", "~/Desktop", "~/Downloads", "~/Documents" },
			})
		end,
	},

	-- status line
	{
		"nvim-lualine/lualine.nvim",
		dependencies = { "nvim-tree/nvim-web-devicons" },
		config = function()
			require("lualine").setup({
				options = { theme = "dracula" },
			})
		end,
	},

	-- markdown live preview
	{
		"iamcco/markdown-preview.nvim",
		cmd = { "MarkdownPreviewToggle", "MarkdownPreview", "MarkdownPreviewStop" },
		ft = { "markdown" },
		-- https://github.com/iamcco/markdown-preview.nvim/issues/690
		build = function(plugin)
			if vim.fn.executable("npx") then
				vim.cmd("!cd " .. plugin.dir .. " && cd app && npx --yes yarn install")
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
		},
		cmd = "Trouble",
		keys = {
			{ "<leader>xw", "<cmd>Trouble diagnostics toggle<CR>", desc = "Open trouble workspace diagnostics" },
			{
				"<leader>xd",
				"<cmd>Trouble diagnostics toggle filter.buf=0<CR>",
				desc = "Open trouble document diagnostics",
			},
			{ "<leader>xq", "<cmd>Trouble quickfix toggle<CR>", desc = "Open trouble quickfix list" },
			{ "<leader>xl", "<cmd>Trouble loclist toggle<CR>", desc = "Open trouble location list" },
			{ "<leader>xt", "<cmd>Trouble todo toggle<CR>", desc = "Open todos in trouble" },
		},
	},
}
