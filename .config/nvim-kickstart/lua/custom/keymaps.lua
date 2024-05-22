local map = vim.keymap.set

-- Added useful keymaps
map('n', 'vA', 'gg^VG', { desc = 'All' })
map('n', 'yA', 'gg^VGy', { desc = 'All' })
map('n', '<PageDown>', '<C-d>zz')
map('n', '<PageUp>', '<C-u>zz')
map('n', 'q:', ':')
map('n', ';', ':')
map('n', '<C-z>', ':echo "Yaay!!!"<CR>')
map('n', '<C-d>', 'yyP')
map('i', '<C-d>', '<C-O>yy<C-O>P')

-- Buffers
vim.keymap.set('n', '<S-h>', '<CMD>bprev<CR>', { desc = 'Prev buffer' })
vim.keymap.set('n', '<S-l>', '<CMD>bnext<CR>', { desc = 'Next buffer' })

-- Resize window using <ctrl> arrow keys
map('n', '<C-Up>', '<cmd>resize +2<cr>', { desc = 'Increase Window Height' })
map('n', '<C-Down>', '<cmd>resize -2<cr>', { desc = 'Decrease Window Height' })
map('n', '<C-Left>', '<cmd>vertical resize -2<cr>', { desc = 'Decrease Window Width' })
map('n', '<C-Right>', '<cmd>vertical resize +2<cr>', { desc = 'Increase Window Width' })

-- Move Lines
map('n', '<M-j>', '<cmd>m .+1<cr>==', { desc = 'Move Down' })
map('n', '<M-k>', '<cmd>m .-2<cr>==', { desc = 'Move Up' })
map('i', '<M-j>', '<esc><cmd>m .+1<cr>==gi', { desc = 'Move Down' })
map('i', '<M-k>', '<esc><cmd>m .-2<cr>==gi', { desc = 'Move Up' })
map('v', '<M-j>', ":m '>+1<cr>gv=gv", { desc = 'Move Down' })
map('v', '<M-k>', ":m '<-2<cr>gv=gv", { desc = 'Move Up' })

-- windows
map('n', '<leader>-', '<C-W>s', { desc = '[-]Split Window Horizontally', remap = true })
map('n', '<leader>|', '<C-W>v', { desc = '[|]Split Window Vertically', remap = true })

-- better indenting
map('v', '<', '<gv')
map('v', '>', '>gv')

-- https://github.com/mhinz/vim-galore#saner-behavior-of-n-and-n
map('n', 'n', "'Nn'[v:searchforward].'zv'", { expr = true, desc = 'Next Search Result' })
map('x', 'n', "'Nn'[v:searchforward]", { expr = true, desc = 'Next Search Result' })
map('o', 'n', "'Nn'[v:searchforward]", { expr = true, desc = 'Next Search Result' })
map('n', 'N', "'nN'[v:searchforward].'zv'", { expr = true, desc = 'Prev Search Result' })
map('x', 'N', "'nN'[v:searchforward]", { expr = true, desc = 'Prev Search Result' })
map('o', 'N', "'nN'[v:searchforward]", { expr = true, desc = 'Prev Search Result' })

-- Clear search with <esc>
map({ 'i', 'n' }, '<esc>', '<cmd>noh<cr><esc>', { desc = 'Escape and Clear hlsearch' })
