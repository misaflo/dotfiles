-- Improved UI and workflow for the quickfix
return {
  'stevearc/quicker.nvim',
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
    -- Hide filename for TOC (table of contents)
    -- https://github.com/stevearc/quicker.nvim/issues/36
    max_filename_width = function()
      if vim.w.qf_toc or (vim.w.quickfix_title and vim.w.quickfix_title:find('TOC')) then
        return 0
      end
      return math.floor(math.min(95, vim.o.columns / 2))
    end,
  },
}
