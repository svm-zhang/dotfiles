local have_make = vim.fn.executable("make") == 1
local have_cmake = vim.fn.executable("cmake") == 1

return {
	{
		"nvim-telescope/telescope.nvim",
		tag = "0.1.8",
		dependencies = {
			"nvim-lua/plenary.nvim",
			"nvim-tree/nvim-web-devicons",
			"folke/todo-comments.nvim",
			"nvim-telescope/telescope-fzf-native.nvim",
			build = have_make and "make"
				or "cmake -S. -Bbuild -DCMAKE_BUILD_TYPE=Release && cmake --build build --config Release && cmake --install build --prefix build",
			enabled = have_make or have_cmake,
		},
		config = function()
			local telescope = require("telescope")
			local actions = require("telescope.actions")

			telescope.setup({
				defaults = {
					mappings = {
						i = {
							["<C-k>"] = actions.move_selection_previous, -- move to previous result
							["<C-j>"] = actions.move_selection_next, -- move to next result
							["<C-q>"] = actions.send_selected_to_qflist + actions.open_qflist,
						},
					},
				},
			})
			telescope.load_extension("fzf")

			-- set keybindings
			local keymap = vim.keymap

			keymap.set("n", "<leader>ff", "<cmd>Telescope find_files<CR>", { desc = "Fuzzy find files in cwd" })
			keymap.set("n", "<leader>fr", "<cmd>Telescope oldfiles<CR>", { desc = "Fuzzy find recent files" })
			keymap.set("n", "<leader>fs", "<cmd>Telescope live_grep<CR>", { desc = "Find string in cwd" })
			keymap.set(
				"n",
				"<leader>fc",
				"<cmd>Telescope grep_string<CR>",
				{ desc = "Find string under cursor in cwd" }
			)
			keymap.set("n", "<leader>ft", function()
				vim.api.nvim_command("TodoTelescope cwd=" .. vim.fn.expand("%:p:h"))
			end, { desc = "Find TODO comments" })
		end,
	},

	{
		"nvim-telescope/telescope-ui-select.nvim",
		config = function()
			local telescope = require("telescope")
			local telescope_themes = require("telescope.themes")
			-- This is your opts table
			telescope.setup({
				extensions = {
					["ui-select"] = {
						telescope_themes.get_dropdown({}),
					},
				},
			})
			-- To get ui-select loaded and working with telescope, you need to call
			-- load_extension, somewhere after setup function:
			telescope.load_extension("ui-select")
		end,
	},
}
