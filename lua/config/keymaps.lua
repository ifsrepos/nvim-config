-- vim.keymap.set(mode, key, action, options)
-- modes:
--      n normal
--      i insert
--      v visual
--      x block visual
--      t terminal
--      c tommand line

vim.g.mapleader = " "

--------------------------------------------------------------------------------
-- General
--------------------------------------------------------------------------------

vim.keymap.set("n", "<Esc>", "<cmd>nohlsearch<CR>", {
  silent = true,
  desc = "Clear search highlight",
})

vim.keymap.set("n", "<leader>w", "<cmd>write<CR>", {
  desc = "Write file",
})

vim.keymap.set("n", "<leader>q", "<cmd>quit<CR>", {
  desc = "Quit",
})

vim.keymap.set("n", "<leader>x", "<cmd>x<CR>", {
  desc = "Write and quit",
})

vim.keymap.set("n", "<leader>e", "<cmd>Ex<CR>", {
  desc = "Open file explorer",
})

--------------------------------------------------------------------------------
-- Search & Navigation
--------------------------------------------------------------------------------

vim.keymap.set("n", "n", "nzzzv", {
  desc = "Next search result centered",
})

vim.keymap.set("n", "N", "Nzzzv", {
  desc = "Previous search result centered",
})

vim.keymap.set("n", "<C-d>", "<C-d>zz", {
  desc = "Half page down centered",
})

vim.keymap.set("n", "<C-u>", "<C-u>zz", {
  desc = "Half page up centered",
})

--------------------------------------------------------------------------------
-- Editing
--------------------------------------------------------------------------------

vim.keymap.set("n", "<A-k>", "<cmd>move .-2<CR>==", {
  desc = "Move line up",
})

vim.keymap.set("n", "<A-j>", "<cmd>move .+1<CR>==", {
  desc = "Move line down",
})

vim.keymap.set("v", "<", "<gv", {
  desc = "Indent left and keep selection",
})

vim.keymap.set("v", ">", ">gv", {
  desc = "Indent right and keep selection",
})

--------------------------------------------------------------------------------
-- Windows
--------------------------------------------------------------------------------

vim.keymap.set("n", "<leader>hs", "<cmd>split<CR>", {
  desc = "Horizontal split",
})

vim.keymap.set("n", "<leader>vs", "<cmd>vsplit<CR>", {
  desc = "Vertical split",
})

vim.keymap.set("n", "<C-h>", "<C-w>h", {
  desc = "Focus left window",
})

vim.keymap.set("n", "<C-j>", "<C-w>j", {
  desc = "Focus lower window",
})

vim.keymap.set("n", "<C-k>", "<C-w>k", {
  desc = "Focus upper window",
})

vim.keymap.set("n", "<C-l>", "<C-w>l", {
  desc = "Focus right window",
})

vim.keymap.set("n", "<C-Up>", "<cmd>resize +2<CR>", {
  desc = "Increase window height",
})

vim.keymap.set("n", "<C-Down>", "<cmd>resize -2<CR>", {
  desc = "Decrease window height",
})

vim.keymap.set("n", "<C-Left>", "<cmd>vertical resize -2<CR>", {
  desc = "Decrease window width",
})

vim.keymap.set("n", "<C-Right>", "<cmd>vertical resize +2<CR>", {
  desc = "Increase window width",
})
