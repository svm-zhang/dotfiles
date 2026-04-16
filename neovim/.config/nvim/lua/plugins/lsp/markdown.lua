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
				-- Disable hl color for code block background globally
				vim.api.nvim_set_hl(0, "RenderMarkdownCode", { bg = "" }),
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
					icons = {
						"󰎤 ",
						"󰎧 ",
						"󰎪 ",
						"󰎭 ",
						"󰎱 ",
						"󰎳 ",
					},
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
		"selimacerbas/markdown-preview.nvim",
		dependencies = { "selimacerbas/live-server.nvim" },
		config = function()
			require("markdown_preview").setup({
				-- all optional; sane defaults shown
				instance_mode = "takeover", -- "takeover" (one tab) or "multi" (tab per instance)
				port = 0, -- 0 = auto (8421 for takeover, OS-assigned for multi)
				open_browser = true,
				debounce_ms = 300,
				-- mermaid rust renderer
				mermaid_renderer = "rust", -- default is js
			})
		end,
	},
}
