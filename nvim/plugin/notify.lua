-- Notification manager
vim.pack.add({ 'https://github.com/rcarriga/nvim-notify' })

require('notify').setup({
  stages = 'static',
  timeout = 4000,
})

vim.notify = require('notify')
