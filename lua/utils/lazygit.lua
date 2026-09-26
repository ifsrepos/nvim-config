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

  local width = math.floor(vim.o.columns * 0.9)
  local height = math.floor(vim.o.lines * 0.8)

  local row = math.floor((vim.o.lines - height) / 2)
  local col = math.floor((vim.o.columns - width) / 2)

  local buf = vim.api.nvim_create_buf(false, true)

  local win = vim.api.nvim_open_win(buf, true, {
    relative = "editor",
    width = width,
    height = height,
    row = row,
    col = col,
    border = "rounded",
  })

  vim.fn.termopen("lazygit", {
    cwd = git_root,
    on_exit = function()
      vim.schedule(function()
        if vim.api.nvim_win_is_valid(win) then
          vim.api.nvim_win_close(win, true)
        end
      end)
    end,
  })

  vim.cmd("startinsert")
end

return M
