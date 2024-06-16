-- Color name highlighter
return {
  'NvChad/nvim-colorizer.lua',
  opts = {
    filetypes = {
      '*',
      '!NeogitCommitMessage', '!NeogitStatus',
      '!gitcommit',
      '!lazy',
      '!mail'
    },
  },
}
