return {
  "nvim-treesitter/nvim-treesitter",

  build = ":TSUpdate",

  event = {
    "BufReadPost",
    "BufNewFile",
  },

  opts = {
    ensure_installed = {
      "c",
      "cpp",
      "lua",
      "python",
      "vim",
      "vimdoc",
      "query",
    },

    highlight = {
      enable = true,
    },

    indent = {
      enable = true,
    },
  },
}

