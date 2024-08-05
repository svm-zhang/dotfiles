return {
	-- indentation highlight
	{
		"lukas-reineke/indent-blankline.nvim",
		main = "ibl",
		event = {
			"BufReadPre",
			"BufNewFile",
		},
		config = function()
			require("ibl").setup({
				indent = {
					char = "┊",
				},
			})
		end,
	},

	-- buffer tabs
	{
		"akinsho/bufferline.nvim",
		version = "*",
		dependencies = { "nvim-tree/nvim-web-devicons" },
		config = function()
			local bufferline = require("bufferline")

			bufferline.setup({
				options = {
					diagnostics = "nvim_lsp",
					mode = "tabs",
					numbers = "ordinal",
					separator_style = "padded_slope",
				},
			})
		end,
	},

	-- code folding
	{
		"kevinhwang91/nvim-ufo",
		dependencies = {
			"kevinhwang91/promise-async",
		},
		config = function()
			local ufo = require("ufo")
			local capabilities = vim.lsp.protocol.make_client_capabilities()
			capabilities.textDocument.foldingRange = {
				dynamicRegistration = false,
				lineFoldingOnly = true,
			}
			local language_servers = require("lspconfig").util.available_servers() -- or list servers manually like {'gopls', 'clangd'}
			for _, ls in ipairs(language_servers) do
				require("lspconfig")[ls].setup({
					capabilities = capabilities,
					-- you can add other fields for setting up lsp server in this table
				})
			end

			ufo.setup({
				preview = {
					mappings = {
						scrollU = "<C-k>",
						scrollD = "<C-j>",
					},
				},
				provider_selector = function(bufnr, filetype, buftype)
					return { "lsp", "indent" }
				end,
			})

			local keymap = vim.keymap

			keymap.set("n", "zR", ufo.openAllFolds, { desc = "Open all folds" })
			keymap.set("n", "zM", ufo.closeAllFolds, { desc = "Close all folds" })
			keymap.set("n", "zK", function()
				local winid = ufo.peekFoldedLinesUnderCursor()
				if not winid then
					vim.lsp.buf.hover()
				end
			end, { desc = "Peek Folds" })
		end,
	},

	-- automatic session save and restore
	{
		"rmagatti/auto-session",
		lazy = false,
		config = function()
			require("auto-session").setup({
				auto_session_suppress_dirs = { "~/", "~/Desktop", "~/Downloads", "~/Documents" },
			})
		end,
	},

	-- status line
	{
		"nvim-lualine/lualine.nvim",
		dependencies = { "nvim-tree/nvim-web-devicons" },
		config = function()
			require("lualine").setup({
				options = { theme = "dracula" },
			})
		end,
	},
}
