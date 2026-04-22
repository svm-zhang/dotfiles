local M = {}

local float_theme = require("custom.float_theme")
local patched = false

local function apply_winhighlight(win)
	if win and vim.api.nvim_win_is_valid(win) then
		vim.wo[win].winhighlight = float_theme.float_winhighlight()
	end
end

function M.setup()
	if patched then
		return
	end
	patched = true

	float_theme.setup()

	local original_open_floating_preview = vim.lsp.util.open_floating_preview

	vim.lsp.util.open_floating_preview = function(contents, syntax, opts)
		opts = opts or {}
		opts.border = opts.border or "rounded"

		local bufnr, win =
			original_open_floating_preview(contents, syntax, opts)
		apply_winhighlight(win)

		return bufnr, win
	end
end

return M
