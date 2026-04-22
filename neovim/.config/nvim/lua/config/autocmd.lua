local api = vim.api
local augroup = vim.api.nvim_create_augroup

local yank = augroup("HighlightYank", { clear = true })

-- This highlights yanked text
-- Listen to TextYankPost event and execute vim.highlight.on_yank
vim.api.nvim_create_autocmd("TextYankPost", {
	desc = "Highlight yanked text",
	group = yank,
	callback = function()
		vim.highlight.on_yank()
	end,
})
