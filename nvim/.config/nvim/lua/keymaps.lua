local map = vim.keymap.set

local opts = { noremap = true, silent = true }

-- Several mappings below edit the current buffer directly. Always check
-- modifiability first so the same mappings are harmless in special buffers
-- such as help, Oil, pickers, dashboards, terminals, and quickfix windows.
local function can_edit_buffer()
    return vim.bo.modifiable and not vim.bo.readonly
end

-- Basic terminal/editor ergonomics.
map("t", "<C-t>", "<C-\\><C-n>", opts)
map("n", "vv", "^v$", opts)
map("n", "q:", ":", opts)
map("i", "<C-v>", "<C-r>+", opts)

-- Save only real file buffers. In nofile/help/plugin buffers, `<C-s>` should
-- exit insert/select mode but avoid triggering write errors.
map({ "i", "x", "n", "s" }, "<C-s>", function()
    if vim.bo.buftype == "" then
        vim.cmd.write()
    end
    return "<esc>"
end, { expr = true, noremap = true, silent = true })
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

-- Yank all (remap so yanky's y is used)
map("n", "<M-y>", "ggVGy", { silent = true })
-- Select all
map("n", "<M-a>", "ggVG", opts)
-- Duplicate line (explicit: yank line, paste above)
map("n", "<M-d>", function()
    if not can_edit_buffer() then
        return
    end
    local line = vim.api.nvim_get_current_line()
    local row = vim.api.nvim_win_get_cursor(0)[1]
    vim.api.nvim_buf_set_lines(0, row - 1, row - 1, false, { line })
end, { silent = true })

-- Clear search with <esc>
map({ "i", "n" }, "<esc>", "<cmd>noh<cr><esc>", opts)
vim.keymap.set("t", "<Esc>", [[<C-\><C-n>]], { noremap = true })

-- Allow clipboard copy paste in neovim
if vim.fn.has("mac") == 1 then
    map("n", "<D-v>", '"+P', opts)
    map("i", "<D-v>", "<C-r>+", opts)
    map("v", "<D-v>", '"+P', opts)
    map("t", "<D-v>", "<C-R>+", opts)
end
