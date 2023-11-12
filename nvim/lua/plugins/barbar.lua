-- Tabline
return {
  'romgrk/barbar.nvim',
  dependencies = 'nvim-tree/nvim-web-devicons',
  lazy = false,
  keys = {
    { '<A-a>', ':BufferPrevious<CR>' },
    { '<A-z>', ':BufferNext<CR>' },
    { '<A-A>', ':BufferMovePrevious<CR>' },
    { '<A-Z>', ':BufferMoveNext<CR>' },
    { '<A-p>', ':BufferPin<CR>' },
    { '<A-c>', ':BufferClose<CR>' },
  },
  opts = {
    auto_hide = true,
    icons = {
      button = false,
      modified = false,
    },
  },
}
