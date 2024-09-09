return {
	{
		"R-nvim/R.nvim",
		lazy = false,
		opts = {
			R_app = "radian",
			R_args = { "--quiet", "--no-save" },
			hook = {
				on_filetype = function()
					vim.keymap.set(
						"n",
						"<Enter>",
						"<Plug>RDSendLine",
						{ buffer = true }
					)
					vim.keymap.set(
						"v",
						"<Enter>",
						"<Plug>RDSendSelection",
						{ buffer = true }
					)
				end,
			},
			auto_start = "on startup",
			bracketed_paste = true,
			min_editor_width = 79,
			objbr_auto_start = true,
			objbr_place = "console,below",
			openpdf = true,
			pdfviewer = "",
			rconsole_width = 200,
			csv_app = "terminal:/opt/homebrew/bin/vd",
		},
		config = function(_, opts)
			vim.g.rout_follow_colorscheme = true
			require("r").setup(opts)
			require("r.pdf.generic").open = vim.ui.open
		end,
	},

	{
		"R-nvim/cmp-r",
	},
}
