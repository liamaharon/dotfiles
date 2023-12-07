return {
  -- disable annoying snippets
  {
    "rafamadriz/friendly-snippets",
    enabled = false,
  },

  {
    "hrsh7th/nvim-cmp",
    opts = {
      -- explicitly require opening complete window
      completion = {
        autocomplete = false,
      },
      -- make sure lsp suggestions are always first
      sources = require("cmp").config.sources({
        { name = "copilot" },
        { name = "nvim_lsp" },
        { name = "luasnip" },
        { name = "path" },
      }, {
        { name = "buffer" },
      }),
    },
  },
}
