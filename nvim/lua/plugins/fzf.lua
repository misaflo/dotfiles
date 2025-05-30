-- Fuzzy finder FZF
return {
  'ibhagwan/fzf-lua',
  keys = {
    { '<leader>ff', ':FzfLua files<CR>' },
    { '<leader>fg', ':FzfLua live_grep<CR>' },
    { '<leader>fo', ':FzfLua oldfiles<CR>' },
    { '<leader>b', ':FzfLua buffers<CR>' },
    { '<leader>fr', ':FzfLua registers<CR>' },
    { '<leader>fm', ':FzfLua marks<CR>' },
    { 'z=', ':FzfLua spell_suggest<CR>' },
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
  end,
}
