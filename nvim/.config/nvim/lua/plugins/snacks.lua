return {
    "folke/snacks.nvim",
    priority = 1000,
    lazy = false,
    opts = {
        colorscheme = {
            enabled = false,
        },
        dim = { enabled = false },
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
        scroll = { enabled = false },
        rename = { enabled = true },
        input = { enabled = true },
        scratch = { enabled = true },
        notifier = { enabled = true },
        picker = {
            ui_select = true,
            sources = {
                projects = {
                    dev = { "~/src" },
                },
            },
        },
        notify = { enabled = true },
        -- scope = { enabled = true },
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
            float = {
                position = "float",
                backdrop = false,
                height = 0.9,
                width = 0.9,
                zindex = 50,
            },
            scratch = {
                width = 100,
                height = 30,
                bo = { buftype = "", buflisted = false, bufhidden = "hide", swapfile = false },
                minimal = false,
                noautocmd = false,
                -- position = "right",
                zindex = 20,
                wo = { winhighlight = "NormalFloat:Normal" },
                footer_keys = true,
                border = true,
            },
        },
    },
    init = function()
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
            "<leader>s?",
            function()
                Snacks.picker.help()
            end,
            desc = "[?]Search Help",
        },
        {
            "<leader>sm",
            function()
                Snacks.picker.command_history()
            end,
            desc = "[m]Search Command History",
        },
        {
            "<leader>sh",
            function()
                Snacks.picker.search_history()
            end,
            desc = "[h]Search Search History",
        },
        {
            "<leader>se",
            function()
                Snacks.picker.notifications()
            end,
            desc = "[e]Search Notifications",
        },
        {
            "<leader>st",
            function()
                Snacks.picker.todo_comments()
            end,
            desc = "[t]Search TODO",
        },
        {
            "<leader>sd",
            function()
                Snacks.picker.diagnostics()
            end,
            desc = "[d]Search Diagnostics",
        },
        {
            "<leader>sk",
            function()
                Snacks.picker.keymaps()
            end,
            desc = "[k]Search Keymaps",
        },
        {
            "<leader>sf",
            function()
                Snacks.picker.files({ hidden = true, ignored = false })
            end,
            desc = "[f]Search Files",
        },
        {
            "<leader>sr",
            function()
                Snacks.picker.registers()
            end,
            desc = "[r]Search Registers",
        },
        {
            "<leader>sl",
            function()
                Snacks.picker.spelling()
            end,
            desc = "[l]Search Spell Suggestions",
        },
        {
            "<leader>sw",
            function()
                Snacks.picker.grep_word()
            end,
            desc = "[w]Search current Word",
            mode = { "n", "x" },
        },
        {
            "<leader>sg",
            function()
                Snacks.picker.grep({ hidden = true })
            end,
            desc = "[g]Search by Grep",
        },
        {
            "<leader><leader>",
            function()
                Snacks.picker.recent()
            end,
            desc = "[ ]Search Recent files",
        },
        {
            "<leader>so",
            function()
                Snacks.picker.buffers()
            end,
            desc = "[o]Search open buffers",
        },
        {
            "<leader>sb",
            function()
                Snacks.picker.explorer()
            end,
            desc = "[b]File Browser",
        },
        {
            "<leader>sO",
            function()
                Snacks.picker.grep({ buf = true })
            end,
            desc = "[O]Search in Open Files",
        },
        {
            "<leader>sn",
            function()
                Snacks.picker.files({ cwd = vim.fn.stdpath("config") })
            end,
            desc = "[n]Search Neovim config files",
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
            "gf",
            function()
                Snacks.picker.lsp_references()
            end,
            nowait = true,
            desc = "[f]References",
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
    },
}
