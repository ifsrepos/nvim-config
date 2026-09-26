# nvim-config

Personal Neovim configuration, managed with [lazy.nvim](https://github.com/folke/lazy.nvim).

## Structure

```
.
├── init.lua              # Entry point, loads config and LSP modules
├── install.sh             # Installs system dependencies
├── lazy-lock.json          # Plugin version lockfile (lazy.nvim)
├── lazygit/
│   └── config.yml         # lazygit config (delta as diff pager)
└── lua/
    ├── config/
    │   ├── options.lua    # Neovim options
    │   ├── keymaps.lua    # Key mappings
    │   ├── autocmds.lua   # Autocommands
    │   ├── lazy.lua        # lazy.nvim bootstrap
    │   └── plugins.lua     # lazy.nvim setup, loads lua/plugins/*
    ├── lsp/
    │   ├── init.lua        # Enables and wires up LSP servers
    │   ├── clangd.lua      # clangd (C/C++) config
    │   └── pyright.lua     # Python LSP config
    ├── plugins/
    │   ├── blink.lua       # Completion (blink.cmp)
    │   ├── conform.lua     # Formatting
    │   ├── nord.lua        # Colorscheme
    │   ├── surround.lua    # Surround text objects
    │   ├── tabular.lua     # Text alignment
    │   ├── telescope.lua   # Fuzzy finder
    │   └── treesitter.lua  # Syntax highlighting/parsing
    └── utils/
        └── visual.lua      # Visual-selection helpers (used by telescope)
```

## Installation

1. Symlink this repo to `~/.config/nvim`.
2. Run the dependency installer:

   ```sh
   ./install.sh
   ```

   This installs system packages (clangd, clang-format, cmake, fd, git-delta),
   npm tools (pyright, tree-sitter-cli), and pip tools (ruff) required by the
   LSP and treesitter setup, and symlinks `lazygit/config.yml` into
   `~/.config/lazygit/config.yml`.

   Use `--check-only` to verify which tools are already installed without
   making any changes:

   ```sh
   ./install.sh --check-only
   ```

3. Launch `nvim` — lazy.nvim will bootstrap itself and install plugins on
   first run.

## Notes

- Supported platforms: Linux (Debian/Ubuntu) and Windows via WSL/MSYS2.
- `lazy-lock.json` pins plugin versions; commit changes to it when
  intentionally updating plugins.
