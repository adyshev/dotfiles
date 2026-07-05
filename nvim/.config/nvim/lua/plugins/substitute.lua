return {
    "gbprod/substitute.nvim",
    enabled = true,
    config = function()
        local substitute = require("substitute")

        substitute.setup({
            on_substitute = require("yanky.integration").substitute(),
        })

        local function can_substitute()
            return vim.bo.modifiable and not vim.bo.readonly
        end

        local function guarded(action)
            return function()
                if can_substitute() then
                    action()
                end
            end
        end

        vim.keymap.set("n", "s", guarded(substitute.operator), { noremap = true })
        vim.keymap.set("n", "ss", guarded(substitute.line), { noremap = true })
        vim.keymap.set("n", "S", guarded(substitute.eol), { noremap = true })
        vim.keymap.set("x", "s", guarded(substitute.visual), { noremap = true })
    end,
}
