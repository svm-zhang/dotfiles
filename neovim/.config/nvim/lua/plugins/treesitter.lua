return {
	"nvim-treesitter/nvim-treesitter",
	dependencies = {
		"nvim-treesitter/nvim-treesitter-textobjects",
	},
	build = ":TSUpdate",
	event = { "BufReadPre", "BufNewFile" },
	config = function()
		local treesitter = require("nvim-treesitter.configs")

		treesitter.setup({
			-- below 4 lines to set required field
			-- to avoid missing-field by TSConfig
			modules = {},
			sync_install = false,
			auto_install = false,
			ignore_install = {},
			ensure_installed = {
				"lua",
				"vim",
				"javascript",
				"html",
				"python",
				"r",
				"rnoweb",
				"rust",
				"bash",
				"csv",
				"diff",
				"markdown",
				"markdown_inline",
				"json",
				"toml",
				"xml",
				"yaml",
			},
			highlight = { enable = true },
			indent = { enable = true },
			incremental_selection = {
				enable = true,
				keymaps = {
					init_selection = "<C-space>",
					node_incremental = "<C-space>",
					scope_incremental = false,
					node_decremental = "<bs>",
				},
			},
			textobjects = {
				select = {
					enable = true,
					lookahead = true,
					keymaps = {
						["aa"] = "@parameter.outer",
						["ia"] = "@parameter.inner",
						["af"] = "@function.outer",
						["if"] = "@function.inner",
						["ac"] = "@class.outer",
						["ic"] = "@class.inner",
						["ii"] = "@conditional.inner",
						["ai"] = "@conditional.outer",
						["il"] = "@loop.inner",
						["al"] = "@loop.outer",
						["at"] = "@comment.outer",
					},
				},
				swap = {
					enable = true,
					swap_next = {
						["<leader>a"] = "@parameter.inner",
					},
					swap_previous = {
						["<leader>A"] = "@parameter.inner",
					},
				},
			},
		})
	end,
}
