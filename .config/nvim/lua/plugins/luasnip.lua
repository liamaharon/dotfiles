return {
  {
    "L3MON4D3/LuaSnip",
    -- override lazyvim default which is to use <tab> for snippet navigation in insert mode
    -- stylua: ignore
    keys = {
      {
        "<c-j>",
        function()
          return require("luasnip").jumpable(1) and "<Plug>luasnip-jump-next" or "<c-j>"
        end,
        expr = true, silent = true, mode = "i",
      },
      { "<c-j>", function() require("luasnip").jump(1) end, mode = "s" },
      { "<c-k>", function() require("luasnip").jump(-1) end, mode = { "i", "s" } },
    },
  },
}
