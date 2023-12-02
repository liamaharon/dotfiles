-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here

-- Resizing panes
vim.keymap.set("n", "<C-n>", "5<C-w><", { desc = "Decrease window width", noremap = true, silent = true })
vim.keymap.set("n", "<C-m>", "5<C-w>>", { desc = "Increase window width", noremap = true, silent = true })

-- Crates package keymaps
local crates = require("crates")
local wk = require("which-key")
wk.register({
  c = {
    name = "crates",
  },
}, { prefix = "<leader>c" })
vim.keymap.set("n", "<leader>cc", "", { desc = "Crates", silent = true })
vim.keymap.set("n", "<leader>cct", crates.toggle, { desc = "Crates Toggle", silent = true })
vim.keymap.set("n", "<leader>ccr", crates.reload, { desc = "Crates Reload", silent = true })

vim.keymap.set("n", "<leader>ccv", crates.show_versions_popup, { desc = "Crates Show Versions Popup", silent = true })
vim.keymap.set("n", "<leader>ccf", crates.show_features_popup, { desc = "Crates Show Features Popup", silent = true })
vim.keymap.set(
  "n",
  "<leader>ccd",
  crates.show_dependencies_popup,
  { desc = "Crates Show Dependencies Popup", silent = true }
)
vim.keymap.set(
  "n",
  "<leader>cce",
  crates.expand_plain_crate_to_inline_table,
  { desc = "Crates Expand Plain Crate To Inline Table" }
)
vim.keymap.set(
  "n",
  "<leader>ccE",
  crates.extract_crate_into_table,
  { desc = "Crates Extract Crate Into Table", silent = true }
)
vim.keymap.set("n", "<leader>ccu", crates.update_crate, { desc = "Crates Update Crate", silent = true })
vim.keymap.set("v", "<leader>ccu", crates.update_crates, { desc = "Crates Update Crates", silent = true })
vim.keymap.set("n", "<leader>cca", crates.update_all_crates, { desc = "Crates Update All Crates", silent = true })
vim.keymap.set("n", "<leader>cch", crates.open_homepage, { desc = "Crates Open Homepage", silent = true })
vim.keymap.set("n", "<leader>ccr", crates.open_repository, { desc = "Crates Open Repository", silent = true })
vim.keymap.set("n", "<leader>ccd", crates.open_documentation, { desc = "Crates Open Documentation", silent = true })
vim.keymap.set("n", "<leader>ccc", crates.open_crates_io, { desc = "Crates Open crates.io", silent = true })
