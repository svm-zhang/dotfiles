return {
	"nvim-treesitter/nvim-treesitter",
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
		})
	end,
}
