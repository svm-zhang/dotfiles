local M = {}

local float_theme = require("custom.float_theme")
float_theme.setup()

local state = {
	floating = {
		buf = -1,
		win = -1,
		restore_on_focus = false,
	},
}

local restore_timer = nil
local restore_check_pending = false
local create_float_terminal
local set_terminal_nav_keymaps
local open_float_terminal

local function tmux_socket()
	local tmux = vim.env.TMUX
	if not tmux or tmux == "" then
		return nil
	end

	return vim.split(tmux, ",", { plain = true })[1]
end

local function tmux_command(args)
	local cmd = { "tmux" }
	local socket = tmux_socket()
	if socket then
		vim.list_extend(cmd, { "-S", socket })
	end
	vim.list_extend(cmd, args)
	return cmd
end

local function stop_restore_timer()
	if restore_timer then
		restore_timer:stop()
		restore_timer:close()
		restore_timer = nil
	end
	restore_check_pending = false
end

open_float_terminal = function()
	local restore_on_focus = state.floating.restore_on_focus
	state.floating = create_float_terminal({ buf = state.floating.buf })
	state.floating.restore_on_focus = restore_on_focus

	if vim.bo[state.floating.buf].buftype ~= "terminal" then
		vim.cmd.terminal()
	end

	set_terminal_nav_keymaps(state.floating.buf)
	vim.cmd.startinsert()
end

local function restore_float_terminal()
	stop_restore_timer()
	state.floating.restore_on_focus = false

	if not vim.api.nvim_buf_is_valid(state.floating.buf) then
		return
	end

	if not vim.api.nvim_win_is_valid(state.floating.win) then
		open_float_terminal()
	end
end

local function start_restore_timer()
	if restore_timer then
		return
	end

	restore_timer = vim.uv.new_timer()
	restore_timer:start(
		200,
		200,
		vim.schedule_wrap(function()
			if not state.floating.restore_on_focus then
				stop_restore_timer()
				return
			end

			if restore_check_pending then
				return
			end

			restore_check_pending = true
			vim.system(
				tmux_command({
					"display-message",
					"-p",
					"-t",
					vim.env.TMUX_PANE,
					"#{pane_active}",
				}),
				{ text = true },
				vim.schedule_wrap(function(result)
					restore_check_pending = false
					if
						state.floating.restore_on_focus
						and result.code == 0
						and vim.trim(result.stdout or "") == "1"
					then
						restore_float_terminal()
					end
				end)
			)
		end)
	)
end

local function select_tmux_pane(direction)
	local flags = {
		h = "-L",
		j = "-D",
		k = "-U",
		l = "-R",
		p = "-l",
	}
	local flag = flags[direction]
	if not flag then
		return
	end

	if not vim.env.TMUX_PANE then
		vim.cmd("wincmd " .. direction)
		return
	end

	local result = vim.system(
		tmux_command({ "select-pane", "-t", vim.env.TMUX_PANE, flag })
	):wait()
	if result.code == 0 and vim.api.nvim_win_is_valid(state.floating.win) then
		state.floating.restore_on_focus = true
		vim.api.nvim_win_hide(state.floating.win)
		start_restore_timer()
	elseif result.code ~= 0 then
		state.floating.restore_on_focus = false
		stop_restore_timer()
		vim.notify(
			result.stderr or "tmux select-pane failed",
			vim.log.levels.WARN,
			{
				title = "tmux",
			}
		)
	end
end

set_terminal_nav_keymaps = function(buf)
	local nav = {
		["<C-h>"] = "h",
		["<C-j>"] = "j",
		["<C-k>"] = "k",
		["<C-l>"] = "l",
		["<C-\\>"] = "p",
	}

	for km, direction in pairs(nav) do
		vim.keymap.set("t", km, function()
			vim.cmd.stopinsert()
			select_tmux_pane(direction)
		end, { buffer = buf, silent = true, desc = "Navigate tmux pane" })
	end
end

create_float_terminal = function(opts)
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
	vim.wo[win].winhighlight = float_theme.float_winhighlight()
	return { buf = buf, win = win }
end

local back_to_floaty_from_tmux = vim.api.nvim_create_augroup(
	"BackToFloatTerminalFromTmux",
	{ clear = true }
)

vim.api.nvim_create_autocmd("FocusGained", {
	desc = "Move back from tmux to floating terminal",
	group = back_to_floaty_from_tmux,
	callback = function()
		if not state.floating.restore_on_focus then
			return
		end

		if not vim.api.nvim_buf_is_valid(state.floating.buf) then
			state.floating.restore_on_focus = false
			return
		end

		vim.schedule(function()
			if not state.floating.restore_on_focus then
				return
			end

			restore_float_terminal()
		end)
	end,
})

M.toggle_float_terminal = function()
	if not vim.api.nvim_win_is_valid(state.floating.win) then
		open_float_terminal()
	else
		state.floating.restore_on_focus = false
		stop_restore_timer()
		vim.api.nvim_win_hide(state.floating.win)
	end
end

return M
