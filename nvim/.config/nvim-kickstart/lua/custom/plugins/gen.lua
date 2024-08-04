return {
  'David-Kunz/gen.nvim',
  config = function()
    require('gen').setup {
      model = 'llama3.1',
    }
    require('gen').prompts = {}
    require('gen').prompts['Polish_Text'] = {
      prompt = 'Please validate and polish the text for English grammar, returning the raw result without any additional commentary such as changes made, formatting, empty lines or the mentioning original text:\n$text',
      model = 'GRAMMARLyft',
      replace = true,
      hidden = true,
    }
    vim.keymap.set({ 'n', 'v' }, '<leader>=', ':Gen<CR>', { desc = '[=]Generative AI' })
    vim.keymap.set({ 'n', 'v' }, '<leader>p', ':Gen Polish_Text<CR>', { desc = '[p]Polish Text' })
  end,
}
