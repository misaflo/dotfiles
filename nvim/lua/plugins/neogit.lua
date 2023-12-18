-- Magit clone: stage, commit, pull, push
return {
  'NeogitOrg/neogit',
  dependencies = 'nvim-lua/plenary.nvim',
  keys = { { '<leader>gg', ':Neogit<CR>' } },
  config = true,
}
