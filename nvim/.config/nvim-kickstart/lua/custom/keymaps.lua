local map = vim.keymap.set

local opts = { noremap = true, silent = true }
local opts_expr = { noremap = true, expr = true, silent = true }

-- Not sure
-- map('i', 'jj', '<Esc>', opts)
-- map('n', ';', ':', opts)

-- At this point i think this is makes sense as you don't want to move in INSERT mode
-- map('n', '<left>', '<cmd>echo "Use h to move!!"<CR>')
-- map('n', '<right>', '<cmd>echo "Use l to move!!"<CR>')
-- map('n', '<up>', '<cmd>echo "Use k to move!!"<CR>')
-- map('n', '<down>', '<cmd>echo "Use j to move!!"<CR>')

-- Added useful keymaps
map('o', '<down>', ':echo "Yaay!!!"<CR>')
map('o', '<up>', ':echo "Yaay!!!"<CR>')
map('t', '<C-t>', '<C-\\><C-n>', opts)
map('n', 'vA', 'gg^VG')
map('n', 'vv', '^v$')
map('n', 'yA', 'gg^VGy', opts)
map('n', 'q:', ':', opts)
map('n', '<C-z>', ':echo "Yaay!!!"<CR>', opts)
map('n', '<C-d>', 'yyP', opts)
map('i', '<C-v>', '<C-r>+', opts)
map({ 'i', 'x', 'n', 's' }, '<C-s>', '<cmd>w<cr><esc>', opts)
map({ 'n', 'v' }, '<Space>', '<Nop>', opts)
map('n', '<PageDown>', '1000<C-D>0')
map('n', '<PageUp>', '1000<C-U>0')
map('i', '<PageDown>', '<C-O>1000<C-D>')
map('i', '<PageUp>', '<C-O>1000<C-U>')

-- Buffers
map('n', '<S-h>', '<CMD>bprev<CR>', opts)
map('n', '<S-l>', '<CMD>bnext<CR>', opts)
map('n', '<S-j>', ':echo "Yaay!!!"<CR>', opts)

-- Move Lines
map('n', '<M-j>', '<cmd>m .+1<cr>==', opts)
map('n', '<M-k>', '<cmd>m .-2<cr>==', opts)
map('i', '<M-j>', '<esc><cmd>m .+1<cr>==gi', opts)
map('i', '<M-k>', '<esc><cmd>m .-2<cr>==gi', opts)
map('v', '<M-j>', ":m '>+1<cr>gv=gv", opts)
map('v', '<M-k>', ":m '<-2<cr>gv=gv", opts)

-- windows
map('n', '<leader>-', '<C-W>s', opts)
map('n', '<leader>|', '<C-W>v', opts)

-- https://github.com/mhinz/vim-galore#saner-behavior-of-n-and-n
map('n', 'n', "'Nn'[v:searchforward].'zv'", opts_expr)
map('x', 'n', "'Nn'[v:searchforward]", opts_expr)
map('o', 'n', "'Nn'[v:searchforward]", opts_expr)
map('n', 'N', "'nN'[v:searchforward].'zv'", opts_expr)
map('x', 'N', "'nN'[v:searchforward]", opts_expr)
map('o', 'N', "'nN'[v:searchforward]", opts_expr)

-- Clear search with <esc>
map({ 'i', 'n' }, '<esc>', '<cmd>noh<cr><esc>', opts)
