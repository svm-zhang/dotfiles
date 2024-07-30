return {
  "nvim-tree/nvim-tree.lua",
  version = "*",
  lazy = false,
  dependencies = {
    "nvim-tree/nvim-web-devicons",
  },
  config = function()

    local function my_on_attach(bufnr)
      local api = require("nvim-tree.api")

      -- apparaently I need to define opts function
      -- otherwise, it complains about attempt global
      -- opts (a nil value) error
      local function opts(desc)
        return { desc = "nvim-tree: " .. desc, buffer = bufnr, noremap = true, silent = true, nowait = true }
      end

      local function edit_or_open()
        local node = api.tree.get_node_under_cursor()

        if node.nodes ~= nil then
          -- expand or collapse folder
          api.node.open.edit()
        else
          -- open file
          api.node.open.edit()
          -- Close the tree if file was opened
          api.tree.close()
        end
      end

      vim.keymap.set("n", "l", edit_or_open,          opts("Edit Or Open"))
      vim.keymap.set("n", "h", api.tree.collapse_all, opts("Collapse All"))
      vim.keymap.set("n", "t", api.tree.close,        opts("Close"))
    end

    require("nvim-tree").setup {
      disable_netrw = true,
      hijack_netrw = true,
      diagnostics = {
        enable = true,
        show_on_dirs = true,
      },
      vim.api.nvim_set_keymap("n", "<C-t>", ":NvimTreeToggle<CR>", {silent = true, noremap = true}),
      on_attach = my_on_attach,
    }
  end,
}
