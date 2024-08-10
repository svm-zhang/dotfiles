return {

	-- transparent nvim
	{
		"xiyaowong/nvim-transparent",
		config = function()
			local transparent = require("transparent")

			transparent.setup({
				extra_groups = {
					"NeoTreeNormal",
					"NeoTreeFloatBorder",
					"NeoTreeNormalNC",
				},
			})

			transparent.clear_prefix("BufferLine")
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
				-- explicitly set default value to avoid lua_ls complaints
				open_fold_hl_timeout = 400,
				close_fold_kinds_for_ft = {},
				enable_get_fold_virt_text = false,
				provider_selector = function()
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
			modes = {
				my_lsp = {
					mode = { "diagnostics", "lsp_references", "lsp_definitions" },
					filter = { buf = 0 },
				},
			},
		},
		cmd = "Trouble",
		keys = {
			{ "<leader>xw", "<cmd>Trouble diagnostics toggle<CR>", desc = "Open trouble workspace diagnostics" },
			{
				"<leader>xr",
				"<cmd>Trouble lsp_references toggle<CR>",
				desc = "Open trouble lsp references",
			},
			{
				"<leader>xd",
				"<cmd>Trouble lsp_definitions toggle<CR>",
				desc = "Open trouble lsp definition",
			},
			{
				"<leader>xs",
				"<cmd>Trouble lsp_document_symbols toggle pinned=true win.relative=win win.size.width=50 win.position=right<CR>",
				desc = "Open trouble lsp document symbols",
			},
			{ "<leader>xq", "<cmd>Trouble quickfix toggle<CR>", desc = "Open trouble quickfix list" },
			{ "<leader>xl", "<cmd>Trouble loclist toggle<CR>", desc = "Open trouble location list" },
			{ "<leader>xt", "<cmd>Trouble todo toggle<CR>", desc = "Open todos in trouble" },
		},
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
				vim.keymap.set("n", "<leader>ee", "<cmd>Neotree toggle<CR>", { desc = "Toggle neo-tree" }),
			})
		end,
	},

	-- use toggleterm as primary way to send R code
	-- to R prompt
	{
		"akinsho/toggleterm.nvim",
		version = "*",
		config = function()
			local toggleterm = require("toggleterm")

			toggleterm.setup({
				size = 20,
				direction = "horizontal",
				-- set shell to be login shell to source .bash_profile
				-- every time we toggle a terminal
				shell = "bash -l",
			})

			local trim_spaces = true
			local keymap = vim.keymap
			keymap.set("v", "<leader>s", function()
				toggleterm.send_lines_to_terminal("visual_lines", trim_spaces, { args = vim.v.count })
			end, { desc = "Send visual selected lines to terminal" })

			function _G.set_terminal_keymaps()
				local opts = { buffer = 0 }
				vim.keymap.set("t", "<esc>", [[<C-\><C-n>]], opts)
				vim.keymap.set("t", "jk", [[<C-\><C-n>]], opts)
				vim.keymap.set("t", "<C-h>", [[<Cmd>wincmd h<CR>]], opts)
				vim.keymap.set("t", "<C-j>", [[<Cmd>wincmd j<CR>]], opts)
				vim.keymap.set("t", "<C-k>", [[<Cmd>wincmd k<CR>]], opts)
				vim.keymap.set("t", "<C-l>", [[<Cmd>wincmd l<CR>]], opts)
				vim.keymap.set("t", "<C-w>", [[<C-\><C-n><C-w>]], opts)
			end
			vim.cmd("autocmd! TermOpen term://*toggleterm#* lua set_terminal_keymaps()")
		end,
	},
}
