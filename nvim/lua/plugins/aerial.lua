-- Outline window for quick navigation
return {
  'stevearc/aerial.nvim',
  dependencies = {
    'nvim-treesitter/nvim-treesitter',
    'nvim-tree/nvim-web-devicons',
  },
  keys = { { '<F9>', ':AerialToggle<CR>' } },
  config = true,
}
