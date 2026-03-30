-- Color name highlighter
vim.pack.add({ 'https://github.com/brenoprata10/nvim-highlight-colors' })

require('nvim-highlight-colors').setup({
  exclude_filetypes = {
    'nvim-pack',
  },
})
