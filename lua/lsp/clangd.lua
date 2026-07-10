local capabilities = require("blink.cmp").get_lsp_capabilities()

return {
  cmd = { "clangd" },

  filetypes = {
    "c",
    "cpp"
  },

  root_markers = {
    ".git",
    "compile_commands.json",
    "compile_flags.txt",
  },

  capabilities = capabilities,
}

