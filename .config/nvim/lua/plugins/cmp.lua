return {
  -- disable annoying snippets
  {
    "rafamadriz/friendly-snippets",
    enabled = false,
  },

  {
    "hrsh7th/nvim-cmp",
    opts = {
      -- don't auto select items (expanding) in the completion menu
      completion = {
        completeopt = "menu,menuone,noselect",
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
