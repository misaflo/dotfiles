-- Formatter
vim.pack.add({ 'https://github.com/stevearc/conform.nvim' })

require('conform').setup({
  formatters_by_ft = {
    bash = { 'shellcheck' },
    lua = { 'stylua' },
    puppet = { 'puppet-lint' },
    sh = { 'shellcheck' },
    ['*'] = { 'trim_newlines', 'trim_whitespace' },
  },
})

vim.keymap.set({ 'n', 'v' }, '<space>f', function()
  require('conform').format({ async = true, lsp_format = 'first' })
end, { desc = 'Format buffer' })
