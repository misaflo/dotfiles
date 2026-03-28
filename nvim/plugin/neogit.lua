-- Magit clone: stage, commit, pull, push
vim.pack.add({
  'https://github.com/NeogitOrg/neogit',
  'https://github.com/nvim-lua/plenary.nvim',
})

vim.keymap.set('n', '<leader>gg', ':Neogit<CR>')
