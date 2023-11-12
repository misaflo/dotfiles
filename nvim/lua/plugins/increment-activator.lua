-- Enhance to increment/decrement (<C-a>, <C-x>)
return {
  'nishigori/increment-activator',
  keys = { '<C-a>', '<C-x>' },
  config = function()
    vim.g.increment_activator_filetype_candidates = {
      puppet = {
        { 'present', 'absent' },
        { 'running', 'stopped' },
        { 'installed', 'purged' },
        { 'file', 'directory', 'link' },
      },
    }
  end,
}
