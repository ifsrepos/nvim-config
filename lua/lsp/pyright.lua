return {
  cmd = { "pyright-langserver", "--stdio" },

  filetypes = { "python" },

  root_markers = {
    "pyproject.toml",
    "setup.py",
    "setup.cfg",
    "pyrightconfig.json",
    ".git",
  },

  settings = {
    python = {
      analysis = {
        typeCheckingMode = "basic",
        autoSearchPaths = true,
        useLibraryCodeForTypes = true,
      },
    },
  },

  capabilities = require("blink.cmp").get_lsp_capabilities(),
}
