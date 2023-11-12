-- Magit clone: stage, commit, pull, push
return {
  'NeogitOrg/neogit',
  dependencies = 'nvim-lua/plenary.nvim',
  keys = { { '<leader>gg', ':Neogit<CR>' } },
  opts = { disable_commit_confirmation = true },
}
