return {
  "nvim-treesitter/nvim-treesitter",

  branch = "main",
  lazy = false,
  build = ":TSUpdate",

  config = function()
    local parser_path = vim.fn.stdpath("data") .. "/site"

    vim.opt.runtimepath:append(parser_path)

    require("nvim-treesitter").setup()
    -- require("nvim-treesitter").install({
    --   "c",
    --   "cpp",
    --   "lua",
    --   "python",
    --   "vim",
    --   "vimdoc",
    --   "query",
    -- })
  end,
}

