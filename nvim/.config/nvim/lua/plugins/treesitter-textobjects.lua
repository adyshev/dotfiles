return {
    "nvim-treesitter/nvim-treesitter-textobjects",
    dependencies = {
        "nvim-treesitter/nvim-treesitter",
    },
    branch = "main",
    config = function()
        require("nvim-treesitter-textobjects").setup({
            select = {
                -- Automatically jump forward to textobj, similar to targets.vim
                lookahead = true,
                -- You can choose the select mode (default is charwise 'v')
                --
                -- Can also be a function which gets passed a table with the keys
                -- * query_string: eg '@function.inner'
                -- * method: eg 'v' or 'o'
                -- and should return the mode ('v', 'V', or '<c-v>') or a table
                -- mapping query_strings to modes.
                selection_modes = {
                    ["@parameter.outer"] = "v", -- charwise
                    ["@function.outer"] = "V", -- linewise
                    ["@class.outer"] = "<c-v>", -- blockwise
                },
                -- If you set this to `true` (default is `false`) then any textobject is
                -- extended to include preceding or succeeding whitespace. Succeeding
                -- whitespace has priority in order to act similarly to eg the built-in
                -- `ap`.
                --
                -- Can also be a function which gets passed a table with the keys
                -- * query_string: eg '@function.inner'
                -- * selection_mode: eg 'v'
                -- and should return true of false
                include_surrounding_whitespace = false,
            },
            move = {
                -- whether to set jumps in the jumplist
                set_jumps = true,
            },
        })

        -- Select
        -- You can use the capture groups defined in `textobjects.scm`
        vim.keymap.set({ "x", "o" }, "am", function()
            require("nvim-treesitter-textobjects.select").select_textobject("@function.outer", "textobjects")
        end)
        vim.keymap.set({ "x", "o" }, "im", function()
            require("nvim-treesitter-textobjects.select").select_textobject("@function.inner", "textobjects")
        end)
        vim.keymap.set({ "x", "o" }, "ac", function()
            require("nvim-treesitter-textobjects.select").select_textobject("@class.outer", "textobjects")
        end)
        vim.keymap.set({ "x", "o" }, "ic", function()
            require("nvim-treesitter-textobjects.select").select_textobject("@class.inner", "textobjects")
        end)

        -- Swap
        vim.keymap.set("n", "<leader>cp", function()
            require("nvim-treesitter-textobjects.swap").swap_next("@parameter.inner")
        end, { desc = "[p]Swap with next parameter" })

        vim.keymap.set("n", "<leader>cP", function()
            require("nvim-treesitter-textobjects.swap").swap_previous("@parameter.outer")
        end, { desc = "[P]Swap with prev parameter" })

        -- Move
        vim.keymap.set({ "n", "x", "o" }, "]m", function()
            require("nvim-treesitter-textobjects.move").goto_next_start("@function.outer", "textobjects")
        end)
        vim.keymap.set({ "n", "x", "o" }, "]]", function()
            require("nvim-treesitter-textobjects.move").goto_next_start("@class.outer", "textobjects")
        end)

        vim.keymap.set({ "n", "x", "o" }, "]M", function()
            require("nvim-treesitter-textobjects.move").goto_next_end("@function.outer", "textobjects")
        end)
        vim.keymap.set({ "n", "x", "o" }, "][", function()
            require("nvim-treesitter-textobjects.move").goto_next_end("@class.outer", "textobjects")
        end)

        vim.keymap.set({ "n", "x", "o" }, "[m", function()
            require("nvim-treesitter-textobjects.move").goto_previous_start("@function.outer", "textobjects")
        end)
        vim.keymap.set({ "n", "x", "o" }, "[[", function()
            require("nvim-treesitter-textobjects.move").goto_previous_start("@class.outer", "textobjects")
        end)

        vim.keymap.set({ "n", "x", "o" }, "[M", function()
            require("nvim-treesitter-textobjects.move").goto_previous_end("@function.outer", "textobjects")
        end)
        vim.keymap.set({ "n", "x", "o" }, "[]", function()
            require("nvim-treesitter-textobjects.move").goto_previous_end("@class.outer", "textobjects")
        end)

        local ts_repeat_move = require("nvim-treesitter-textobjects.repeatable_move")

        -- Repeat movement with ; and ,
        -- ensure ; goes forward and , goes backward regardless of the last direction
        vim.keymap.set({ "n", "x", "o" }, ">", ts_repeat_move.repeat_last_move_next)
        vim.keymap.set({ "n", "x", "o" }, "<", ts_repeat_move.repeat_last_move_previous)
    end,
}
