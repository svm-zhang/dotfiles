return {

	-- which_key show available key bindings
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
				{ "<leader>e", group = "edit" },
				{ "<leader>f", group = "file/find" },
				{ "<leader>g", group = "git" },
				{ "<leader>h", group = "hunks" },
				{
					"<leader>m",
					group = "markdown",
					icon = { icon = "" },
				},
				{ "<leader>n", group = "notif" },
				{ "<leader>o", group = "obsidian", icon = { icon = "󱞁 " } },
				{ "<leader>p", group = "preview", icon = { icon = " " } },
				{ "<leader>q", group = "quit/session" },
				{ "<leader>r", group = "rust", icon = { icon = "" } },
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

	-- vim-pencil
	{
		"preservim/vim-pencil",
		ft = { "markdown", "Rmd", "text" },
		init = function()
			vim.g["pencil#textwidth"] = 79
			vim.g["pencil#wrapModeDefault"] = "hard"
			vim.g["pencil$autoformat"] = 1
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

			goto_preview.setup()
		end,
	},

	-- url-open.nvim
	{
		"sontungexpt/url-open",
		event = "VeryLazy",
		cmd = "URLOpenUnderCursor",
		config = function()
			local status_ok, url_open = pcall(require, "url-open")
			if not status_ok then
				return
			end
			url_open.setup({
				open_app = "default",
				open_only_when_cursor_on_url = true,
			})
		end,
	},
}
