return {
	{
		"linux-cultist/venv-selector.nvim",
		branch = "regexp",
		dependencies = {
			"neovim/nvim-lspconfig",
			"nvim-telescope/telescope.nvim",
			"mfussenegger/nvim-dap-python",
		},
		ft = "python",
		lazy = false,
		opts = {
			settings = {
				options = {
					debug = true,
					notify_user_on_venv_activation = true,
				},
			},
		},
	},
}
