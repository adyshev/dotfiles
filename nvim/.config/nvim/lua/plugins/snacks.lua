return {
    "folke/snacks.nvim",
    priority = 1000,
    lazy = false,
    ---@type snacks.Config
    opts = {
        bigfile = { enabled = true },
        indent = {
            enabled = true,
            animate = {
                enabled = false,
            },
        },
        input = { enabled = true },
        notifier = { enabled = true },
        notify = { enabled = true },
        quickfile = { enabled = true },
    },
    keys = {
        {
            "<leader>Z",
            function()
                Snacks.zen.zoom()
            end,
            desc = "[Z]Toggle Zoom",
        },
    },
    init = function()
        vim.api.nvim_create_autocmd("User", {
            pattern = "VeryLazy",
            callback = function()
                Snacks.toggle.option("spell", { name = "[s]Spelling" }):map("<leader>os")
                Snacks.toggle.inlay_hints():map("<leader>oh")
                Snacks.toggle.indent():map("<leader>og")
                Snacks.toggle.option("conceallevel", { off = 0, on = vim.o.conceallevel > 0 and vim.o.conceallevel or 2 }):map("<leader>oc")
                Snacks.toggle.treesitter():map("<leader>oT")
                Snacks.toggle.option("wrap", { name = "Wrap" }):map("<leader>ow")
                Snacks.toggle.option("relativenumber", { name = "Relative Number" }):map("<leader>oL")
                Snacks.toggle.diagnostics():map("<leader>od")
                Snacks.toggle.line_number():map("<leader>ol")
            end,
        })
    end,
}
