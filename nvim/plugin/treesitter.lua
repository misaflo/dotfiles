-- Treesitter configurations and abstraction layer
vim.api.nvim_create_autocmd('PackChanged', {
  callback = function(ev)
    local name, kind = ev.data.spec.name, ev.data.kind
    if name == 'nvim-treesitter' and kind == 'update' then
      if not ev.data.active then
        vim.cmd.packadd('nvim-treesitter')
      end
      vim.cmd('TSUpdate')
    end
  end,
})

vim.pack.add({ 'https://github.com/nvim-treesitter/nvim-treesitter' })

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
