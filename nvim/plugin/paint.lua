-- Easily add additional highlights
vim.pack.add({ 'https://github.com/folke/paint.nvim' })

require('paint').setup({
  highlights = {
    {
      filter = { filetype = 'puppet' },
      pattern = '^# (@%w+)',
      hl = 'Constant',
    },
    {
      filter = { filetype = 'puppet' },
      pattern = '^# @param (%S+)',
      hl = 'Identifier',
    },
  },
})
