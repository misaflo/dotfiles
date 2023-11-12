local opt = vim.opt

vim.g.mapleader = ','

opt.termguicolors = true
opt.number = true
opt.foldenable = false -- Disable folding
opt.splitbelow = true -- Split at the bottom
opt.splitright = true -- Vsplit at the right
opt.showmatch = true -- When a bracket is inserted, briefly jump to the matching one
opt.scrolloff = 2 -- Minimal number of screen lines to keep above and below the cursor
opt.cursorline = true -- Highlight the screen line of the cursor
opt.ignorecase = true -- Ignoring case in a pattern
opt.smartcase = true -- Ignore uppercase letters unless the search term has an uppercase letter
opt.smartindent = true -- Do smart autoindenting when starting a new line
opt.tabstop = 2 -- Number of spaces that a <Tab> in the file counts for
opt.shiftwidth = 2 -- Alignment with '<' and '>'
opt.expandtab = true -- Use spaces instead of tab
opt.list = true -- Show hidden characters
opt.title = true -- Show the title of the window
opt.mouse = '' -- Disable mouse

-- Spellcheck
opt.spellsuggest:prepend({ 5 })
opt.dictionary = '/usr/share/dict/words' -- For completion of words (<C-x><C-k>)

if opt.diff:get() then
  opt.cursorline = false
end
