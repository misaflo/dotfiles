-- Git integration: signs, hunk actions, blame, etc.
return {
  'lewis6991/gitsigns.nvim',
  opts = {
    on_attach = function(bufnr)
      local gitsigns = require('gitsigns')

      -- Navigation
      vim.keymap.set('n', ']c', function()
        if vim.wo.diff then
          vim.cmd.normal({ ']c', bang = true })
        else
          gitsigns.nav_hunk('next')
        end
      end)

      vim.keymap.set('n', '[c', function()
        if vim.wo.diff then
          vim.cmd.normal({ '[c', bang = true })
        else
          gitsigns.nav_hunk('prev')
        end
      end)

      -- Actions
      vim.keymap.set('n', '<leader>gb', gitsigns.toggle_current_line_blame)
      vim.keymap.set('n', '<leader>gB', function()
        gitsigns.blame_line({ full = true })
      end)
      vim.keymap.set('n', '<leader>gd', gitsigns.diffthis)
      vim.keymap.set('n', '<leader>gr', gitsigns.reset_hunk)
      vim.keymap.set('v', '<leader>gr', function()
        gitsigns.reset_hunk({ vim.fn.line('.'), vim.fn.line('v') })
      end)
    end,
  },
}
