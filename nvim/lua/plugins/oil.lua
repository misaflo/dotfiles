-- File explorer: edit your filesystem like a buffer
return {
  'stevearc/oil.nvim',
  dependencies = { 'nvim-tree/nvim-web-devicons' },
  config = function()
    function _G.get_oil_winbar()
      local dir = require('oil').get_current_dir()
      if dir then
        return vim.fn.fnamemodify(dir, ':~')
      else
        -- If there is no current directory (e.g. over ssh), just show the buffer name
        return vim.api.nvim_buf_get_name(0)
      end
    end

    require('oil').setup({
      win_options = {
        winbar = '%!v:lua.get_oil_winbar()',
      },
    })

    vim.keymap.set('n', '-', ':Oil<CR>')
  end,
}
