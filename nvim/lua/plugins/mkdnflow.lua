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
        folds = false,
        tables = false,
      },
      filetypes = { md = true, mdwn = true, markdown = true },
      links = {
        transform_implicit = false,
        transform_explicit = function(text)
          text = text:gsub(' ', '-')
          text = text:lower()
          return text
        end,
      },
    })
  end,
}
