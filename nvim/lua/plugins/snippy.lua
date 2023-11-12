-- Snippet engine
return {
  'dcampos/nvim-snippy',
  ft = 'snippets',
  event = 'InsertEnter',
  keys = {
    {
      '<C-x><C-s>',
      function()
        require('snippy').complete()
      end,
      mode = 'i',
    },
  },
  opts = {
    mappings = {
      is = {
        ['<Tab>'] = 'expand',
        ['<C-j>'] = 'next',
        ['<C-k>'] = 'previous',
      },
    },
  },
}
