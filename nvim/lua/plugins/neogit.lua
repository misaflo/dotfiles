-- Magit clone: stage, commit, pull, push
return {
  'NeogitOrg/neogit',
  dependencies = {
    'nvim-lua/plenary.nvim',
    'ibhagwan/fzf-lua',
  },
  keys = { { '<leader>gg', ':Neogit<CR>' } },
  config = true,
}
