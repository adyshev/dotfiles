return {
    "gbprod/substitute.nvim",
    enabled = true,
    config = function()
        require("substitute").setup({
            on_substitute = require("yanky.integration").substitute(),
        })
        vim.keymap.set("n", "s", require("substitute").operator, { noremap = true })
        vim.keymap.set("n", "ss", require("substitute").line, { noremap = true })
        vim.keymap.set("n", "S", require("substitute").eol, { noremap = true })
        vim.keymap.set("x", "s", require("substitute").visual, { noremap = true })
    end,
}
