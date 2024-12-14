-- Management of markdown notebooks
return {
  'jakewvincent/mkdnflow.nvim',
  ft = 'markdown',
  config = function()
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
        cmp = false,
      },
      filetypes = { md = true, mdwn = true, markdown = true },
    })
  end,
}
