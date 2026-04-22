local M = {}

local configured = false

local float_winhighlight =
	"Normal:FloatThemeNormal,NormalNC:FloatThemeNormal,EndOfBuffer:FloatThemeNormal,FloatBorder:FloatThemeBorder"
local menu_winhighlight =
	"Normal:FloatThemeMenu,FloatBorder:FloatThemeMenuBorder,CursorLine:FloatThemeMenuSel,Search:None"
local doc_winhighlight =
	"Normal:FloatThemeDoc,FloatBorder:FloatThemeDocBorder,Search:None"

local function hl(name)
	return vim.api.nvim_get_hl(0, { name = name, link = false })
end

local function set_hl(name, value)
	vim.api.nvim_set_hl(0, name, value)
end

function M.sync()
	local normal = hl("Normal")
	local pmenu = hl("Pmenu")
	local pmenu_sel = hl("PmenuSel")
	local visual = hl("Visual")
	local border = hl("FloatBorder")

	local float_fg = normal.fg
	local float_bg = normal.bg
	local menu_fg = pmenu.fg or float_fg
	local sel_fg = pmenu_sel.fg or visual.fg
	local sel_bg = pmenu_sel.bg or visual.bg
	local border_fg = border.fg or menu_fg or float_fg

	set_hl("FloatThemeNormal", {
		fg = float_fg,
		bg = float_bg,
	})
	set_hl("FloatThemeBorder", {
		fg = border_fg,
		bg = float_bg,
	})
	set_hl("FloatThemeMenu", {
		fg = menu_fg,
		bg = float_bg,
	})
	set_hl("FloatThemeMenuBorder", {
		fg = border_fg,
		bg = float_bg,
	})
	set_hl("FloatThemeMenuSel", {
		fg = sel_fg,
		bg = sel_bg,
		bold = pmenu_sel.bold or visual.bold,
	})
	set_hl("FloatThemeDoc", {
		fg = menu_fg,
		bg = float_bg,
	})
	set_hl("FloatThemeDocBorder", {
		fg = border_fg,
		bg = float_bg,
	})

	set_hl("TelescopeNormal", { fg = float_fg, bg = float_bg })
	set_hl("TelescopeBorder", { fg = border_fg, bg = float_bg })
	set_hl("TelescopePromptNormal", { fg = float_fg, bg = float_bg })
	set_hl("TelescopePromptBorder", { fg = border_fg, bg = float_bg })
	set_hl("TelescopeResultsNormal", { fg = float_fg, bg = float_bg })
	set_hl("TelescopeResultsBorder", { fg = border_fg, bg = float_bg })
	set_hl("TelescopePreviewNormal", { fg = float_fg, bg = float_bg })
	set_hl("TelescopePreviewBorder", { fg = border_fg, bg = float_bg })
	set_hl("TelescopeTitle", { fg = border_fg, bg = float_bg, bold = true })
	set_hl("TelescopePromptTitle", {
		fg = border_fg,
		bg = float_bg,
		bold = true,
	})
	set_hl("TelescopeResultsTitle", {
		fg = border_fg,
		bg = float_bg,
		bold = true,
	})
	set_hl("TelescopePreviewTitle", {
		fg = border_fg,
		bg = float_bg,
		bold = true,
	})
	set_hl("TelescopeSelection", {
		fg = sel_fg,
		bg = sel_bg,
		bold = pmenu_sel.bold or visual.bold,
	})

	set_hl("TroubleNormal", { fg = float_fg, bg = float_bg })
	set_hl("TroubleNormalNC", { fg = float_fg, bg = float_bg })
	set_hl("TroublePreview", {
		fg = sel_fg,
		bg = sel_bg,
		bold = pmenu_sel.bold or visual.bold,
	})
end

function M.float_winhighlight()
	return float_winhighlight
end

function M.menu_winhighlight()
	return menu_winhighlight
end

function M.doc_winhighlight()
	return doc_winhighlight
end

function M.setup()
	if configured then
		M.sync()
		return
	end
	configured = true

	M.sync()

	vim.api.nvim_create_autocmd("ColorScheme", {
		group = vim.api.nvim_create_augroup("custom_float_theme", {
			clear = true,
		}),
		callback = M.sync,
	})
end

return M
