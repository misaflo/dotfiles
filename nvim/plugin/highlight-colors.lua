-- Color name highlighter
vim.pack.add({ 'https://github.com/brenoprata10/nvim-highlight-colors' })

local hlc = require('nvim-highlight-colors')
hlc.setup()
hlc.turnOff()

vim.api.nvim_create_autocmd('FileType', {
  pattern = {
    'css',
    'swayconfig',
  },
  callback = function(event)
    hlc.turnOn()
  end,
  group = vim.api.nvim_create_augroup('misaflo_hlc', { clear = true }),
})
