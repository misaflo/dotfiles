-- Preview markdown in browser
return {
  'iamcco/markdown-preview.nvim',
  build = 'cd app && yarn install',
  ft = 'markdown',
  config = function()
    vim.g.mkdp_theme = 'light'
  end,
}
