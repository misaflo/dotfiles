-- Management of markdown notebooks
vim.pack.add({ 'https://github.com/jakewvincent/mkdnflow.nvim' })

require('mkdnflow').setup({
  modules = {
    bib = false,
    buffers = false,
    conceal = false,
    cursor = false,
    folds = false,
    foldtext = false,
    links = false,
    lists = true,
    maps = true,
    paths = false,
    tables = false,
    yaml = false,
    completion = false,
  },
})
