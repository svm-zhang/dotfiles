return {
	{
		"williamboman/mason.nvim",
		dependencies = {
			"williamboman/mason-lspconfig.nvim",
			"WhoIsSethDaniel/mason-tool-installer.nvim",
		},
		config = function()
			local mason = require("mason")

			local mason_lspconfig = require("mason-lspconfig")

			local mason_tool_installer = require("mason-tool-installer")

			mason.setup({
				ui = {
					icons = {
						package_installed = "✓",
						package_pending = "➜",
						package_uninstalled = "✗",
					},
				},
			})

			mason_lspconfig.setup({
				ensure_installed = {
					"bashls",
					"cssls",
					"lua_ls",
					"marksman",
					"pyright",
					"r_language_server",
					"yamlls",
				},
				automatic_enable = {
					-- Explicitly exclude stylua from being enabled as LSP
					-- This fixes the stylua command warning about no `--lsp` option.
					exclude = {
						"stylua",
					},
				},
				automatic_installation = true,
			})

			mason_tool_installer.setup({
				ensure_installed = {
					"black",
					"isort",
					"htmlbeautifier",
					"prettier",
					"stylua",
					"shfmt",
					"shellcheck",
					"ruff",
					"mypy",
				},
			})
		end,
	},
}
