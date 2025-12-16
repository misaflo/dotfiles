-- Treesitter configurations and abstraction layer
return {
  'nvim-treesitter/nvim-treesitter',
  build = ':TSUpdate',
  branch = 'master',
  config = function()
    require('nvim-treesitter.configs').setup({
      auto_install = true,
      highlight = {
        enable = true,
      },
      indent = {
        enable = true,
        disable = { 'markdown' },
      },
      matchup = {
        enable = true,
      },
    })
  end,
}
