return {
	{
		"L3MON4D3/LuaSnip",
		dependencies = {
			"rafamadriz/friendly-snippets",
		},
		config = function()
			local luasnip = require("luasnip")

			luasnip.config.setup({
				update_events = { "TextChanged", "TextChangedI" },
				delete_check_events = "TextChanged",
				enable_autosnippets = false,
			})

			luasnip.filetype_extend("python", { "pydoc" })
			luasnip.filetype_extend("rust", { "rustdoc" })
			luasnip.filetype_extend("cpp", { "cppdoc" })
			luasnip.filetype_extend("sh", { "shelldoc" })

			vim.keymap.set({ "i", "s" }, "<C-L>", function()
				if luasnip.expand_or_jumpable() then
					luasnip.expand_or_jump()
				end
			end, { silent = true, desc = "LuaSnip expand or jump" })

			vim.keymap.set({ "i", "s" }, "<C-H>", function()
				if luasnip.jumpable(-1) then
					luasnip.jump(-1)
				end
			end, { silent = true, desc = "LuaSnip jump backward" })

			vim.keymap.set({ "i", "s" }, "<C-Y>", function()
				if luasnip.choice_active() then
					luasnip.change_choice(1)
				end
			end, { silent = true, desc = "LuaSnip next choice" })

			require("luasnip.loaders.from_vscode").lazy_load()
			require("luasnip.loaders.from_lua").lazy_load({
				paths = vim.fn.stdpath("config") .. "/lua/snippets",
			})
		end,
	},
}
