-- Status line
vim.pack.add({ 'https://github.com/nvim-lualine/lualine.nvim' })

require('lualine').setup({
  options = {
    icons_enabled = false,
    theme = 'gruvbox-material',
    section_separators = '',
    component_separators = '|',
  },
})
