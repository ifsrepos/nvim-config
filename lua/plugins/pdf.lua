-- Reads PDFs as plain text (pdftotext) in a read-only buffer, so the
-- content can be navigated, selected and yanked like any other text.
-- Requires poppler-utils (pdftotext).

return {
  "makerj/vim-pdf",

  -- Loaded before the file is read, so the plugin's BufReadPost
  -- autocommand is registered in time to convert the buffer
  event = "BufReadPre *.pdf",
}
