return {
	-- formatting
	{
		"stevearc/conform.nvim",
		event = { "BufReadPre", "BufNewFile" },
		config = function()
			local conform = require("conform")

			conform.setup({
				formatters_by_ft = {
					bash = { "shfmt" },
					css = { "prettier" },
					html = { "htmlbeautifier" },
					json = { "prettier" },
					lua = { "stylua" },
					python = function(bufnr)
						if
							conform.get_formatter_info("ruff_format", bufnr).available
						then
							return {
								"ruff_organize_imports",
								"ruff_format",
							}
						else
							return { "isort", "black" }
						end
					end,
					yaml = { "prettier" },
				},
				formatters = {
					ruff_format = {
						append_args = {
							"--line-length",
							"79",
						},
					},
					stylua = {
						prepend_args = { "--column-width", "79" },
					},
				},
				format_on_save = {
					lsp_fallback = true,
					async = false,
					timeout = 500,
				},
			})
		end,
	},
}
