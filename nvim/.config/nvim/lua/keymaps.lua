local map = vim.keymap.set

local opts = { noremap = true, silent = true }

-- At this point i think this is makes sense as you don't want to move in INSERT mode
-- map('n', '<left>', '<cmd>echo "Use h to move!!"<CR>')
-- map('n', '<right>', '<cmd>echo "Use l to move!!"<CR>')
-- map('n', '<up>', '<cmd>echo "Use k to move!!"<CR>')
-- map('n', '<down>', '<cmd>echo "Use j to move!!"<CR>')

-- Added useful keymaps
map('o', '<down>', ':echo "Yaay!!!"<CR>', opts)
map('o', '<up>', ':echo "Yaay!!!"<CR>', opts)
map('o', '<left>', ':echo "Yaay!!!"<CR>', opts)
map('o', '<right>', ':echo "Yaay!!!"<CR>', opts)
map('t', '<C-t>', '<C-\\><C-n>', opts)
map('n', 'vv', '^v$', opts)
map('n', 'q:', ':', opts)
map('n', '<C-z>', ':echo "Yaay!!!"<CR>', opts)
map('i', '<C-v>', '<C-r>+', opts)
map({ 'i', 'x', 'n', 's' }, '<C-s>', '<cmd>w<cr><esc>', opts)
map({ 'n', 'v' }, '<Space>', '<Nop>', opts)
map('n', '<PageDown>', '1000<C-D>0')
map('n', '<PageUp>', '1000<C-U>0')
map('i', '<PageDown>', '<C-O>1000<C-D>')
map('i', '<PageUp>', '<C-O>1000<C-U>')
map({ 'n', 'v' }, '<Space>', '<Nop>', opts)

-- Allow clipboard copy paste in neovim
vim.api.nvim_set_keymap('', '<D-v>', '+p<CR>', { noremap = true, silent = true })
vim.api.nvim_set_keymap('!', '<D-v>', '<C-R>+', { noremap = true, silent = true })
vim.api.nvim_set_keymap('t', '<D-v>', '<C-R>+', { noremap = true, silent = true })
vim.api.nvim_set_keymap('v', '<D-v>', '<C-R>+', { noremap = true, silent = true })

-- Buffers
map('n', '<S-h>', '<CMD>bprev<CR>', opts)
map('n', '<S-j>', '<Nop>', opts)
map('n', '<S-l>', '<CMD>bnext<CR>', opts)

-- Yank all
map('n', '<M-y>', 'ggVGy', opts)
-- Select all
map('n', '<M-a>', 'ggVG', opts)
-- Duplicate line
map('n', '<C-d>', 'YP', opts)

-- Clear search with <esc>
map({ 'i', 'n' }, '<esc>', '<cmd>noh<cr><esc>', opts)
