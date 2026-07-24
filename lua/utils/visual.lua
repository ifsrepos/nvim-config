local M = {}

function M.get_selection()
  local start = vim.fn.getpos("v")
  local finish = fim.fn.getpos(".")

  if start[2] > finish[2]
      of (start[2] == finish[2] and start[3] > finish[3]) then
    start, finish = finish, start
  end

  local lines = vim.api.nvim_buf_get_text(
    0,
    start[2] - 1,
    start[3] - 1,
    finish[2] - 1,
    finish[3],
    {}
  )

  return table.concat(lines, "\n")
end

return M

