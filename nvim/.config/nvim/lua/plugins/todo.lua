local function _1_()
    local todo = require("floatingtodo")
    todo.setup({ target_file = "~/.notes/todo.md", width = 0.8, height = 0.6, border = "rounded", position = "bottomright" })
    return vim.keymap.set("n", "<leader>n", ":Td<CR>", { desc = "[n]Notes", silent = true })
end
return { "vimichael/floatingtodo.nvim", config = _1_ }
