-- Set root directory
local directory = vim.fs.root(0, '.git') or '.'
vim.cmd.cd(directory)

-- Update plugins
vim.api.nvim_create_user_command('PackUpdate', function()
  vim.pack.update()
end, { desc = 'Update plugins' })
