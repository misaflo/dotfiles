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
opt.breakindent = true -- Preserve horizontal blocks for wrapped lines
opt.tabstop = 2 -- Number of spaces that a <Tab> in the file counts for
opt.shiftwidth = 2 -- Alignment with '<' and '>'
opt.expandtab = true -- Use spaces instead of tab
opt.list = true -- Show hidden characters
opt.title = true -- Show the title of the window
opt.grepprg = 'rg --vimgrep' -- Use default rg options

-- Spellcheck
opt.spelllang = 'fr'
opt.spellsuggest:prepend({ 5 })
opt.dictionary = '/usr/share/dict/words' -- For completion of words (<C-x><C-k>)

if opt.diff:get() then
  opt.cursorline = false
end

vim.diagnostic.config({ virtual_lines = { current_line = true } })

-- Completion
opt.pumborder = 'rounded' -- Border style of popupmenu windows
opt.pummaxwidth = 45 -- Maximum width for the popup menu
opt.pumheight = 10 -- Maximum number of items to show in the popup menu
opt.completeopt = 'menuone,popup,noselect' -- Options for Insert mode completion

-- Enable autocompletion for LSP
vim.api.nvim_create_autocmd('LspAttach', {
  callback = function(ev)
    local client = vim.lsp.get_client_by_id(ev.data.client_id)
    if client ~= nil and client:supports_method('textDocument/completion') then
      vim.lsp.completion.enable(true, client.id, ev.buf, {
        autotrigger = true,
        convert = function(item)
          -- Remove parameters (already in popupmenu)
          -- https://www.reddit.com/r/neovim/comments/1mglgn4/simple_native_autocompletion_with_autocomplete/
          local abbr = item.label
          abbr = abbr:gsub('%b()', ''):gsub('%b{}', '')
          -- abbr = abbr:match('[%w.]+.*') or abbr
          -- Remove return value
          local menu = ''

          return { abbr = abbr, menu = menu }
        end,
      })
    end
  end,
  group = vim.api.nvim_create_augroup('misaflo_lsp_completion', { clear = true }),
})
