return {
	{
		"MeanderingProgrammer/render-markdown.nvim",
		opts = {},
		dependencies = {
			"nvim-treesitter/nvim-treesitter",
			"nvim-tree/nvim-web-devicons",
		}, -- if you prefer nvim-web-devicons
		config = function()
			require("render-markdown").setup({
				file_types = { "markdown", "rmd", "Rmd" },
				code = {
					width = "block",
					right_pad = 1,
				},
			})
			vim.keymap.set(
				"n",
				"<leader>cm",
				"<cmd>RenderMarkdown toggle<CR>",
				{ desc = "Toggle to render markdown" }
			)
		end,
	},
}
