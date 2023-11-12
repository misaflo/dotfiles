-- Notification manager
return {
  'rcarriga/nvim-notify',
  event = 'VeryLazy',
  config = function()
    require('notify').setup({
      stages = 'static',
      timeout = 4000,
    })
    vim.notify = require('notify')
  end,
}
