return {
    "voldikss/vim-floaterm",
    keys = {
        { "<leader>t", "<cmd>FloatermToggle<cr>", desc = "[t]Terminal" },
        { "<leader>t", "<C-\\><C-n><cmd>FloatermToggle<cr>", desc = "[t]Close Terminal", mode = "t" },
    },
    cmd = { "FloatermToggle" },
    init = function()
        vim.g.floaterm_autoclose = 2
        vim.g.floaterm_width = 0.8
        vim.g.floaterm_height = 0.8
    end,
    config = function()
        vim.cmd([[
      :hi Floaterm guibg=#282828
      :hi FloatermBorder guibg=#282828 guifg=#D4BE98
    ]])
    end,
}
