vim.g.mapleader = " "
vim.g.maplocalleader = "\\"

local keymap = vim.keymap

-- increment/decrement numbers
keymap.set("n", "<leader>+", "<C-a>", { desc = "Increment number" })
keymap.set("n", "<leader>-", "<C-x>", { desc = "Decrement number" })

-- coding
-- coding formatter
keymap.set({ "n", "v" }, "<leader>cf", function()
	require("conform").format({
		lsp_fallback = true,
		async = false,
		timeout_ms = 500,
	})
end, { desc = "Format file" })
-- code action
vim.keymap.set(
	{ "n", "v" },
	"<leader>ca",
	vim.lsp.buf.code_action,
	{ desc = "See avaialable code actions" }
)
vim.keymap.set(
	"n",
	"<leader>cr",
	vim.lsp.buf.rename,
	{ desc = "Smart rename" }
)
-- comment
vim.keymap.set(
	"n",
	"<leader>cc",
	"<Plug>(comment_toggle_linewise_current)",
	{ desc = "Toggle comment on current line" }
)
vim.keymap.set(
	"n",
	"<leader>cg",
	"<Plug>(comment_toggle_linewise)",
	{ desc = "Toggle comment on a region with linewise comment" }
)
vim.keymap.set(
	"x",
	"<leader>cv",
	"<Plug>(comment_toggle_linewise_visual)",
	{ desc = "Toggle comment on selected lines with linewise comment" }
)
vim.keymap.set(
	"x",
	"<leader>cb",
	"<Plug>(comment_toggle_blockwise_visual)",
	{ desc = "Toggle comment on selected lines with blockwise comment" }
)
-- python venv select
vim.keymap.set(
	"n",
	"<leader>ce",
	"<cmd>:VenvSelect<CR>",
	{ desc = "Select python venv" }
)
-- lint code
vim.keymap.set("n", "<leader>cl", function()
	require("lint").try_lint()
end, { desc = "Trigger linting for current file" })
-- reboot LSP
vim.keymap.set(
	"n",
	"<leader>cR",
	"<cmd>LspRestart<CR>",
	{ silent = true, desc = "Restart LSP" }
)
vim.keymap.set(
	"x",
	"<leader>csc",
	"<cmd>CodeSnap<CR>",
	{ desc = "Save selected code snapshot into clipboard" }
)
vim.keymap.set(
	"x",
	"<leader>css",
	"<cmd>CodeSnapSave<CR>",
	{ desc = "Save selected code snapshot into clipboard" }
)
vim.keymap.set(
	"x",
	"<leader>csa",
	"<cmd>CodeSnapASCII<CR>",
	{ desc = "Save selected code snapshot into clipboard" }
)

-- find/files
vim.keymap.set(
	"n",
	"<leader>fe",
	"<cmd>Neotree toggle<CR>",
	{ desc = "Toggle neo-tree" }
)
vim.keymap.set(
	"n",
	"<leader>ff",
	"<cmd>Telescope find_files<CR>",
	{ desc = "Fuzzy find files in CWD" }
)
vim.keymap.set("n", "<leader>fr", function()
	require("telescope.builtin").oldfiles({
		only_cwd = true,
	})
end, { desc = "Fuzzy find recent files in CWD" })

-- edit using vim-pencil
vim.keymap.set(
	"n",
	"<leader>ep",
	"<cmd>Pencil<CR>",
	{ desc = "Toggle Pencil on" }
)
vim.keymap.set(
	"n",
	"<leader>eu",
	"<cmd>URLOpenUnderCursor<CR>",
	{ desc = "Open URL under the cursor" }
)

-- folding
vim.keymap.set("n", "zR", function()
	require("ufo").openAllFolds()
end, { desc = "Open all folds" })
vim.keymap.set("n", "zM", function()
	require("ufo").closeAllFolds()
end, { desc = "Close all folds" })
vim.keymap.set("n", "zK", function()
	local winid = require("ufo").peekFoldedLinesUnderCursor()
	if not winid then
		vim.lsp.buf.hover()
	end
end, { desc = "Peek Folds" })

