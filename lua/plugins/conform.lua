return {
  "stevearc/conform.nvim",

  event = { "BufWritePre", "BufReadPost", "BufNewFile" },

  opts = {
    formatters_by_ft = {
      c = { "clang-format" },
      cpp = { "clang-format" },
    },
    format_on_save = {
      timeout = 500,
      lsp_format = "fallback",
    },
  },
}

