return {
    "gutsavgupta/nvim-gemini-companion",
    dependencies = { "nvim-lua/plenary.nvim" },
    event = "VeryLazy",
    config = function()
        require("gemini").setup()
    end,
    keys = {
        { "<leader>cg", "<cmd>GeminiToggle<cr>", desc = "Toggle Gemini sidebar" },
        { "<leader>cG", "<cmd>GeminiSwitchToCli<cr>", desc = "Spawn or switch to AI session" },
        { "<leader>cg", "<cmd>GeminiSend<cr>", mode = { "x" }, desc = "Send selection to Gemini" },
    },
}
