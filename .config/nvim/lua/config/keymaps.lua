-- Add any additional keymaps here

-- Keymaps
vim.keymap.set({ "n", "x" }, "gG", "Go", { desc = "Go to end of line + new line" })
vim.keymap.set({ "n", "x" }, "<leader>a", "gg^VG", { desc = "Select all" })
vim.keymap.set({ "n", "x", "v" }, "vG", "vG$", { desc = "Select all+new" })

-- Tools
vim.keymap.set({ "n", "x" }, "<leader>z", ":ZenMode<CR>", { desc = "Zen Mode" })
vim.keymap.set("n", "<leader>n", ":SimpleNoteList<CR>", { desc = "List of Notes" })
vim.keymap.set("n", "<leader>fs", "<cmd>Telescope symbols<cr>", { desc = "Find Symbols" })

-- Toggles

-- Inserts
vim.keymap.set("n", "<leader>id", "<cmd>r!date<cr>", { desc = "Insert date" })
vim.keymap.set("n", "<leader>iq", 'ciw""<Esc>P', { desc = "Insert word surround quotes" })
vim.keymap.set("n", "<leader>iQ", 'c$""<Esc>P', { desc = "Insert string surround quotes" })
vim.keymap.set("n", "<leader>ie", "<cmd>Encrypt<cr>", { desc = "Encrypt text" })
vim.keymap.set("n", "<leader>iE", "<cmd>Decrypt<cr>", { desc = "Decrypt text" })

-- these keep the cursor in the middle when scrolling with ctrl d and u
-- from https://github.com/ThePrimeagen/init.lua
vim.keymap.set("n", "<PageDown>", "<C-d>zz")
vim.keymap.set("n", "<PageUp>", "<C-u>zz")

-- Disable annoying command line thing
vim.keymap.set("n", "q:", ":")

local function escape(keys)
  return vim.api.nvim_replace_termcodes(keys, true, false, true)
end

-- vim.keymap.set("c", "<C-f>", function()
--   vim.g.requested_cmdwin = true
--   vim.api.nvim_feedkeys(escape("<C-f>"), "n", false)
-- end)

vim.api.nvim_create_autocmd("CmdWinEnter", {
  group = vim.api.nvim_create_augroup("CWE", { clear = true }),
  pattern = "*",
  callback = function()
    if vim.g.requested_cmdwin then
      vim.g.requested_cmdwin = nil
    else
      vim.api.nvim_feedkeys(escape(":q<CR>:"), "m", false)
    end
  end,
})
