return {
  {
    "nvim-lualine/lualine.nvim",
    event = "VeryLazy",
    opts = function(_, opts)
      -- Use full path
      table.remove(opts.sections.lualine_c, 4)
      table.insert(opts.sections.lualine_c, 4, { "filename", path = 1 })

      -- Remove file type
      table.remove(opts.sections.lualine_c, 3)

      -- Remove clock
      table.remove(opts.sections.lualine_z, 1)

      -- Cleaner ui
      opts.options = {
        icons_enabled = false,
        section_separators = "",
        component_separators = "",
      }
    end,
  },
}
