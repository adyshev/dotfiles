local map = vim.keymap.set

local opts = { noremap = true, silent = true }

map("t", "<C-t>", "<C-\\><C-n>", opts)
map("n", "vv", "^v$", opts)
map("n", "q:", ":", opts)
map("i", "<C-v>", "<C-r>+", opts)
map({ "i", "x", "n", "s" }, "<C-s>", "<cmd>w<cr><esc>", opts)
map({ "n", "v" }, "<Space>", "<Nop>", opts)
map("n", "<PageDown>", "1000<C-D>0")
map("n", "<PageUp>", "1000<C-U>0")
map("i", "<PageDown>", "<C-O>1000<C-D>")
map("i", "<PageUp>", "<C-O>1000<C-U>")
map("n", "<Home>", "gg^")
map("n", "<End>", "G$")
map("i", "<Home>", "<C-O>gg^", opts)
map("i", "<End>", "<C-O>G$")
map("n", "Q", "<cmd>qa<cr>")
map("n", "Y", "^y$")

-- Centralized
map("n", "n", "nzzzv", opts)
map("n", "N", "Nzzzv", opts)

-- Yank all
map("n", "<M-y>", "ggVGy", opts)
-- Select all
map("n", "<M-a>", "ggVG", opts)
-- Duplicate line
map("n", "<M-d>", "YP", opts)

-- Clear search with <esc>
map({ "i", "n" }, "<esc>", "<cmd>noh<cr><esc>", opts)
vim.keymap.set("t", "<Esc>", [[<C-\><C-n>]], { noremap = true })

-- Allow clipboard copy paste in neovim
vim.api.nvim_set_keymap("", "<D-v>", "+p<CR>", { noremap = true, silent = true })
vim.api.nvim_set_keymap("!", "<D-v>", "<C-R>+", { noremap = true, silent = true })
vim.api.nvim_set_keymap("t", "<D-v>", "<C-R>+", { noremap = true, silent = true })
vim.api.nvim_set_keymap("v", "<D-v>", "<C-R>+", { noremap = true, silent = true })
