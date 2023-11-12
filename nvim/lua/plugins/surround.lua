-- Add/change/delete surrounding delimiter pairs
return {
  'kylechui/nvim-surround',
  event = 'VeryLazy',
  opts = {
    surrounds = {
      ['«'] = {
        add = { '« ', ' »' },
      },
      ['»'] = {
        add = { '«', '»' },
      },
    },
  },
}
