return {
  "nvim-telescope/telescope.nvim",

  dependencies = {
    "nvim-lua/plenary.nvim",
  },

  cmd = "Telescope",

  keys = {
    {
      "<C-p>",
      function()
        require("telescope.builtin").find_files()
      end,
      desc = "Find files",
    },
    {
      "<leader>fg",
      function()
        require("telescope.builtin").live_grep()
      end,
      desc = "Live grep",
    },
    {
      "<leader>fr",
      function()
        require("telescope.builtin").oldfiles()
      end,
      desc = "Find recent files",
    },
    {
      "<leader>fb",
      function()
        require("telescope.builtin").buffers()
      end,
      desc = "Find buffers",
    },
    {
      "<leader>fh",
      function()
        require("telescope.builtin").help_tags()
      end,
      desc = "Help tags",
    },
  },

  opts = {
    defaults = {
      layout_strategy = "horizontal",

      layout_config = {
        horizontal = {
          preview_width = 0.6,
        },
      },

      sorting_trategy = "ascending",

      prompt_prefix = "> ",
      selection_caret = "> ",

      path_display = { "smart" },

      file_ignore_patterns = {
        "%.git/",
      },
    },
  },
}

-- In-Telescope commands
-- Ctrl-v    Open in vertical split
-- Ctrl-x    Open in horizontal split
-- Ctrl-t    Open in new tab
-- Tab       Mark element
-- Shift-Tab Unmark
-- Shift-Tab Unmark
-- Alt-q     Send all results to Quickfix
