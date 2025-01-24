return {
  'stevearc/quicker.nvim',
  event = 'VeryLazy',
  opts = {
    keys = {
      {
        '>',
        function()
          require('quicker').expand({ before = 2, after = 2, add_to_existing = true })
        end,
        desc = 'Expand quickfix context',
      },
      {
        '<',
        function()
          require('quicker').collapse()
        end,
        desc = 'Collapse quickfix context',
      },
    },
    type_icons = {
      E = 'E ',
      W = 'W ',
      I = 'I ',
      N = 'N ',
      H = 'H ',
    },
  },
}
