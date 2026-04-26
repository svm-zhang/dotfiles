local trouble_symbol_kinds = {
	Class = true,
	Constructor = true,
	Enum = true,
	Function = true,
	Interface = true,
	Method = true,
	Struct = true,
	Trait = true,
}

local function trouble_symbol_filter(items)
	return vim.tbl_filter(function(item)
		if item.ft == "help" or item.ft == "markdown" then
			return true
		end

		if not trouble_symbol_kinds[item.kind] then
			return false
		end

		local text = item.text or ""
		return not (
			text:match("^%s*import%s+")
			or text:match("^%s*from%s+")
			or text:match("%simport%s+")
			or text:match("%sfrom%s+")
		)
	end, items)
end

local trouble_lsp_location_keys = {
	o = "jump_vsplit_close",
}

local trouble_lsp_preview = {
	type = "float",
	relative = "editor",
	border = "rounded",
	title = "Preview",
	title_pos = "center",
	position = { 0.5, -4 },
	size = { width = 0.45, height = 0.45 },
	zindex = 200,
}

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
			{ "<c-l>", "<cmd><C-U>TmuxNavigateRight<CR>" },
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
				symbols = {
					mode = "lsp_document_symbols",
					pinned = true,
					filter = trouble_symbol_filter,
					format = "{kind_icon} {symbol.name} {pos}",
					win = {
						relative = "win",
						position = "right",
						size = { width = 50 },
					},
				},
				lsp_definitions = {
					auto_jump = false,
					keys = trouble_lsp_location_keys,
					preview = trouble_lsp_preview,
				},
				lsp_references = {
					auto_jump = false,
					keys = trouble_lsp_location_keys,
					preview = trouble_lsp_preview,
				},
				lsp_implementations = {
					auto_jump = false,
					keys = trouble_lsp_location_keys,
					preview = trouble_lsp_preview,
				},
				lsp_type_definitions = {
					auto_jump = false,
					keys = trouble_lsp_location_keys,
					preview = trouble_lsp_preview,
				},
				lsp_declarations = {
					auto_jump = false,
					keys = trouble_lsp_location_keys,
					preview = trouble_lsp_preview,
				},
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
}
