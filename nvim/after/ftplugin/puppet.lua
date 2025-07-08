-- Custom fixes for Puppet style
vim.api.nvim_create_user_command('FixPuppetStyle', function()
  -- Space after {
  vim.cmd("%s/{'/{ '/e")
  vim.cmd('%s/{"/{ "/e')
  -- no :: after $
  vim.cmd('%s/$::/$/e')
  vim.cmd('%s/${::/${/e')
  -- no :: before include or require classe name
  vim.cmd('%s/require ::/require /e')
  vim.cmd('%s/include ::/include /e')
  -- no :: after @@
  vim.cmd('%s/@@::/@@/e')
end, { desc = 'Fix Puppet style' })
