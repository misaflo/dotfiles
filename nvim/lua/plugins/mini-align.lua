-- Align text interactively
return {
  'echasnovski/mini.align',
  event = 'VeryLazy',
  config = function()
    require('mini.align').setup()
  end,
}
