return {
    "xTacobaco/cursor-agent.nvim",
    config = function()
        require("cursor-agent").setup()
        local util = require("cursor-agent.util")
        util.get_project_root = function()
            return vim.fn.getcwd()
        end

        vim.keymap.set("n", "<leader>cc", ":CursorAgent<CR>", { desc = "Cursor Agent: Toggle terminal" })
        vim.keymap.set("v", "<leader>cc", ":CursorAgentSelection<CR>", { desc = "Cursor Agent: Send selection" })
        vim.keymap.set("n", "<leader>cC", ":CursorAgentBuffer<CR>", { desc = "Cursor Agent: Send buffer" })
    end,
}
