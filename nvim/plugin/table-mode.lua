-- Table creator and formatter
vim.pack.add({ 'https://github.com/dhruvasagar/vim-table-mode' })

vim.g.table_mode_corner = '|' -- markdown-compatible tables
vim.g.table_mode_syntax = 0 -- improve performance

vim.keymap.set('n', '<leader>tm', ':TableModeToggle<CR>')
