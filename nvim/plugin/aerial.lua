-- Outline window for quick navigation
vim.pack.add({ 'https://github.com/stevearc/aerial.nvim' })

require('aerial').setup()
vim.keymap.set('n', '<F9>', ':AerialToggle<CR>')
