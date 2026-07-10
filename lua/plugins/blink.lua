return {
  "Saghen/blink.cmp",

  version = "*",

  dependencies = {
    "rafamadriz/friendly-snippets",
  },

  opts = {
    keymap = {
      preset = "enter",
    },

    appearance = {
      nerd_font_variant = "mono",
    },

    completion = {
      documentation = {
        auto_show = true,
        auto_show_delay_ms = 300,
        window = {
          border = "rounded",
        }
      },

      menu = {
        border = "rounded",
      },
    },

    sources = {
      default = {
        "lsp",
        "path",
        "buffer",
      },
    },

    fuzzy = {
      implementation = "prefer_rust_with_warning",
    },
  },

  opts_extended = {
    "sources.default",
  },
}

