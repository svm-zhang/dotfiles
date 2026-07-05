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

local check_file_changed = augroup("CheckFileUpdate", { clear = true })

local function can_checktime(buf)
	-- skip running checktime on cmd window
	if vim.fn.getcmdwintype() ~= "" then
		return false
	end

	-- skip running checktime in stale or transitional buffers
	-- a buffer handle may be not valid, or may exist but not be loaded
	if
		not vim.api.nvim_buf_is_valid(buf)
		or not vim.api.nvim_buf_is_loaded(buf)
	then
		return false
	end

	-- skip running checktime in special buffers
	if vim.bo[buf].buftype ~= "" then
		return false
	end

	-- skip running checktime in unamed buffers
	if vim.api.nvim_buf_get_name(buf) == "" then
		return false
	end

	return true
end

vim.api.nvim_create_autocmd({
	"FocusGained",
	"BufEnter",
	"TermLeave",
	"TermClose",
}, {
	desc = "Check if files have been updated",
	group = check_file_changed,
	callback = function(args)
		if not can_checktime(args.buf) then
			return
		end

		vim.schedule(function()
			if can_checktime(args.buf) then
				pcall(vim.cmd.checktime, args.buf)
			end
		end)
	end,
})
