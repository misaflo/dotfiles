-- Magit clone: stage, commit, pull, push
vim.pack.add({ 'https://github.com/NeogitOrg/neogit' })

-- See https://github.com/NeogitOrg/neogit/issues/1964
require('neogit').setup({
  treesitter_diff_highlight = true,
})

vim.keymap.set('n', '<leader>gg', ':Neogit<CR>')