-- diagnostics
vim.keymap.set(
	"n",
	"<leader>xw",
	"<cmd>Trouble diagnostics toggle filter.buf=0<CR>",
	{ desc = "Open trouble workspace diagnostics" }
)
vim.keymap.set(
	"n",
	"<leader>xq",
	"<cmd>Trouble quickfix toggle<CR>",
	{ desc = "Open trouble quickfix list" }
)
vim.keymap.set(
	"n",
	"<leader>xl",
	"<cmd>Trouble loclist toggle<CR>",
	{ desc = "Open trouble location list" }
)
vim.keymap.set(
	"n",
	"<leader>xt",
	"<cmd>Trouble todo toggle<CR>",
	{ desc = "Open todos in trouble" }
)

-- lsp
vim.keymap.set(
	"n",
	"<leader>xs",
	"<cmd>Trouble lsp_document_symbols toggle pinned=true win.relative=win win.size.width=50 win.position=right<CR>",
	{ desc = "Open trouble lsp document symbols" }
)
vim.keymap.set(
	"n",
	"<leader>xd",
	"<cmd>Trouble lsp_definitions toggle<CR>",
	{ desc = "Open trouble lsp definition" }
)
vim.keymap.set(
	"n",
	"<leader>xr",
	"<cmd>Trouble lsp_references toggle<CR>",
	{ desc = "Open trouble lsp references" }
)

-- markdown
-- markdown live preview
keymap.set(
	"n",
	"<leader>mp",
	"<cmd>MarkdownPreviewToggle<CR>",
	{ desc = "Toggle markdown live preview in web browser" }
)
keymap.set(
	"n",
	"<leader>mm",
	"<cmd>RenderMarkdown toggle<CR>",
	{ desc = "Toggle to render markdown" }
)

-- obsidian
vim.keymap.set("n", "<leader>oc", function()
	require("obsidian").util.toggle_checkbox()
end, { desc = "Toggle obsidian checkbox" })
vim.keymap.set(
	"n",
	"<leader>od",
	"<cmd>ObsidianToday<CR>",
	{ desc = "Create a today note" }
)
vim.keymap.set("n", "<leader>of", function()
	require("obsidian").util.gf_passthrough()
end, { desc = "Goto obsidian note within the vault" })
vim.keymap.set(
	"n",
	"<leader>ol",
	"<cmd>ObsidianLinks<CR>",
	{ desc = "Show obsidian links" }
)
vim.keymap.set(
	"n",
	"<leader>oL",
	"<cmd>ObsidianBackLinks<CR>",
	{ desc = "Show obsidian backlinks" }
)
vim.keymap.set(
	"n",
	"<leader>on",
	"<cmd>ObsidianNew<CR>",
	{ desc = "Create new obsidian note" }
)
vim.keymap.set(
	"n",
	"<leader>oN",
	"<cmd>ObsidianNewFromTemplate<CR>",
	{ desc = "Create new obsidian note from a template" }
)
vim.keymap.set(
	"n",
	"<leader>oo",
	"<cmd>ObsidianOpen<CR>",
	{ desc = "Create new obsidian note from a template" }
)
vim.keymap.set(
	"n",
	"<leader>oq",
	"<cmd>ObsidianQuickSwitch<CR>",
	{ desc = "Switch to another note in the vault" }
)
vim.keymap.set(
	"n",
	"<leader>os",
	"<cmd>ObsidianSearch<CR>",
	{ desc = "Search obsidian note in the vault" }
)
vim.keymap.set(
	"n",
	"<leader>ot",
	"<cmd>ObsidianTemplate<CR>",
	{ desc = "Insert obsidian template" }
)

