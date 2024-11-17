return {
	{
		"MeanderingProgrammer/render-markdown.nvim",
		opts = {},
		dependencies = {
			"nvim-treesitter/nvim-treesitter",
			"nvim-tree/nvim-web-devicons",
		}, -- if you prefer nvim-web-devicons
		-- Disable hl color for code block background globally
		vim.api.nvim_set_hl(0, "RenderMarkdownCode", { bg = "" }),
		config = function()
			require("render-markdown").setup({
				file_types = { "markdown", "rmd", "Rmd" },
				bullet = {
					left_pad = 2,
				},
				code = {
					width = "block",
					min_width = 78,
					left_pad = 2,
					sign = false,
					above = "",
					below = "",
					style = "language",
				},
				heading = {
					position = "inline",
					below = "",
					sign = false,
					-- Disable hl color for all headings
					backgrounds = {
						"",
						"",
						"",
						"",
						"",
						"",
					},
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
			vim.g.mkdp_browser = ""
			if vim.fn.executable("npx") then
				vim.g.mkdp_filetypes = { "markdown" }
			end
		end,
	},
}
