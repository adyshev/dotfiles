return {
    "frankroeder/parrot.nvim",
    enabled = false,
    dependencies = { "ibhagwan/fzf-lua", "nvim-lua/plenary.nvim", "folke/noice.nvim", "rcarriga/nvim-notify" },
    config = function()
        require("parrot").setup({
            providers = {
                ollama = {
                    topic = {
                        model = "deepseek-r1:32b-8k",
                    },
                    params = {
                        chat = { max_tokens = 8192 },
                        command = { max_tokens = 8192 },
                    },
                },
                custom = {
                    style = "openai",
                    api_key = "CUSTOM_API_KEY",
                    endpoint = "http://localhost:1234/v1/chat/completions",
                    models = {
                        "deepseek-r1-distill-qwen-32b",
                    },
                    -- parameters to summarize chat
                    topic = {
                        model = "deepseek-r1-distill-qwen-32b",
                        params = { max_completion_tokens = 64, reasoning_content = "Alright" },
                    },
                    -- default parameters
                    params = {
                        chat = { temperature = 1.1, top_p = 1 },
                        command = { temperature = 1.1, top_p = 1 },
                    },
                },
            },
            cmd_prefix = "Prt",
            template_rewrite = [[
  I have the following content from {{filename}}:

  ```{{filetype}}
  {{selection}}
  ```

  {{command}}
  Respond exclusively with the snippet that should replace the selection above.
  Respond exclusively with the code snippet that should replace the selection above.
  Respond exclusively with the code snippet only, without any surrounding text, symbols, explanations, or additional comments.
  ]],

            hooks = {
                -- PrtImplement rewrites the provided selection/range based on comments in it
                Implement = function(parrot, params)
                    local template = [[
      Consider the following content from {{filename}}:

      ```{{filetype}}
      {{selection}}
      ```

      Please rewrite this according to the contained instructions.
      Respond exclusively with the code snippet that should replace the selection above.
      Respond exclusively with the code snippet only, without any surrounding text, symbols, explanations, or comments.
      ]]
                    local model_obj = parrot.get_model("command")
                    parrot.logger.info("Implementing selection with model: " .. model_obj.name)
                    parrot.Prompt(params, parrot.ui.Target.rewrite, model_obj, nil, template)
                end,
            },

            vim.keymap.set("n", "<leader>cc", "<cmd>PrtChatNew<cr>", { desc = "[c]New Chat with AI" }),
            vim.keymap.set("n", "<leader>cC", "<cmd>PrtChatResponde<cr>", { desc = "[C]Send prompt to AI" }),
            vim.keymap.set("v", "<leader>ce", ":<C-u>'<,'>PrtRewrite<cr>", { desc = "[e]Rewrite with AI" }),
            vim.keymap.set("v", "<leader>cw", ":<C-u>'<,'>PrtImplement<cr>", { desc = "[w]Implement with AI" }),
        })
    end,
}
