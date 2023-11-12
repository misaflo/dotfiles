-- Jump anywhere in a document with as few keystrokes as possible
return {
  'smoka7/hop.nvim',
  event = 'VeryLazy',
  config = function()
    require('hop').setup({ keys = 'etovxqpdygfblzhckisuran' })

    local hop = require('hop')
    local directions = require('hop.hint').HintDirection

    -- Don't map for visual mode (causes problem with snippy)
    vim.keymap.set({ 'n', 'o' }, 'f', function()
      hop.hint_char1({ direction = directions.AFTER_CURSOR, current_line_only = true })
    end)
    vim.keymap.set({ 'n', 'o' }, 'F', function()
      hop.hint_char1({ direction = directions.BEFORE_CURSOR, current_line_only = true })
    end)
    vim.keymap.set({ 'n', 'o' }, 't', function()
      hop.hint_char1({ direction = directions.AFTER_CURSOR, current_line_only = true, hint_offset = -1 })
    end)
    vim.keymap.set({ 'n', 'o' }, 'T', function()
      hop.hint_char1({ direction = directions.BEFORE_CURSOR, current_line_only = true, hint_offset = 1 })
    end)
    vim.keymap.set('n', 's', ':HopWord<CR>')
  end,
}
