return {
    "mfussenegger/nvim-dap",
    lazy = true,
    enabled = true,
    dependencies = {
        { "rcarriga/nvim-dap-ui", lazy = true },
        { "nvim-neotest/nvim-nio", lazy = true },
        { "theHamsta/nvim-dap-virtual-text", lazy = true },
        { "williamboman/mason.nvim", lazy = true },
        { "jay-babu/mason-nvim-dap.nvim", lazy = true },
        { "leoluz/nvim-dap-go", lazy = true },
        { "mfussenegger/nvim-dap-python", lazy = true },
    },
    keys = function(_, keys)
        return {
            {
                "<leader>dd",
                function()
                    require("dap").continue()
                end,
                desc = "[d]Debug: Start/Continue",
            },
            {
                "<leader>dj",
                function()
                    require("dap").step_into()
                end,
                desc = "[j]Debug: Step Into",
            },
            {
                "<leader>dl",
                function()
                    require("dap").step_over()
                end,
                desc = "[l]Debug: Step Next",
            },
            {
                "<leader>dh",
                function()
                    require("dap").step_back()
                end,
                desc = "[h]Debug: Step Prev",
            },
            {
                "<leader>dk",
                function()
                    require("dap").step_out()
                end,
                desc = "[k]Debug: Step Out",
            },
            {
                "<leader>db",
                function()
                    require("dap").toggle_breakpoint()
                end,
                desc = "[b]Debug: Toggle Breakpoint",
            },
            {
                "<leader>ds",
                function()
                    require("dap").set_breakpoint(vim.fn.input("Breakpoint condition: "))
                end,
                desc = "[s]Debug: Set Breakpoint",
            },
            {
                "<leader>du",
                function()
                    require("dapui").toggle()
                end,
                desc = "[u]Debug: Toggle Debug UI",
            },
            unpack(keys),
        }
    end,
    config = function()
        local dap = require("dap")
        local dapui = require("dapui")

        vim.fn.sign_define("DapBreakpoint", { text = "", texthl = "DapBreakpoint", linehl = "DapBreakpoint", numhl = "DapBreakpoint" })
        vim.fn.sign_define("DapStopped", { text = "", texthl = "DapStopped", linehl = "DapStopped", numhl = "DapStopped" })

        require("mason-nvim-dap").setup({
            automatic_installation = true,
            handlers = {},
            ensure_installed = {
                "delve",
                "python",
            },
        })

        dapui.setup({
            icons = { expanded = "▾", collapsed = "▸", current_frame = "*" },
            controls = {
                icons = {
                    pause = "⏸",
                    play = "▶",
                    step_into = "⏎",
                    step_over = "⏭",
                    step_out = "⏮",
                    step_back = "b",
                    run_last = "▶▶",
                    terminate = "⏹",
                    disconnect = "⏏",
                },
            },
        })

        dap.listeners.after.event_initialized["dapui_config"] = dapui.open
        dap.listeners.before.event_terminated["dapui_config"] = dapui.close
        dap.listeners.before.event_exited["dapui_config"] = dapui.close

        require("nvim-dap-virtual-text").setup({
            enabled = true,
        })

        require("dap-go").setup({
            delve = {
                detached = vim.fn.has("win32") == 0,
            },
            tests = {
                verbose = false,
            },
        })

        require("dap-python").setup("python")
        require("dap-python").resolve_python = function()
            local ok, venv_selector = pcall(require, "venv-selector")
            if ok then
                local python = venv_selector.python()
                if python and python ~= "" then
                    return python
                end
            end

            local python3 = vim.fn.exepath("python3")
            if python3 ~= "" then
                return python3
            end
            return vim.fn.exepath("python") ~= "" and vim.fn.exepath("python") or "python"
        end
    end,
}
