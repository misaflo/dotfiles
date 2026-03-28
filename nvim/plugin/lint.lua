-- Linter
vim.pack.add({ 'https://github.com/mfussenegger/nvim-lint' })

require('lint').linters_by_ft = {
  bash = { 'shellcheck' },
  puppet = { 'puppet-lint' },
  sh = { 'shellcheck' },
  yaml = { 'yamllint' },
}

vim.api.nvim_create_autocmd({ 'BufEnter', 'BufWritePost' }, {
  desc = 'Check the file',
  callback = function()
    require('lint').try_lint()
  end,
  group = vim.api.nvim_create_augroup('misaflo_lint', { clear = true }),
})
