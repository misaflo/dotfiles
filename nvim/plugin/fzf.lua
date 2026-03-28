-- Fuzzy finder FZF
vim.pack.add({ 'https://github.com/ibhagwan/fzf-lua' })

require('fzf-lua').setup({
  fzf_colors = {
    ['fg'] = { 'fg', 'CursorLine' },
    ['bg'] = { 'bg', 'Normal' },
    ['hl'] = { 'fg', 'Aqua' },
    ['fg+'] = { 'fg', 'Normal' },
    ['bg+'] = { 'bg', 'CursorLine' },
    ['hl+'] = { 'fg', 'Aqua' },
    ['info'] = { 'fg', 'PreProc' },
    ['border'] = { 'fg', 'Grey' },
    ['prompt'] = { 'fg', 'Blue' },
    ['pointer'] = { 'fg', 'Exception' },
    ['marker'] = { 'fg', 'Keyword' },
    ['spinner'] = { 'fg', 'Label' },
    ['header'] = { 'fg', 'Comment' },
    ['gutter'] = { 'bg', 'Normal' },
  },
  keymap = {
    builtin = {
      true,
      ['<A-j>'] = 'preview-page-down',
      ['<A-k>'] = 'preview-page-up',
    },
  },
  defaults = {
    git_icons = false,
    file_icons = false,
  },
  files = {
    actions = {
      ['default'] = require('fzf-lua.actions').file_edit,
    },
  },
  oldfiles = {
    actions = {
      ['default'] = require('fzf-lua.actions').file_edit,
    },
  },
  marks = {
    -- Only show user defined marks
    marks = '%a',
  },
})

-- Use fzf-lua as the UI interface for vim.ui.select
require('fzf-lua').register_ui_select()

vim.keymap.set('n', '<leader>ff', ':FzfLua files<CR>')
vim.keymap.set('n', '<leader>fg', ':FzfLua live_grep<CR>')
vim.keymap.set('n', '<leader>fo', ':FzfLua oldfiles<CR>')
vim.keymap.set('n', '<leader>b', ':FzfLua buffers<CR>')
vim.keymap.set('n', '<leader>fr', ':FzfLua registers<CR>')
vim.keymap.set('n', '<leader>fm', ':FzfLua marks<CR>')
vim.keymap.set('n', 'z=', ':FzfLua spell_suggest<CR>')
