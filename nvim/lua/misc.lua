-- Set root directory
local directory = vim.fs.root(0, '.git') or '.'
vim.cmd.cd(directory)

-- Update plugins
vim.api.nvim_create_user_command('PackUpdate', function()
  -- Sanitize default highlight of embedded markdown blocks in preview windows
  -- https://github.com/sainnhe/gruvbox-material/issues/240#issuecomment-4237593541
  vim.api.nvim_set_hl(0, '@markup.raw.block', { fg = 'fg' })
  vim.pack.update()
end, { desc = 'Update plugins' })

-- Enable UI2
require('vim._core.ui2').enable()
