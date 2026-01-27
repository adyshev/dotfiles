return {
    "folke/snacks.nvim",
    priority = 1000,
    lazy = false,
    opts = {
        colorscheme = {
            enabled = true,
        },
        animate = {
            duration = 20, -- ms per step
            easing = "linear",
            fps = 120, -- frames per second. Global setting for all animations
        },
        bigfile = { enabled = true },
        indent = {
            enabled = true,
            animate = {
                enabled = false,
            },
        },
        words = { enabled = true },
        image = { enabled = true }, -- doesn't work in allacritty.
        -- image = { enabled = true },
        -- scroll = { enabled = true },
        rename = { enabled = true },
        input = { enabled = true },
        scratch = { enabled = true },
        notifier = { enabled = true },
        picker = { ui_select = true },
        notify = { enabled = true },
        quickfile = { enabled = true },
        zen = {
            toggles = {
                dim = true,
                git_signs = false,
                mini_diff_signs = false,
                diagnostics = false,
                inlay_hints = false,
            },
            zoom = {
                toggles = {
                    dim = false,
                    git_signs = false,
                    mini_diff_signs = false,
                    diagnostics = true,
                    inlay_hints = false,
                },
                center = false,
                show = { statusline = false, tabline = false },
                win = {
                    backdrop = false,
                    width = 0, -- full width
                },
            },
        },
        styles = {
            zen = {
                width = 120,
                backdrop = { transparent = false, blend = 99 },
            },
        },
    },
    init = function()
        vim.ui.select = true
        vim.api.nvim_create_autocmd("User", {
            pattern = "VeryLazy",
            callback = function()
                Snacks.toggle.option("spell", { name = "Spelling" }):map("<leader>os")
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
    keys = {
        {
            "<leader>Z",
            function()
                Snacks.zen.zoom()
            end,
            desc = "[Z]Toggle Zoom",
        },
        {
            "<leader>z",
            function()
                Snacks.zen()
            end,
            desc = "[z]Toggle Zen Mode",
        },
        {
            "]]",
            function()
                Snacks.words.jump(vim.v.count1)
            end,
            desc = "Next Reference",
            mode = { "n", "t" },
        },
        {
            "[[",
            function()
                Snacks.words.jump(-vim.v.count1)
            end,
            desc = "Prev Reference",
            mode = { "n", "t" },
        },
        {
            "<leader>.",
            function()
                Snacks.scratch()
            end,
            desc = "[.]Toggle Scratch Buffer",
        },
        {
            "<leader>>",
            function()
                Snacks.scratch.select()
            end,
            desc = "[>]Select Scratch Buffer",
        },
        {
            "<leader>gb",
            function()
                Snacks.picker.git_branches()
            end,
            desc = "[b]Git Branches",
        },
        {
            "<leader>gl",
            function()
                Snacks.picker.git_log()
            end,
            desc = "[l]Git Log",
        },
        {
            "<leader>gL",
            function()
                Snacks.picker.git_log_line()
            end,
            desc = "Git Log [L]ine",
        },
        {
            "<leader>gs",
            function()
                Snacks.picker.git_status()
            end,
            desc = "[s]Git Status",
        },
        {
            "<leader>gS",
            function()
                Snacks.picker.git_stash()
            end,
            desc = "Git [S]tash",
        },
        {
            "<leader>gd",
            function()
                Snacks.picker.git_diff()
            end,
            desc = "[d]Git Diff (Hunks)",
        },
        {
            "<leader>gf",
            function()
                Snacks.picker.git_log_file()
            end,
            desc = "[f]Git Log File",
        },
        {
            "gd",
            function()
                Snacks.picker.lsp_definitions()
            end,
            desc = "[d]Goto Definition",
        },
        {
            "gD",
            function()
                Snacks.picker.lsp_declarations()
            end,
            desc = "Goto [D]eclaration",
        },
        {
            "gr",
            function()
                Snacks.picker.lsp_references()
            end,
            nowait = true,
            desc = "[r]References",
        },
        {
            "gI",
            function()
                Snacks.picker.lsp_implementations()
            end,
            desc = "Goto [I]mplementation",
        },
        {
            "gy",
            function()
                Snacks.picker.lsp_type_definitions()
            end,
            desc = "Goto T[y]pe Definition",
        },
        {
            "gai",
            function()
                Snacks.picker.lsp_incoming_calls()
            end,
            desc = "C[a]lls Incoming",
        },
        {
            "gao",
            function()
                Snacks.picker.lsp_outgoing_calls()
            end,
            desc = "C[a]lls Outgoing",
        },
        {
            "<leader>ss",
            function()
                Snacks.picker.lsp_symbols()
            end,
            desc = "[s]LSP Symbols",
        },
        {
            "<leader>sS",
            function()
                Snacks.picker.lsp_workspace_symbols()
            end,
            desc = "[S]LSP Workspace Symbols",
        },
        {
            "<leader>gi",
            function()
                Snacks.picker.gh_issue()
            end,
            desc = "GitHub Issues (open)",
        },
        {
            "<leader>gI",
            function()
                Snacks.picker.gh_issue({ state = "all" })
            end,
            desc = "GitHub Issues (all)",
        },
        {
            "<leader>gp",
            function()
                Snacks.picker.gh_pr()
            end,
            desc = "GitHub Pull Requests (open)",
        },
        {
            "<leader>gP",
            function()
                Snacks.picker.gh_pr({ state = "all" })
            end,
            desc = "GitHub Pull Requests (all)",
        },
        --
        -- {
        --     "<c-/>",
        --     function()
        --         Snacks.terminal()
        --     end,
        --     desc = "Toggle Terminal",
        -- },
    },
}
