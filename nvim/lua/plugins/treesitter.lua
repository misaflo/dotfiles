-- Treesitter configurations and abstraction layer
return {
  'nvim-treesitter/nvim-treesitter',
  branch = 'main',
  lazy = false,
  build = ':TSUpdate',
  config = function()
    local parsers = {
      'bash',
      'comment',
      'diff',
      'lua',
      'luadoc',
      'markdown',
      'markdown_inline',
      'vim',
      'vimdoc',
    }
    local ts = require('nvim-treesitter')
    ts.install(parsers)
    local augroup = vim.api.nvim_create_augroup('misaflo_treesitter', { clear = true })

    vim.api.nvim_create_autocmd('FileType', {
      group = augroup,
      pattern = { '*' },
      callback = function(event)
        local filetype = event.match
        local lang = vim.treesitter.language.get_lang(filetype)
        local is_installed, error = vim.treesitter.language.add(lang)

        if not is_installed then
          local available_langs = ts.get_available()
          local is_available = vim.tbl_contains(available_langs, lang)

          if is_available then
            vim.notify('Available treesitter parser for ' .. lang)
          end
        else
          -- Highlighting
          vim.treesitter.start(event.buf, lang)

          -- Indentation
          vim.bo[event.buf].indentexpr = "v:lua.require('nvim-treesitter').indentexpr()"
        end
      end,
    })
  end,
}
