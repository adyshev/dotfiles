local M = {}

function M.setup()
    -- Lightweight personal TODO window. This is intentionally implemented as a
    -- small local helper instead of a plugin spec because it owns a single file
    -- and one keymap/user command.
    local todo_win = nil
    local todo_file = vim.fn.expand("~/.notes/todo.md")

    local function open_notes()
        -- Reuse the existing floating window if it is already open. That avoids
        -- creating multiple views of the same TODO buffer.
        if todo_win and vim.api.nvim_win_is_valid(todo_win) then
            vim.api.nvim_set_current_win(todo_win)
            return
        end

        -- Create the notes file lazily so a fresh machine can use the mapping
        -- without any manual setup.
        if vim.fn.filereadable(todo_file) == 0 then
            vim.fn.mkdir(vim.fn.fnamemodify(todo_file, ":h"), "p")
            vim.fn.writefile({}, todo_file)
        end

        local buf = vim.fn.bufnr(todo_file, true)
        vim.bo[buf].swapfile = false

        local width = math.floor(vim.o.columns * 0.9)
        local height = math.floor(vim.o.lines * 0.8)

        todo_win = vim.api.nvim_open_win(buf, true, {
            relative = "editor",
            width = width,
            height = height,
            col = math.floor((vim.o.columns - width) / 2),
            row = math.floor((vim.o.lines - height) / 2),
            border = "rounded",
            title = { { " TODO ", "SnacksPickerTitle" } },
            title_pos = "center",
            footer = { { " <C-q> Quit ", "SnacksPickerFooter" } },
            footer_pos = "center",
        })

        vim.wo[todo_win].winhighlight = "FloatBorder:SnacksPickerBorder,NormalFloat:Normal"

        local function close_todo()
            -- Avoid losing quick notes accidentally. The user can save with the
            -- normal write mapping, then close the float with <C-q>.
            if vim.bo[buf].modified then
                Snacks.notify.warn("Save your changes first")
            else
                vim.api.nvim_win_close(todo_win, true)
                todo_win = nil
            end
        end

        vim.keymap.set("n", "<C-q>", close_todo, { buffer = buf, silent = true })
        vim.keymap.set("i", "<C-q>", close_todo, { buffer = buf, silent = true })
    end

    -- Expose both a command and a mnemonic leader mapping for the same action.
    vim.api.nvim_create_user_command("Td", open_notes, {})
    vim.keymap.set("n", "<leader>n", open_notes, { desc = "[n]Notes", silent = true })
end

return M
