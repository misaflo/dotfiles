local autocmd = vim.api.nvim_create_autocmd

local function augroup(name)
  vim.api.nvim_create_augroup('misaflo_' .. name, { clear = true })
end

-- Disable line number in terminal-mode
autocmd('TermOpen', {
  command = 'setlocal nonumber norelativenumber',
  group = augroup('term'),
})

-- Highlight yanked region
autocmd('TextYankPost', {
  callback = function()
    vim.highlight.on_yank({ higroup = 'Search', timeout = 700 })
  end,
  group = augroup('yank'),
})

-- Always open quickfix window automatically.
-- This uses cwindows which will open it only if there are entries.
autocmd('QuickFixCmdPost', {
  pattern = { '[^l]*' },
  command = 'cwindow',
  group = augroup('quickfix'),
})

-- Open help in vertical split
autocmd('BufWinEnter', {
  pattern = '*.txt',
  callback = function()
    if vim.bo.filetype == 'help' and vim.api.nvim_win_get_width(0) > 180 then
      vim.cmd.wincmd('L')
    end
  end,
  group = augroup('help'),
})

