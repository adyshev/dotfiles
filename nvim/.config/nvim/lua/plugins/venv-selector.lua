return {
    "linux-cultist/venv-selector.nvim",
    dependencies = { "neovim/nvim-lspconfig" },
    event = "VimEnter",
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
