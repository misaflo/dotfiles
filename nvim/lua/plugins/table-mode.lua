-- Table creator and formatter
return {
  'dhruvasagar/vim-table-mode',
  keys = { { '<leader>tm', ':TableModeToggle<CR>' } },
  config = function()
    vim.g.table_mode_corner = '|' -- markdown-compatible tables
  end,
}
