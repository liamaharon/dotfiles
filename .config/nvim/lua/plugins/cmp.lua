return {
  -- disable annoying snippets
  {
    "rafamadriz/friendly-snippets",
    enabled = false,
  },

  {
    "hrsh7th/nvim-cmp",
    opts = function()
      local cmp = require("cmp")
      return {
        -- don't auto select items (expanding) in the completion menu
        completion = {
          completeopt = "menu,menuone,noselect",
        },
        -- override `select` to `false` to only confirm explicitly selected items
        mapping = {
          ["<CR>"] = cmp.mapping.confirm({ select = false }),
          ["<S-CR>"] = cmp.mapping.confirm({
            behavior = cmp.ConfirmBehavior.Replace,
            select = false,
          }),
        },
        -- override suggestion source ordering
        sources = require("cmp").config.sources({
          { name = "copilot" },
          { name = "nvim_lsp" },
          { name = "luasnip" },
          { name = "path" },
        }, {
          { name = "buffer" },
        }),
      }
    end,
  },
}
