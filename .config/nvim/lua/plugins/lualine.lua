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

      -- Completely customise sections.lualine_x
      local Util = require("lazyvim.util")
      local colors = {
        [""] = Util.ui.fg("Special"),
        ["Normal"] = Util.ui.fg("Special"),
        ["Warning"] = Util.ui.fg("DiagnosticError"),
        ["InProgress"] = Util.ui.fg("DiagnosticWarn"),
      }
      local icons = {
        [""] = "💤",
        ["Normal"] = "💤",
        ["Warning"] = "!",
        ["InProgress"] = "💭",
      }
      opts.sections.lualine_x = {
        {
          require("noice").api.statusline.mode.get,
          cond = require("noice").api.statusline.mode.has,
          color = { fg = "#ff9e64" },
        },
        {
          function()
            if not package.loaded["copilot"] then
              return "not loaded"
            end
            local status = require("copilot.api").status.data
            return icons[status.status] or icons["Warning"]
          end,
          cond = function()
            if not package.loaded["copilot"] then
              return
            end
            local ok, clients = pcall(require("lazyvim.util").lsp.get_clients, { name = "copilot", bufnr = 0 })
            if not ok then
              return false
            end
            return ok and #clients > 0
          end,
          color = function()
            if not package.loaded["copilot"] then
              return
            end
            local status = require("copilot.api").status.data
            return colors[status.status] or colors[""]
          end,
        },
        {
          "diff",
        },
      }
    end,
  },
}
