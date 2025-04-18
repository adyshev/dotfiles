return {
    "rguruprakash/simple-note.nvim",
    enabled = false,
    dependencies = {
        "nvim-telescope/telescope.nvim",
    },
    config = function()
        require("simple-note").setup({
            -- configuration defaults
            notes_dir = "~/.notes/personal/",
            notes_directories = {
                "~/.notes/personal/",
                "~/.notes/work/",
            },
            telescope_new = "<M-n>",
            telescope_delete = "<M-x>",
            telescope_rename = "<M-r>",
            telescope_change_directory = "<M-c>",
        })
        vim.keymap.set("n", "<leader>n", ":SimpleNoteList<CR>", { desc = "[n]Notes" })
    end,
}
