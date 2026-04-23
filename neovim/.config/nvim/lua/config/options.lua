local opt = vim.opt

opt.cursorline = true
opt.number = true
opt.relativenumber = true

opt.tabstop = 2
opt.expandtab = true
opt.shiftwidth = 2
opt.softtabstop = 2
opt.smartindent = true
opt.autoindent = true

opt.wrap = false

vim.api.nvim_create_autocmd("FileType", {
	group = vim.api.nvim_create_augroup("prose_soft_wrap", { clear = true }),
	pattern = { "markdown", "rmd", "Rmd", "text", "gitcommit" },
	callback = function()
		vim.opt_local.wrap = true
		vim.opt_local.linebreak = true
		vim.opt_local.breakindent = true
		vim.opt_local.textwidth = 0
	end,
})

opt.ignorecase = true
opt.smartcase = true

opt.termguicolors = true
opt.background = "dark"
opt.signcolumn = "yes"

opt.splitbelow = true
opt.splitright = true

opt.grepprg = "rg --vimgrep"

opt.backspace = "indent,eol,start"

opt.foldcolumn = "0"
opt.foldlevel = 99
opt.foldlevelstart = 99
opt.foldenable = true

opt.spelllang = "en_us"
opt.spell = true

opt.conceallevel = 2

opt.clipboard:append("unnamedplus")

-- enable nvim transparent
vim.g.transparent_enabled = true
