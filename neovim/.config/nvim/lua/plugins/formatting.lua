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
					html = { "prettier" },
					json = { "prettier" },
					lua = { "stylua" },
					markdown = {
						"prettier",
						"markdownlint-cli2",
						"markdown-toc",
					},
					python = function(bufnr)
						if
							conform.get_formatter_info("ruff_format", bufnr).available
						then
							return { "ruff_organize_imports", "ruff_format" }
						else
							return { "isort", "black" }
						end
					end,
					r = { "styler" },
					yaml = { "prettier" },
				},
				formatters = {
					stylua = {
						prepend_args = { "--column-width", "79" },
					},
					styler = {
						command = "R",
						args = {
							"-s",
							"-e",
							"styler::style_file(commandArgs(TRUE)[1])",
							"--args",
							"$FILENAME",
						},
						stdin = false,
					},
					["markdown-toc"] = {
						condition = function(_, ctx)
							for _, line in
								ipairs(
									vim.api.nvim_buf_get_lines(
										ctx.buf,
										0,
										-1,
										false
									)
								)
							do
								if line:find("<!%-%- toc %-%->") then
									return true
								end
							end
							return false
						end,
					},
					["markdownlint-cli2"] = {
						condition = function(_, ctx)
							local diag = vim.tbl_filter(function(d)
								return d.source == "markdownlint"
							end, vim.diagnostic.get(ctx.buf))
							return #diag > 0
						end,
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
