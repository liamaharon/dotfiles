return {
  {
    "indent-blankline.nvim",
    opts = function()
      local highlight = {
        "Grey",
      }
      local hooks = require("ibl.hooks")
      hooks.register(hooks.type.HIGHLIGHT_SETUP, function()
        vim.api.nvim_set_hl(0, "Grey", { fg = "#3F3D50" })
      end)

      return {
        indent = { char = "▏", tab_char = "▏", highlight = highlight },
        whitespace = {
          remove_blankline_trail = false,
        },
        scope = { enabled = false },
      }
    end,
  },

  {
    "echasnovski/mini.indentscope",
    opts = {
      symbol = "▎",
      draw = {
        delay = 0,
        animation = require("mini.indentscope").gen_animation.none(),
      },
    },
  },
}
