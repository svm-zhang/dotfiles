local have_make = vim.fn.executable("make") == 1
local have_cmake = vim.fn.executable("cmake") == 1

local function find_files_command()
	if vim.fn.executable("fd") == 1 then
		return { "fd", "--type", "f", "--color", "never", "--exclude", ".git" }
	end

	if vim.fn.executable("fdfind") == 1 then
		return {
			"fdfind",
			"--type",
			"f",
			"--color",
			"never",
			"--exclude",
			".git",
		}
	end

	if vim.fn.executable("rg") == 1 then
		return { "rg", "--files", "--color", "never", "--glob", "!**/.git/*" }
	end

	if vim.fn.executable("find") == 1 and vim.fn.has("win32") == 0 then
		return {
			"find",
			".",
			"-path",
			"*/.git",
			"-prune",
			"-o",
			"-type",
			"f",
			"-print",
		}
	end
end

return {
	{
		"nvim-telescope/telescope.nvim",
		version = "0.2.*",
		dependencies = {
			"nvim-lua/plenary.nvim",
			"nvim-tree/nvim-web-devicons",
			{
				"nvim-telescope/telescope-fzf-native.nvim",
				build = have_make and "make"
					or "cmake -S. -Bbuild -DCMAKE_BUILD_TYPE=Release && cmake --build build --config Release && cmake --install build --prefix build",
				enabled = have_make or have_cmake,
			},
			"nvim-telescope/telescope-ui-select.nvim",
		},
		config = function()
			local telescope = require("telescope")
			local actions = require("telescope.actions")
			local telescope_config = require("telescope.config")
			local telescope_themes = require("telescope.themes")
			local vimgrep_arguments = { unpack(telescope_config.values.vimgrep_arguments) }

			table.insert(vimgrep_arguments, "--hidden")
			table.insert(vimgrep_arguments, "--glob")
			table.insert(vimgrep_arguments, "!**/.git/*")
			table.insert(vimgrep_arguments, "--trim")

			telescope.setup({
				defaults = {
					vimgrep_arguments = vimgrep_arguments,
					mappings = {
						i = {
							["<C-k>"] = actions.move_selection_previous,
							["<C-j>"] = actions.move_selection_next,
							["<C-q>"] = actions.send_selected_to_qflist + actions.open_qflist,
						},
					},
				},
				pickers = {
					find_files = {
						find_command = find_files_command,
						hidden = true,
					},
				},
				extensions = {
					["ui-select"] = {
						telescope_themes.get_dropdown({}),
					},
				},
			})

			pcall(telescope.load_extension, "fzf")
			pcall(telescope.load_extension, "ui-select")
		end,
	},
}
