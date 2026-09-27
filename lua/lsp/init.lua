vim.lsp.config("clangd", require("lsp.clangd"))
vim.lsp.enable("clangd")

vim.lsp.config("pyright", require("lsp.pyright"))
vim.lsp.enable("pyright")

vim.lsp.config("bashls", require("lsp.bashls"))
vim.lsp.enable("bashls")
