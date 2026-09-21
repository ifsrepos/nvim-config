return {
  "nvim-treesitter/nvim-treesitter",

  branch = "master",
  main = "nvim-treesitter.configs",

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

