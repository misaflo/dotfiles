local autocmd = vim.api.nvim_create_autocmd

local function augroup(name)
  vim.api.nvim_create_augroup('misaflo_' .. name, { clear = true })
end

autocmd('TermOpen', {
  desc = 'Disable line number in terminal-mode',
  command = 'setlocal nonumber norelativenumber',
  group = augroup('term'),
})

autocmd('TextYankPost', {
  desc = 'Highlight yanked region',
  callback = function()
    vim.highlight.on_yank({ higroup = 'Search', timeout = 700 })
  end,
  group = augroup('yank'),
})

autocmd('BufWinEnter', {
  pattern = '*.txt',
  desc = 'Open help in vertical split',
  callback = function()
    if vim.bo.filetype == 'help' and vim.api.nvim_win_get_width(0) > 180 then
      vim.cmd.wincmd('L')
    end
  end,
  group = augroup('help'),
})

