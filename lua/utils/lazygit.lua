local M = {}

function M.open()
  local git_root = vim.fn.systemlist({
    "git",
    "-C",
    vim.fn.expand("%:p:h"),
    "rev-parse",
    "--show-toplevel",
  })[1]

  if not git_root or git_root == "" then
    vim.notify("No Git repository found", vim.log.levels.WARN)
    return
  end

  local function geometry()
    local width = math.floor(vim.o.columns * 0.9)
    local height = math.floor(vim.o.lines * 0.8)

    return {
      relative = "editor",
      width = width,
      height = height,
      row = math.floor((vim.o.lines - height) / 2),
      col = math.floor((vim.o.columns - width) / 2),
    }
  end

  local buf = vim.api.nvim_create_buf(false, true)

  local win = vim.api.nvim_open_win(buf, true, vim.tbl_extend("force", geometry(), {
    border = "rounded",
  }))

  local resize = vim.api.nvim_create_autocmd("VimResized", {
    callback = function()
      if vim.api.nvim_win_is_valid(win) then
        vim.api.nvim_win_set_config(win, geometry())
      end
    end,
  })

  vim.fn.termopen("lazygit", {
    cwd = git_root,
    on_exit = function()
      vim.schedule(function()
        pcall(vim.api.nvim_del_autocmd, resize)
        if vim.api.nvim_win_is_valid(win) then
          vim.api.nvim_win_close(win, true)
        end
      end)
    end,
  })

  vim.cmd("startinsert")
end

return M
