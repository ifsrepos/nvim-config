-- Live preview of Markdown in the browser, including Mermaid diagrams
-- (the terminal cannot draw them, so render-markdown only shows the source).
-- Requires node/npm to build the plugin's server.
-- Usage: :MarkdownPreview / :MarkdownPreviewStop / :MarkdownPreviewToggle

return {
  "iamcco/markdown-preview.nvim",
  ft = { "markdown" },
  cmd = { "MarkdownPreview", "MarkdownPreviewStop", "MarkdownPreviewToggle" },
  build = "cd app && npm install",
  init = function()
    vim.g.mkdp_auto_close = 0
    vim.g.mkdp_echo_preview_url = 1

    -- WSL has no wslview, so xdg-open cannot reach the Windows browser:
    -- hand the URL to explorer.exe instead (localhost is forwarded to WSL)
    if vim.fn.executable("explorer.exe") == 1 then
      vim.cmd([[
        function! MkdpOpenInWindows(url)
          call jobstart(['explorer.exe', a:url])
        endfunction
      ]])
      vim.g.mkdp_browserfunc = "MkdpOpenInWindows"
    end
  end,
}
