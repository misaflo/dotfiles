-- Enhance to increment/decrement (<C-a>, <C-x>)
vim.pack.add({ 'https://github.com/nishigori/increment-activator' })

vim.g.increment_activator_filetype_candidates = {
  puppet = {
    { 'present', 'absent' },
    { 'running', 'stopped' },
    { 'installed', 'purged' },
    { 'file', 'directory', 'link' },
  },
}
