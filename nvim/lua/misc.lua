-- Set root directory
vim.cmd('cd ' .. vim.fs.root(0, '.git'))

-- Update plugins
vim.api.nvim_create_user_command('PackUpdate', function()
  vim.pack.update()
end, { desc = 'Update plugins' })
