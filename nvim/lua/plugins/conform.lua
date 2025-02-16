-- Formatter
return {
  'stevearc/conform.nvim',
  cmd = { 'ConformInfo' },
  keys = {
    {
      '<space>f',
      function()
        require('conform').format({ async = true, lsp_format = 'fallback' })
      end,
      mode = { 'n', 'v' },
      desc = 'Format buffer',
    },
  },
  opts = {
    formatters_by_ft = {
      bash = { 'shellcheck' },
      lua = { 'stylua' },
      puppet = { 'puppet-lint' },
      sh = { 'shellcheck' },
      ['*'] = { 'trim_newlines', 'trim_whitespace' },
    },
  },
}
