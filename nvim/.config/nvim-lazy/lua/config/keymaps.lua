-- Add any additional keymaps here

-- Tools
vim.keymap.set("n", "<leader>z", ":ZenMode<CR>", { desc = "Zen Mode" })
vim.keymap.set("n", "<leader>a", "gg^VG", { desc = "Select all" })

vim.keymap.set("n", "<leader>fn", ":SimpleNoteList<CR>", { desc = "Find Notes" })
vim.keymap.set("n", "<leader>fs", "<cmd>Telescope symbols<cr>", { desc = "Find Symbols" })
vim.keymap.set("n", "<leader>fP", ":ProjectRoot<CR>", { desc = "Set Project Root" })

vim.keymap.set("n", "<leader>mo", MiniMap.open, { desc = "Open Minimap" })
vim.keymap.set("n", "<leader>mc", MiniMap.close, { desc = "Close Minimap" })
vim.keymap.set("n", "<leader>mf", MiniMap.toggle_focus, { desc = "Focus Minimap" })

-- Inserts
vim.keymap.set("n", "<leader>id", "<cmd>r!date<cr>", { desc = "Insert date" })
vim.keymap.set("n", "<leader>iq", 'ciw""<Esc>P', { desc = "Insert word surround quotes" })
vim.keymap.set("n", "<leader>iQ", 'c$""<Esc>P', { desc = "Insert string surround quotes" })
vim.keymap.set("n", "<leader>ie", "<cmd>Encrypt<cr>", { desc = "Encrypt text" })
vim.keymap.set("n", "<leader>iE", "<cmd>Decrypt<cr>", { desc = "Decrypt text" })

-- Yanks
vim.keymap.set("n", "<leader>ya", "gg^VGy", { desc = "Copy all" })

-- these keep the cursor in the middle when scrolling with ctrl d and u
-- from https://github.com/ThePrimeagen/init.lua
vim.keymap.set("n", "<PageDown>", "<C-d>zz")
vim.keymap.set("n", "<PageUp>", "<C-u>zz")

-- Disable annoying command line thing
vim.keymap.set("n", "q:", ":")
vim.keymap.set("n", ";", ":")

-- If you want to keep defaut command history, please uncomment
-- vim.keymap.set("c", "<C-f>", function()
--   vim.g.requested_cmdwin = true
--   vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("<C-f>",true, false, true), "n", false)
-- end)
