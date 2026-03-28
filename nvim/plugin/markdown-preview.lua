-- Preview markdown in browser
vim.api.nvim_create_autocmd('PackChanged', {
  callback = function(ev)
    local name, kind = ev.data.spec.name, ev.data.kind
    if name == 'markdown-preview.nvim' and (kind == 'install' or kind == 'update') then
      vim.system({ 'cd app && yarn install' }, { cwd = ev.data.path })
    end
  end,
})

vim.pack.add({ 'https://github.com/iamcco/markdown-preview.nvim' })

vim.g.mkdp_theme = 'light'
