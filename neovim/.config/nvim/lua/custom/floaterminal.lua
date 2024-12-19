local M = {}

local state = {
	floating = {
		buf = -1,
		win = -1,
	},
}

local function create_float_terminal(opts)
	opts = opts or {}
	-- vim.o.columns and vim.o.lines returns # columns and lines in the current window
	local width = opts.width or math.floor(vim.o.columns * 0.8)
	local height = opts.height or math.floor(vim.o.lines * 0.8)

	-- make the floating window centered
	local col = math.floor((vim.o.columns - width) / 2)
	local row = math.floor((vim.o.lines - height) / 2)

	local buf = -1
	-- if buffer exists, use it; otherwise, create a new one
	if vim.api.nvim_buf_is_valid(opts.buf) then
		buf = opts.buf
	else
		buf = vim.api.nvim_create_buf(false, true)
	end

	local win_opts = {
		relative = "editor",
		row = row,
		col = col,
		width = width,
		height = height,
		border = "rounded",
		style = "minimal",
	}
	local win = vim.api.nvim_open_win(buf, true, win_opts)
	return { buf = buf, win = win }
end

M.toggle_float_terminal = function()
	-- create floating terminal if not exist
	if not vim.api.nvim_win_is_valid(state.floating.win) then
		-- return window and buffer handle
		state.floating = create_float_terminal({ buf = state.floating.buf })
		-- check if buffer is terminal buffer
		-- if not, create terminal buffer
		-- remember that state.floating.buf is the buffer handle returned
		if vim.bo[state.floating.buf].buftype ~= "terminal" then
			vim.cmd.terminal()
		end
		-- always start insert mode when toggle float terminal
		vim.cmd.startinsert()
	else
		-- hide floating terminal if it exists
		vim.api.nvim_win_hide(state.floating.win)
	end
end

return M
