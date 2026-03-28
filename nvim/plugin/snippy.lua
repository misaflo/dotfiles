-- Snippet engine
vim.pack.add({ 'https://github.com/dcampos/nvim-snippy' })

require('snippy').setup({
  mappings = {
    is = {
      ['<Tab>'] = 'expand',
      ['<C-j>'] = 'next',
      ['<C-k>'] = 'previous',
    },
  },
})

vim.keymap.set('i', '<C-x><C-s>', function()
  require('snippy').complete()
end)
