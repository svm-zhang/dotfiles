local parsers = {
	"lua",
	"vim",
	"javascript",
	"html",
	"python",
	"r",
	"rnoweb",
	"rust",
	"bash",
	"csv",
	"diff",
	"markdown",
	"markdown_inline",
	"json",
	"toml",
	"xml",
	"yaml",
}

local filetypes = {
	"lua",
	"vim",
	"javascript",
	"html",
	"python",
	"r",
	"rmd",
	"rust",
	"sh",
	"bash",
	"csv",
	"diff",
	"markdown",
	"json",
	"toml",
	"xml",
	"yaml",
}

return {
	{
		"nvim-treesitter/nvim-treesitter",
		branch = "main",
		lazy = false,
		build = ":TSUpdate",
		config = function()
			local treesitter = require("nvim-treesitter")

			treesitter.setup()
			treesitter.install(parsers)

			vim.api.nvim_create_autocmd("FileType", {
				group = vim.api.nvim_create_augroup(
					"TreesitterStart",
					{ clear = true }
				),
				pattern = filetypes,
				callback = function(args)
					local ok = pcall(vim.treesitter.start, args.buf)
					if not ok then
						return
					end

					vim.bo[args.buf].indentexpr =
						"v:lua.require'nvim-treesitter'.indentexpr()"
				end,
			})
		end,
	},

	{
		"nvim-treesitter/nvim-treesitter-textobjects",
		branch = "main",
		dependencies = {
			"nvim-treesitter/nvim-treesitter",
		},
		config = function()
			require("nvim-treesitter-textobjects").setup({
				select = {
					lookahead = true,
					selection_modes = {
						["@parameter.outer"] = "v",
						["@function.outer"] = "V",
						["@class.outer"] = "V",
					},
					include_surrounding_whitespace = false,
				},
			})

			local select = require("nvim-treesitter-textobjects.select")
			local swap = require("nvim-treesitter-textobjects.swap")

			local function select_textobject(lhs, query, desc)
				vim.keymap.set({ "x", "o" }, lhs, function()
					select.select_textobject(query, "textobjects")
				end, { desc = desc, silent = true })
			end

			select_textobject(
				"aa",
				"@parameter.outer",
				"Select outer parameter"
			)
			select_textobject(
				"ia",
				"@parameter.inner",
				"Select inner parameter"
			)
			select_textobject("af", "@function.outer", "Select outer function")
			select_textobject("if", "@function.inner", "Select inner function")
			select_textobject("ac", "@class.outer", "Select outer class")
			select_textobject("ic", "@class.inner", "Select inner class")
			select_textobject(
				"ii",
				"@conditional.inner",
				"Select inner conditional"
			)
			select_textobject(
				"ai",
				"@conditional.outer",
				"Select outer conditional"
			)
			select_textobject("il", "@loop.inner", "Select inner loop")
			select_textobject("al", "@loop.outer", "Select outer loop")
			select_textobject("at", "@comment.outer", "Select outer comment")

			vim.keymap.set("n", "<leader>a", function()
				swap.swap_next("@parameter.inner")
			end, { desc = "Swap next parameter", silent = true })

			vim.keymap.set("n", "<leader>A", function()
				swap.swap_previous("@parameter.inner")
			end, { desc = "Swap previous parameter", silent = true })
		end,
	},
}
