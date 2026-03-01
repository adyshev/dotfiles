local api = vim.api

function AttachFileBrowser(plugin_name, plugin_open)
    local previous_buffer_name
    api.nvim_create_autocmd("BufEnter", {
        group = api.nvim_create_augroup("UserUtilsCustomAutocmds", { clear = true }), -- I use the same group for all my autocmds. To create one: vim.api.nvim_create_augroup("CustomAutocmdGroupName", { clear = true })
        desc = string.format("[%s] replacement for Netrw", plugin_name),
        pattern = "*",
        callback = function()
            vim.schedule(function()
                local buffer_name = api.nvim_buf_get_name(0)
                if vim.fn.isdirectory(buffer_name) == 0 then
                    _, previous_buffer_name = pcall(vim.fn.expand, "#:p:h")
                    return
                end

                -- Avoid reopening when exiting without selecting a file
                if previous_buffer_name == buffer_name then
                    previous_buffer_name = nil
                    return
                else
                    previous_buffer_name = buffer_name
                end

                -- Ensure no buffers remain with the directory name
                api.nvim_set_option_value("bufhidden", "wipe", { buf = 0 })
                plugin_open(vim.fn.expand("%:p:h"))
            end)
        end,
    })
end

return {
    {
        "stevearc/oil.nvim",
        dependencies = { "nvim-tree/nvim-web-devicons", "benomahony/oil-git.nvim" },
        lazy = false,
        init = function()
            local oil_open_folder = function(path)
                require("oil").open(path)
            end
            AttachFileBrowser("oil", oil_open_folder)
        end,
        config = function()
            local oil = require("oil")
            oil.setup({
                default_file_explorer = true,
                delete_to_trash = true,
                skip_confirm_for_simple_edits = true,
                columns = { "icon" },
                keymaps = {
                    ["g?"] = false,
                    ["<CR>"] = "actions.select",
                    ["<C-s>"] = false, -- { 'actions.select', opts = { vertical = true }, desc = 'Open the entry in a vertical split' },
                    ["<C-h>"] = false, -- require("smart-splits").move_cursor_left, -- { 'actions.select', opts = { horizontal = true }, desc = 'Open the entry in a horizontal split' },
                    ["<C-l>"] = false, -- require("smart-splits").move_cursor_right, -- { 'actions.select', opts = { horizontal = true }, desc = 'Open the entry in a horizontal split' },
                    ["<C-t>"] = false, -- { 'actions.select', opts = { tab = true }, desc = 'Open the entry in new tab' },
                    ["<C-p>"] = "actions.preview",
                    ["<C-c>"] = "actions.close",
                    ["<C-r>"] = "actions.refresh",
                    ["\\"] = "actions.parent",
                    ["-"] = false,
                    ["_"] = false,
                    ["|"] = { "actions.cd", mode = "n" },
                    ["~"] = false,
                    ["gs"] = false, -- 'actions.change_sort',
                    ["gx"] = false, -- 'actions.open_external',
                    ["g."] = false, -- 'actions.toggle_hidden',
                    ["g\\"] = false, -- 'actions.toggle_trash',
                },
                view_options = {
                    show_hidden = true,
                    natural_order = true,
                    is_always_hidden = function(name, _)
                        return vim.startswith(name, ".DS_Store") or name == ".." or name == ".git"
                    end,
                },
                win_options = {
                    wrap = true,
                    winblend = 0,
                },
            })

            local orig_save = oil.save
            oil.save = function(opts, cb)
                opts = vim.tbl_extend("force", opts or {}, { confirm = false })
                return orig_save(opts, cb)
            end
        end,
        keys = {
            { "\\", "<cmd>Oil<cr>", mode = "n", desc = "Open Filesystem" },
        },
    },
}
