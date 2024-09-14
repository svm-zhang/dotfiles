return {
	"epwalsh/obsidian.nvim",
	version = "*", -- recommended, use latest release instead of latest commit
	lazy = true,
	ft = "markdown",
	-- Replace the above line with this if you only want to load obsidian.nvim for markdown files in your vault:
	-- event = {
	--   -- If you want to use the home shortcut '~' here you need to call 'vim.fn.expand'.
	--   -- E.g. "BufReadPre " .. vim.fn.expand "~" .. "/my-vault/*.md"
	--   -- refer to `:h file-pattern` for more examples
	--   "BufReadPre path/to/my-vault/*.md",
	--   "BufNewFile path/to/my-vault/*.md",
	-- },
	dependencies = {
		"nvim-lua/plenary.nvim",
	},
	config = function()
		require("obsidian").setup({
			workspaces = {
				{
					name = "notes",
					path = "$HOME/work/notes",
				},
			},

			daily_notes = {
				folder = "daily",
				date_format = "%Y-%m-%d",
				alias_format = "%B %-d, %Y",
				default_tags = { "daily" },
				template = "daily.md",
			},

			mappings = {},

			note_id_func = function(title)
				local suffix = ""
				if title ~= nil then
					suffix = title:gsub("[^A-Za-z0-9]", ""):lower()
				end
				return suffix
			end,

			-- customized from default by not adding title to aliases
			note_frontmatter_func = function(note)
				local out =
					{ id = note.id, aliases = note.aliases, tags = note.tags }
				if
					note.metadata ~= nil and not vim.tbl_isempty(note.metadata)
				then
					for k, v in pairs(note.metadata) do
						out[k] = v
					end
				end
				return out
			end,

			templates = {
				folder = "templates",
				date_format = "%Y-%m-%d-%a",
				time_format = "%H:%M",
				tags = "",
				substitutions = {
					yesterday = function()
						return os.date("%Y-%m-%d", os.time() - 86400)
					end,
					tomorrow = function()
						return os.date("%Y-%m-%d", os.time() + 86400)
					end,
				},
			},
		})
	end,
}
