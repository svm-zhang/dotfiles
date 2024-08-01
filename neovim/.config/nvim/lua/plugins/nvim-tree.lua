return {
  "nvim-tree/nvim-tree.lua",
  version = "*",
  lazy = false,
  dependencies = "nvim-tree/nvim-web-devicons",
  config = function()
    local nvimtree = require("nvim-tree")

    vim.g.loaded_netrw = 1
    vim.g.loaded_netrwPlugin = 1

    nvimtree.setup({
      disable_netrw = true,
      hijack_netrw = true,
      view = {
        width = 35,
      },
      renderer = {
        indent_markers = {
          enable = true,
        },
        icons = {
          glyphs = {
            folder = {
              arrow_closed = "", -- arrow when folder is closed
              arrow_open = "", -- arrow when folder is open
            },
          },
        },
      },
      actions = {
        open_file = {
          window_picker = {
            enable = false,
          },
        },
      },
      filters = {
        custom = { ".DS_Store" },
      },
      git = {
        ignore = false,
      },
      diagnostics = {
        enable = true,
        show_on_dirs = true,
      },
    })

    local opts = { silent = true, noremap = true }
    local keymap = vim.keymap

    opts.desc = "Toggle file explorer"
    keymap.set("n", "<leader>ee", "<cmd>NvimTreeToggle<CR>", opts)

    opts.desc = "Toggle file explorer on current file"
    keymap.set("n", "<leader>ef", "<cmd>NvimTreeFindFileToggle<CR>", opts)

    opts.desc = "Collapse file explorer"
    keymap.set("n", "<leader>ec", "<cmd>NvimTreeCollapse<CR>", opts)

    opts.desc = "Refresh file explorer"
    keymap.set("n", "<leader>er", "<cmd>NvimTreeRefresh<CR>", opts)

  end,
}
