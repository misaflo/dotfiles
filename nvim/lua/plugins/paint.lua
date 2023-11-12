-- Easily add additional highlights
return {
  'folke/paint.nvim',
  ft = 'puppet',
  opts = {
    highlights = {
      {
        filter = { filetype = 'puppet' },
        pattern = '^# (@%w+)',
        hl = 'Constant',
      },
      {
        filter = { filetype = 'puppet' },
        pattern = '^# @param (%S+)',
        hl = 'Identifier',
      },
    },
  },
}
