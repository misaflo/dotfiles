-- CSV file editing
vim.pack.add({ 'https://github.com/hat0uma/csvview.nvim' })

require('csvview').setup({
  keymaps = {
    -- Text objects for selecting fields
    textobject_field_inner = { 'if', mode = { 'o', 'x' } },
    textobject_field_outer = { 'af', mode = { 'o', 'x' } },
    -- Use <Tab> and <S-Tab> to move horizontally between fields.
    jump_next_field_end = { '<Tab>', mode = { 'n', 'v' } },
    jump_prev_field_end = { '<S-Tab>', mode = { 'n', 'v' } },
  },
})
