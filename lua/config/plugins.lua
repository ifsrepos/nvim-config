require("lazy").setup("plugins", {
  change_detection = {
    notify = false,
  },
  performance = {
    rtp = {
      paths = { "/usr/lib/nvim" },
    },
  },
})
