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

opt.ignorecase = true
opt.smartcase = true

opt.termguicolors = true
opt.background = "dark"
opt.signcolumn = "yes"

opt.splitbelow = true
opt.splitright = true

opt.grepprg = "rg --vimgrep"

opt.backspace = "indent,eol,start"

opt.foldcolumn = "1"
opt.foldlevel = 99
opt.foldlevelstart = 99
opt.foldenable = true

opt.spelllang = "en_us"
opt.spell = true

opt.conceallevel = 2

-- enable nvim transparent
vim.g.transparent_enabled = true
