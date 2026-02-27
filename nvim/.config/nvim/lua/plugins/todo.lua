local todo_win = nil
local todo_file = vim.fn.expand("~/.notes/todo.md")

local function open_notes()
    if todo_win and vim.api.nvim_win_is_valid(todo_win) then
        vim.api.nvim_set_current_win(todo_win)
        return
    end

    if vim.fn.filereadable(todo_file) == 0 then
        vim.fn.mkdir(vim.fn.fnamemodify(todo_file, ":h"), "p")
        vim.fn.writefile({}, todo_file)
    end

    local buf = vim.fn.bufnr(todo_file, true)
    vim.bo[buf].swapfile = false

    local width = math.floor(vim.o.columns * 0.8)
    local height = math.floor(vim.o.lines * 0.8)

    todo_win = vim.api.nvim_open_win(buf, true, {
        relative = "editor",
        width = width,
        height = height,
        col = math.floor((vim.o.columns - width) / 2),
        row = math.floor((vim.o.lines - height) / 2),
        border = "rounded",
    })

    vim.keymap.set("n", "q", function()
        if vim.bo[buf].modified then
            vim.notify("Save your changes first", vim.log.levels.WARN)
        else
            vim.api.nvim_win_close(todo_win, true)
            todo_win = nil
        end
    end, { buffer = buf, silent = true })
end

vim.api.nvim_create_user_command("Td", open_notes, {})
vim.keymap.set("n", "<leader>n", open_notes, { desc = "[n]Notes", silent = true })

return {}
