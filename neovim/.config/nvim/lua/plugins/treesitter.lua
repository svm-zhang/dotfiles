return {
  {
    "nvim-treesitter/nvim-treesitter",
    build = ":TSUpdate",
    config = function ()
      local configs = require("nvim-treesitter.configs")

      configs.setup({
          ensure_installed = {
            "lua",
            "vim",
            "javascript",
            "html",
            "python",
            "r",
            "rust",
            "bash",
            "csv",
            "diff",
            "markdown",
            "json",
            "toml",
            "xml",
            "yaml"
        },
          highlight = { enable = true },
          indent = { enable = true },
        })
      end,
    }
}
