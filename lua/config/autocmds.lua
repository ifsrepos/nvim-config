-- vim.api.nvim_create_autocmd("event", { callback = function() ... end, ... })

-- BufEnter      Entering a buffer
-- BufWritePre   Just before saving
-- BufWritePost  Just after saving
-- InsertEnter   Entering insert mode
-- InsertLeave   Exit insert mode
-- TextYankPost  Copy text
-- Vim enter     Neovim has just start

local user_autocmds = vim.api.nvim_create_augroup("UserAutocmds", {
  clear = true,
})

vim.api.nvim_create_autocmd("TextYankPost", {
  desc = "Highlights copied text",
  group = user_autocmds,
  callback = function()
    vim.hl.on_yank()
  end,
})

vim.api.nvim_create_autocmd("BufWritePre", {
  desc = "Remove spaces at the end of the lines",
  group = user_autocmds,
  pattern = "*",
  command = [[%s/\s\+$//e]],
})

vim.api.nvim_create_autocmd("FileType", {
  desc = "Uses tabs to edit Makefiles",
  group = user_autocmds,
  pattern = "make",
  callback = function()
    vim.opt_local.expandtab = false
    vim.opt_local.tabstop = 4
    vim.opt_local.shiftwidth = 4
    vim.opt_local.softtabstop = 4
  end,
})

vim.api.nvim_create_autocmd("FileType", {
  desc = "Uses 4 spaces indent to edit python files",
  group = user_autocmds,
  pattern = "python",
  callback = function(event)
    vim.opt_local.expandtab = true
    vim.opt_local.tabstop = 4
    vim.opt_local.softtabstop = 4
    vim.opt_local.shiftwidth = 4
  end,
})

local lsp_group = vim.api.nvim_create_augroup("lsp", {
  clear = true,
})

vim.api.nvim_create_autocmd("LspAttach", {
  group = lsp_group,
  callback = function(event)
    local map = function(mode, lhs, rhs, desc)
      vim.keymap.set(mode, lhs, rhs, {
        buffer = event.buf,
        desc = desc,
      })
    end

    map("n", "gd", vim.lsp.buf.definition, "Go to definition")
    map("n", "gD", vim.lsp.buf.declaration, "Go to declaration")
    map("n", "gi", vim.lsp.buf.implementation, "Go to implementation")
    map("n", "gr", vim.lsp.buf.references, "List references")

    map("n", "K", vim.lsp.buf.hover, "Hover documentation")
    map("n", "<leader>k", vim.lsp.buf.signature_help, "Signature help")

    map("n", "<leader>rn", vim.lsp.buf.rename, "Rename symbol")
    map("n", "<leader>ca", vim.lsp.buf.code_action, "Code actions")

    map("n", "<leader>d", vim.diagnostic.open_float,
        "Show diagnostics")

    map("n", "[d",
      function()
        vim.diagnostic.jump({ count = -1, float = true })
      end, "Previous diagnostic")

    map("n", "]d",
      function()
        vim.diagnostic.jump({ count = 1, float = true })
      end, "Next diagnostic")
  end
})

local treesitter_group = vim.api.nvim_create_augroup("Treesitter", {
  clear = true,
})

-- Languages already reported, to warn only once per session
local treesitter_warned = {}

local function treesitter_warn(lang, message)
  if treesitter_warned[lang] then
    return
  end

  treesitter_warned[lang] = true
  vim.notify(("treesitter (%s): %s"):format(lang, message),
    vim.log.levels.WARN)
end

vim.api.nvim_create_autocmd("FileType", {
  desc = "Enables treesitter highlighting when the parser is installed",
  group = treesitter_group,
  callback = function(event)
    local lang = vim.treesitter.language.get_lang(
      vim.bo[event.buf].filetype)

    -- Filetypes without parser are left to the syntax highlighting
    if not lang or not vim.treesitter.language.add(lang) then
      return
    end

    local ok, err = pcall(vim.treesitter.start, event.buf, lang)

    if not ok then
      treesitter_warn(lang, err)
    elseif not vim.treesitter.query.get(lang, "highlights") then
      treesitter_warn(lang, "no highlights query, run :TSUpdate " .. lang)
    end
  end
})

