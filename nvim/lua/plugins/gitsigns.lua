-- Git integration: signs, hunk actions, blame, etc.
return {
  'lewis6991/gitsigns.nvim',
  opts = {
    on_attach = function(bufnr)
      local gs = package.loaded.gitsigns

      -- Navigation
      vim.keymap.set('n', ']c', function()
        if vim.wo.diff then
          return ']c'
        end
        vim.schedule(function()
          gs.next_hunk()
        end)
        return '<Ignore>'
      end, { expr = true })

      vim.keymap.set('n', '[c', function()
        if vim.wo.diff then
          return '[c'
        end
        vim.schedule(function()
          gs.prev_hunk()
        end)
        return '<Ignore>'
      end, { expr = true })

      -- Actions
      vim.keymap.set('n', '<leader>gb', gs.toggle_current_line_blame)
      vim.keymap.set('n', '<leader>gd', gs.diffthis)
    end,
  },
}
