return {
    "chrisgrieser/nvim-spider",
    enabled = false,
    keys = {
        { "w", "<cmd>lua require('spider').motion('w')<cr>", desc = "Spider-w", mode = { "n", "o", "x" } },
        { "e", "<cmd>lua require('spider').motion('e')<cr>", desc = "Spider-e", mode = { "n", "o", "x" } },
        { "b", "<cmd>lua require('spider').motion('b')<cr>", desc = "Spider-b", mode = { "n", "o", "x" } },
    },
    config = function()
        require("spider").setup({
            skipInsignificantPunctuation = true,
        })
    end,
}
