-- Add/change/delete surrounding delimiter pairs
vim.pack.add({ 'https://github.com/kylechui/nvim-surround' })

require('nvim-surround').setup({
  surrounds = {
    ['«'] = {
      add = { '« ', ' »' },
    },
    ['»'] = {
      add = { '«', '»' },
    },
  },
})
