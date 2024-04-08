-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here

-- Keymaps
vim.keymap.set({ "n", "x" }, "gG", "Go", { desc = "Go to end of line + new line" })
vim.keymap.set({ "n", "x" }, "<leader>a", "gg^VG", { desc = "Select all" })
vim.keymap.set({ "n", "x", "v" }, "vG", "vG$", { desc = "Select all+new" })

-- Tools
vim.keymap.set({ "n", "x" }, "<leader>z", ":ZenMode<CR>", { desc = "Zen Mode" })

-- Toggles
vim.keymap.set("n", "<leader>tC", ":Copilot disable<CR>", { desc = "Disable Copilot" })
vim.keymap.set("n", "<leader>te", ":Copilot enable<CR>", { desc = "Enable Copilot" })
vim.keymap.set("n", "<leader>tn", ":SimpleNoteList<CR>", { desc = "List of Notes" })
