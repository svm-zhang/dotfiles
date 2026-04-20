return {
	-- autocompletion
	{
		"hrsh7th/nvim-cmp",
		dependencies = {
			"hrsh7th/cmp-nvim-lsp",
			"hrsh7th/cmp-buffer",
			"hrsh7th/cmp-path",
			"hrsh7th/cmp-cmdline",
			"L3MON4D3/LuaSnip",
			"saadparwaiz1/cmp_luasnip",
			"rafamadriz/friendly-snippets",
		},
		config = function()
			local cmp = require("cmp")

			local luasnip = require("luasnip")

			local kind_icons = {
				Text = "󰉿",
				Method = "󰆧",
				Function = "󰊕",
				Constructor = "",
				Field = "󰜢",
				Variable = "󰀫",
				Class = "󰠱",
				Interface = "",
				Module = "",
				Property = "󰜢",
				Unit = "󰑭",
				Value = "󰎠",
				Enum = "",
				Keyword = "󰌋",
				Snippet = "",
				Color = "󰏘",
				File = "󰈙",
				Reference = "󰈇",
				Folder = "󰉋",
				EnumMember = "",
				Constant = "󰏿",
				Struct = "󰙅",
				Event = "",
				Operator = "󰆕",
				TypeParameter = "",
			}

			local source_names = {
				nvim_lsp = "[LSP]",
				nvim_lsp_signature_help = "[Sig]",
				luasnip = "[LuaSnip]",
				buffer = "[Buffer]",
				path = "[Path]",
				crates = "[Crates]",
			}

			local fields = { "icon", "abbr", "kind", "menu" }

			local function lsp_client_name(entry)
				if entry.source.name ~= "nvim_lsp" then
					return nil
				end

				local debug_name = entry.source:get_debug_name()
				return debug_name:match("^nvim_lsp:(.+)$")
			end

			local function current_buffer_source(keyword_length)
				return {
					name = "buffer",
					keyword_length = keyword_length,
					option = {
						get_bufnrs = function()
							return { vim.api.nvim_get_current_buf() }
						end,
					},
				}
			end

			local function source_label(entry)
				-- Show LSP source when available
				local client_name = lsp_client_name(entry)
				if client_name then
					return "[" .. client_name .. "]"
				end
				return source_names[entry.source.name]
					or string.format("[%s]", entry.source.name)
			end

			local function format_completion_item(entry, vim_item)
				local kind = vim_item.kind

				vim_item.icon = kind_icons[kind] or ""
				vim_item.kind = kind
				vim_item.menu = source_label(entry)
				vim_item.icon_hl_group = "CmpItemKind" .. kind .. "Icon"
				vim_item.kind_hl_group = "CmpItemKind" .. kind

				return vim_item
			end

			local function format_cmdline_item(entry, vim_item)
				if entry.source.name == "cmdline" then
					vim_item.icon = ""
					vim_item.kind = "CMD"
					vim_item.menu = ""
					vim_item.icon_hl_group = "CmpItemKindKeywordIcon"
					vim_item.kind_hl_group = "CmpItemKindKeyword"
					return vim_item
				end

				return format_completion_item(entry, vim_item)
			end

			cmp.setup({
				-- set keybindings in autocompletion
				mapping = cmp.mapping.preset.insert({
					["<C-b>"] = cmp.mapping.scroll_docs(-4),
					["<C-f>"] = cmp.mapping.scroll_docs(4),
					["<C-space>"] = cmp.mapping.complete(), -- show completion suggestion
					["<C-k>"] = cmp.mapping.select_prev_item(), -- previous suggestion
					["<C-j>"] = cmp.mapping.select_next_item(), -- next suggestion
					["<C-e>"] = cmp.mapping.abort(), -- close completion window
					["<CR>"] = cmp.mapping.confirm({ select = true }),
				}),

				snippet = {
					expand = function(args)
						luasnip.lsp_expand(args.body)
					end,
				},

				window = {
					completion = cmp.config.window.bordered({
						border = "rounded",
						winhighlight = "Normal:Pmenu,FloatBorder:FloatBorder,CursorLine:Visual,Search:None",
						col_offset = -3,
						side_padding = 0,
					}),
					documentation = cmp.config.window.bordered({
						border = "rounded",
						max_width = 88,
						max_height = 20,
						winhighlight = "Normal:NormalFloat,FloatBorder:FloatBorder,Search:None",
					}),
				},

				formatting = {
					fields = fields,
					format = format_completion_item,
				},

				-- sources for autocompletion
				sources = cmp.config.sources({
					{ name = "nvim_lsp" },
					-- { name = 'vsnip' }, -- For vsnip users.
					{ name = "luasnip" }, -- For luasnip users.
					-- { name = 'ultisnips' }, -- For ultisnips users.
					-- { name = 'snippy' }, -- For snippy users.
					{ name = "path" },
					{ name = "crates" },
				}),
			})

			cmp.setup.filetype({ "markdown", "text", "gitcommit" }, {
				sources = cmp.config.sources({
					{ name = "nvim_lsp" },
					{ name = "luasnip" },
					{ name = "path" },
				}, {
					current_buffer_source(4),
				}),
			})

			-- Use buffer source for `/` and `?` (if you enabled `native_menu`, this won't work anymore).
			cmp.setup.cmdline({ "/", "?" }, {
				mapping = cmp.mapping.preset.cmdline(),
				sources = {
					current_buffer_source(3),
				},
			})

			-- Use cmdline & path source for ':' (if you enabled `native_menu`, this won't work anymore).
			cmp.setup.cmdline(":", {
				mapping = cmp.mapping.preset.cmdline(),
				formatting = {
					fields = fields,
					format = format_cmdline_item,
				},
				sources = cmp.config.sources({
					{ name = "path" },
				}, {
					{ name = "cmdline" },
				}),
			})

			require("luasnip.loaders.from_vscode").lazy_load()
		end,
	},

	-- surround brackets, quotes, pairs, etc
	{
		"kylechui/nvim-surround",
		event = { "BufReadPre", "BufNewFile" },
		version = "^4.0.0", -- Use for stability; omit to use `main` branch for the latest features
		config = true,
	},

	-- code folding
	{
		"kevinhwang91/nvim-ufo",
		dependencies = {
			"kevinhwang91/promise-async",
		},
		config = function()
			local ufo = require("ufo")

			ufo.setup({
				preview = {
					mappings = {
						scrollU = "<C-k>",
						scrollD = "<C-j>",
					},
				},
				-- explicitly set default value to avoid lua_ls complaints
				open_fold_hl_timeout = 400,
				close_fold_kinds_for_ft = {},
				enable_get_fold_virt_text = false,
				provider_selector = function()
					return { "lsp", "indent" }
				end,
			})
		end,
	},

	-- comment
	{
		"numToStr/Comment.nvim",
		event = { "BufReadPre", "BufNewFile" },
		config = true,
	},

	-- autopairs
	{
		"windwp/nvim-autopairs",
		event = "InsertEnter",
		dependencies = {
			"hrsh7th/nvim-cmp",
		},
		config = function()
			local autopairs = require("nvim-autopairs")

			autopairs.setup({
				enable_check_bracket_line = false,
				check_ts = true, -- enable treesitter
				ts_config = {
					lua = { "string" },
					javascript = { "template_string" },
				},
				-- Add fastwrap rule, triggered with Alt+e
				fast_wrap = {
					map = "<A-e>",
					cursor_pos_before = false,
				},
			})

			-- If you want insert `(` after select function or method item
			local cmp_autopairs = require("nvim-autopairs.completion.cmp")
			local cmp = require("cmp")
			cmp.event:on("confirm_done", cmp_autopairs.on_confirm_done())
		end,
	},

	{
		"mistricky/codesnap.nvim",
		build = "make build_generator",
		config = function()
			local codesnap = require("codesnap")

			codesnap.setup({
				mac_window_bar = false,
				code_font_family = "IosevkaTerm Nerd Font",
				watermark = "",
				bg_theme = "grape",
				has_breadcrumbs = false,
				has_line_number = false,
				show_workspace = false,
				save_path = os.getenv("HOME") .. "/Pictures",
			})
		end,
	},
}
