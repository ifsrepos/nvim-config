return {
  "stevearc/conform.nvim",

  event = { "BufReadPost", "BufNewFile" },

  opts = {
    formatters_by_ft = {
      c = { "clang-format" },
      cpp = { "clang-format" },
      lua = {
        "stylua",
        args = {
          "--search-parent-directories",
          "--stdin-filepath",
          "$FILENAME",
          "-",
        },
      },
      python = { "ruff_format" },
    },
    format_on_save = {
      timeout = 500,
      lsp_format = "fallback",
    },
  },
}
