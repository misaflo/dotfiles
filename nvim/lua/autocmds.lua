local autocmd = vim.api.nvim_create_autocmd

local function augroup(name)
  vim.api.nvim_create_augroup('misaflo_' .. name, { clear = true })
end

-- Highlight yanked region
autocmd('TextYankPost', {
  callback = function()
    vim.hl.on_yank({ higroup = 'Search', timeout = 700 })
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

-- Close some filetypes with <q>
vim.api.nvim_create_autocmd('FileType', {
  pattern = {
    'help',
    'qf',
  },
  callback = function(event)
    vim.bo[event.buf].buflisted = false
    vim.schedule(function()
      vim.keymap.set('n', 'q', function()
        vim.cmd('close')
        pcall(vim.api.nvim_buf_delete, event.buf, { force = true })
      end, {
        buffer = event.buf,
        silent = true,
        desc = 'Quit buffer',
      })
    end)
  end,
  group = augroup('close_with_q'),
})
