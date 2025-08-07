return {
    "linux-cultist/venv-selector.nvim",
    dependencies = { "neovim/nvim-lspconfig", "nvim-telescope/telescope.nvim", "mfussenegger/nvim-dap-python" },
    config = function()
        require("venv-selector").setup({
            -- Your options go here
            -- name = "venv",
            -- auto_refresh = false
        })
    end,
    event = "VeryLazy", -- Optional: needed only if you want to type `:VenvSelect` without a keymapping
    keys = {
        { "<leader>v", "<cmd>VenvSelect<cr>", desc = "[v]Venv Selector" },
    },
}
