return {
  "nvim-treesitter/nvim-treesitter",
  branch = "main",

  build = ":TSUpdate",

  event = {
    "BufReadPost",
    "BufNewFile",
  },

  opts = {
    ensure_installed = {
      "c",
      "lua",
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

