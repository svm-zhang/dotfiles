return {
	{
		"svm-zhang/doxi.nvim",
		ft = { "python" },
		keys = {
			{
				"<leader>de",
				function()
					require("doxi").open_visual()
				end,
				mode = "x",
				desc = "Open doxi for selection",
			},
		},
		config = function()
			require("doxi").setup({
				python_path = nil,
				lsp = {
					enabled = true,
					warn_unsupported = true,
					signature_help = {
						provider = "ambient",
					},
				},
				ui = {
					width = 100,
					height = 0.75,
					imports_height = 2,
					editor_height = 0.45,
					hints_height = 2,
					border = "rounded",
				},
				session_keymaps = {
					run_all = "<leader>ra",
					run_selection = "<leader>rs",
					restart = "<leader>rr",
					restart_rerun = "<leader>rR",
					apply = "<leader>da",
					cancel = "q",
				},
			})
		end,
	},
}