-- preview LSP
vim.keymap.set(
	"n",
	"<leader>pp",
	"<cmd>lua require('goto-preview').goto_preview_definition()<CR>",
	{ desc = "Preview definition in float window" }
)
vim.keymap.set(
	"n",
	"<leader>pr",
	"<cmd>lua require('goto-preview').goto_preview_references()<CR>",
	{ desc = "Preview references in float window" }
)
vim.keymap.set(
	"n",
	"<leader>pd",
	"<cmd>lua require('goto-preview').close_all_win()<CR>",
	{ desc = "Close all floating preview window" }
)
keymap.set(
	"n",
	"<leader>pk",
	vim.lsp.buf.hover,
	{ silent = true, desc = "Show documentation for what is under cursor" }
)

-- quit
keymap.set("n", "<leader>qa", "<cmd>qa<CR>", { desc = "Quit all" })
keymap.set("n", "<leader>qq", "<cmd>q<CR>", { desc = "Quit one" })

-- search
vim.keymap.set(
	"n",
	"<leader>ss",
	"<cmd>Telescope live_grep<CR>",
	{ desc = "Find string in CWD" }
)
-- "<cmd>Telescope grep_string<CR>",
vim.keymap.set("n", "<leader>sw", function()
	require("telescope.builtin").grep_string({
		word_match = "-w",
	})
end, { desc = "Find string under cursor in CWD" })
vim.keymap.set(
	"n",
	"<leader>sc",
	"<cmd>Telescope command_history<CR>",
	{ desc = "Find command history" }
)
vim.keymap.set(
	"n",
	"<leader>sC",
	"<cmd>Telescope commands<CR>",
	{ desc = "Find commands" }
)
vim.keymap.set(
	"n",
	"<leader>sh",
	"<cmd>Telescope help_tags<CR>",
	{ desc = "Find help pages" }
)
vim.keymap.set(
	"n",
	"<leader>sm",
	"<cmd>Telescope man_pages<CR>",
	{ desc = "Find MAN pages" }
)
keymap.set(
	"n",
	"<leader>snh",
	":nohl<CR>",
	{ desc = "Clear search highlights" }
)

-- tab management
keymap.set("n", "<leader>tt", "<cmd>tabnew<CR>", { desc = "Open new tab" })
keymap.set(
	"n",
	"<leader>td",
	"<cmd>tabclose<CR>",
	{ desc = "Close current tab" }
)
keymap.set("n", "<leader>tj", "<cmd>tabp<CR>", { desc = "Go to previous tab" })
keymap.set("n", "<leader>tk", "<cmd>tabn<CR>", { desc = "Go to next tab" })
keymap.set(
	"n",
	"<leader>tf",
	"<cmd>tabfirst<CR>",
	{ desc = "Go to first tab" }
)
keymap.set("n", "<leader>tl", "<cmd>tablast<CR>", { desc = "Go to last tab" })

-- window management
keymap.set("n", "<leader>w", "<C-w>", { desc = "Windows" })
keymap.set("n", "<leader>wv", "<C-w>v", { desc = "Split window vertically" })
keymap.set("n", "<leader>wh", "<C-w>s", { desc = "Split window horizontally" })
keymap.set("n", "<leader>we", "<C-w>=", { desc = "Make splits equal size" })
keymap.set("n", "<leader>wd", "<C-w>q", { desc = "Close current split" })
keymap.set(
	"n",
	"<leader>wl",
	"<C-w>L",
	{ desc = "Move current window to the split window at right" }
)
keymap.set(
	"n",
	"<leader>wj",
	"<C-w>J",
	{ desc = "Move current window to the split window at bottom" }
)
keymap.set(
	"n",
	"<leader>wt",
	"<C-w>T",
	{ desc = "Open current window at new tab" }
)

vim.keymap.set("n", "<leader>b", function()
	require("snipe").open_buffer_menu()
end, { desc = "Open Snipe buffer menu" })

-- noice keymaps
vim.keymap.set(
	"n",
	"<leader>nn",
	"<cmd>Noice dismiss<CR>",
	{ noremap = true, desc = "Dismiss all messages" }
)
