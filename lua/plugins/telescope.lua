local visual = require("utils.visual")

local function grep_visual()
  local text = visual.get_selection()

  text = text:gsub("\n", " ")

  require"(telescope.builtin").live_grep({
    default_text = text,
  })
end

return {
  "nvim-telescope/telescope.nvim",

  dependencies = {
    "nvim-lua/plenary.nvim",
  },

  cmd = "Telescope",

  keys = {
    {
      "<C-p>",
      require("telescope.builtin").find_files,
      desc = "Find files",
    },

    {
      "<leader>fg",
      require("telescope.builtin").live_grep,
      desc = "Live grep",
    },

    {
      "<leader>fg",
      grep_visual,
      mode = "x",
      desc = "Grep selection",
    },

    {
      "<leader>fr",
      require("telescope.builtin").oldfiles,
      desc = "Find recent files",
    },

    {
      "<leader>fb",
      require("telescope.builtin").buffers,
      desc = "Find buffers",
    },

    {
      "<leader>fh",
      require("telescope.builtin").help_tags,
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

      sorting_strategy = "ascending",

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
