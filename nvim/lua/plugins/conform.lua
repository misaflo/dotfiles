-- Formatter
return {
  'stevearc/conform.nvim',
  cmd = { 'ConformInfo' },
  keys = {
    {
      '<space>f',
      function()
        require('conform').format({ async = true, lsp_fallback = true })
      end,
      mode = '',
      desc = 'Format buffer',
    },
  },
  opts = {
    formatters_by_ft = {
      lua = { 'stylua' },
      puppet = { 'puppet-lint' },
      sh = { 'shellcheck' },
      ['*'] = { 'trim_newlines', 'trim_whitespace' },
    },
  },
}
