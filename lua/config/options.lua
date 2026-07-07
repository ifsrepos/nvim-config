-- Appearence
vim.opt.number = true             -- Show line numbers
vim.opt.relativenumber = true     -- Show relative numbers to cursor
vim.opt.cursorline = true         -- Highlights cursor line
vim.opt.signcolumn = "yes"        -- Reserve a space for warning, errors, git changes, etc.
vim.opt.scrolloff = 8             -- Keeps 8 lines around cursor when scrolling
vim.opt.colorcolumn = "80"        -- Line max width set to 80 characters

-- Edition
vim.opt.expandtab = true          -- Use spaces instead of tabs
vim.opt.tabstop = 2               -- How tabs are displayed
vim.opt.softtabstop = 2           -- How many "spaces" writes <Tab>
vim.opt.shiftwidth = 2            -- Indent size
vim.opt.smartindent = true        -- Smart indent
vim.opt.undofile = true           -- Keeps undo after Neovim close
vim.opt.clipboard = "unnamedplus" -- Use system clipboard

-- Search
vim.opt.incsearch = true          -- Enables incremental search
vim.opt.hlsearch = true           -- Highlights search results
vim.opt.ignorecase = true         -- Enables ignore case when searching
vim.opt.smartcase = true          -- Disables ignore case when upper letters are set

-- Windows
vim.opt.splitright = true         -- On vertical splits, open new window to the right
vim.opt.splitbelow = true         -- On horizontal splits, open new window below
vim.opt.equalalways = true        -- Splits are always the same size

-- Performance
vim.opt.updatetime = 250          -- Sets neovim waiting time when keys are not being pressed before launch some events

