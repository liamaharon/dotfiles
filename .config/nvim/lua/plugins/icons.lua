return {
  {
    "LazyVim/LazyVim",
    opts = {
      icons = {
        kinds = { Copilot = "C" },
        diagnostics = {
          Error = "E ",
          Warn = "W ",
          Hint = "H ",
          Info = "I ",
        },
        git = {
          added = "+ ",
          modified = "~ ",
          removed = "- ",
        },
      },
    },
  },
  {
    "lewis6991/gitsigns.nvim",
    event = "LazyFile",
    opts = function(_, opts)
      local icons = require("lazyvim.config").icons
      opts.signs = {
        add = { text = icons.git.added },
        change = { text = icons.git.modified },
        delete = { text = icons.git.removed },
        topdelete = { text = "‾" },
        changedelete = { text = "~" },
        untracked = { text = "┆" },
      }
    end,
  },
}
