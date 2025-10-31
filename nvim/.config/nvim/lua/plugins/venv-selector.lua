return {
    "linux-cultist/venv-selector.nvim",
    dependencies = { "neovim/nvim-lspconfig", "nvim-telescope/telescope.nvim" },
    ft = "python", -- Load when opening Python files
    config = function()
        require("venv-selector").setup({
            -- Your options go here
            -- name = "venv",
            -- auto_refresh = false
        })
    end,
    keys = {
        { "<leader>v", "<cmd>VenvSelect<cr>", desc = "[v]Venv Selector" },
    },
}
