local M = {}

local function normal_buffer(buf)
	return vim.api.nvim_buf_is_valid(buf)
		and vim.api.nvim_buf_is_loaded(buf)
		and vim.bo[buf].buftype == ""
end

local function window_shows_buffer(win, buf)
	return vim.api.nvim_win_is_valid(win)
		and vim.api.nvim_win_get_buf(win) == buf
end

local function set_window_folds(win, method, expr)
	vim.wo[win][0].foldmethod = method
	vim.wo[win][0].foldexpr = expr or ""
	vim.wo[win][0].foldenable = true
end

local function recompute_folds(buf, win)
	vim.schedule(function()
		if not window_shows_buffer(win, buf) then
			return
		end

		vim.api.nvim_win_call(win, function()
			vim.wo[win][0].foldenable = true
			pcall(vim.cmd.normal, { "zX", bang = true })
		end)
	end)
end

function M.sync(buf, win)
	buf = buf or vim.api.nvim_get_current_buf()
	win = win or vim.api.nvim_get_current_win()

	if not normal_buffer(buf) or not window_shows_buffer(win, buf) then
		return
	end

	local provider = vim.b[buf].origami_folding_provider

	if provider == "lsp" then
		local clients = vim.lsp.get_clients({
			bufnr = buf,
			method = "textDocument/foldingRange",
		})
		if #clients == 0 then
			return
		end

		set_window_folds(win, "expr", "v:lua.vim.lsp.foldexpr()")
		recompute_folds(buf, win)
	elseif provider == "treesitter" then
		local ok, parser = pcall(vim.treesitter.get_parser, buf)
		local lang = ok and parser and parser:lang()
		local folds = lang and vim.treesitter.query.get(lang, "folds")
		if not folds then
			return
		end

		set_window_folds(win, "expr", "v:lua.vim.treesitter.foldexpr()")
		recompute_folds(buf, win)
	elseif type(provider) == "string" and provider ~= "" then
		set_window_folds(win, provider, "")
		recompute_folds(buf, win)
	end
end

return M
