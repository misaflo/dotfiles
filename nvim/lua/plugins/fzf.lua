-- Fuzzy finder FZF
return {
  'ibhagwan/fzf-lua',
  keys = {
    { '<leader>ff', ':FzfLua files<CR>' },
    { '<leader>fg', ':FzfLua live_grep<CR>' },
    { '<leader>fb', ':FzfLua buffers<CR>' },
  },
  config = function()
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
          ['<A-j>'] = 'preview-page-down',
          ['<A-k>'] = 'preview-page-up',
        },
      },
      files = {
        git_icons = false,
        file_icons = false,
        actions = {
          ['default'] = require('fzf-lua.actions').file_edit,
        },
      },
      grep = {
        git_icons = false,
        file_icons = false,
      },
    })
  end,
}
