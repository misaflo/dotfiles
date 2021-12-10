"====================
" Plugins (vim-plug)
"====================

call plug#begin()

Plug 'ibhagwan/fzf-lua' | Plug 'vijaymarupudi/nvim-fzf'
Plug 'dense-analysis/ale'
Plug 'nvim-lualine/lualine.nvim'
Plug 'romgrk/barbar.nvim'
Plug 'mg979/vim-visual-multi'
Plug 'lewis6991/gitsigns.nvim' | Plug 'nvim-lua/plenary.nvim'
Plug 'SirVer/ultisnips' | Plug 'honza/vim-snippets'
Plug 'junegunn/vim-easy-align'
Plug 'ap/vim-css-color'
Plug 'noprompt/vim-yardoc'
Plug 'numToStr/Comment.nvim'
Plug 'gruvbox-community/gruvbox'
Plug 'iamcco/markdown-preview.nvim', { 'do': 'cd app && yarn install' }
Plug 'dpelle/vim-Grammalecte'
Plug 'rodjek/vim-puppet'
Plug 'tpope/vim-markdown'
Plug 'dhruvasagar/vim-table-mode'
Plug 'tpope/vim-surround'
Plug 'nishigori/increment-activator'
Plug 'jeffkreeftmeijer/vim-numbertoggle'

call plug#end()

"====================
" General
"====================

let mapleader=","
let g:gruvbox_italic=1
colorscheme gruvbox

set number
set nofoldenable      " Disable folding
set splitbelow        " Split at the bottom
set splitright        " Vsplit at the right

set showmatch         " When a bracket is inserted, briefly jump to the matching one
set scrolloff=2       " Minimal number of screen lines to keep above and below the cursor
set cursorline        " Highlight the screen line of the cursor
set mouse=n           " Enable Mouse en normal mode.
set ignorecase        " Ignoring case in a pattern

set smartindent       " Do smart autoindenting when starting a new line
set tabstop=2         " Number of spaces that a <Tab> in the file counts for
set shiftwidth=2      " Alignment with '<' and '>'
set expandtab         " Use spaces instead of tab

hi SpellBad gui=underline guifg=#fb4934
hi SpellCap gui=underline guifg=#83a598

if &diff
  set cursorline!
endif

noremap <leader>y "+y
noremap <leader>p "+p

" Show special characters
" Insert a non-breaking space: <C-k> <space> <space>
set list
set listchars=tab:>\ ,trail:\ ,nbsp:+
highlight NoSpacesEOL ctermbg=red ctermfg=white guibg=#592929
match NoSpacesEOL / \+$/

" 24-bit color
if has("termguicolors")
  set termguicolors
endif

" :W sudo saves the file
command W w !sudo tee % > /dev/null

" Search email in LDAP
function LDAPLookup()
  let @a = system('ldap_search_email '.expand('<cword>'))
endfunction
nmap <Leader>ls :call LDAPLookup() <CR>:s/<C-R><C-W>/<C-R>a<BACKSPACE>/g<CR>:noh<CR>$

nmap <Leader>sd :read ~/.config/neomutt/signature_dio<CR>
nmap <Leader>sp :read ~/.config/neomutt/signature_dio_permanence<CR>
nmap <Leader>so :read ~/.config/neomutt/signature_obspm_dio<CR>

"====================
" Terminal
"====================

" Map <Esc> to exit terminal-mode
tnoremap <Esc> <C-\><C-n>
" Open a terminal at the bottom
map <Leader>t :belowright split +terminal<CR>:resize -4<CR>i
" Disable line number in terminal-mode
autocmd TermOpen * setlocal nonumber norelativenumber

"====================
" Syntax
"====================

autocmd BufEnter todo set syntax=todo

"====================
" Mail
"====================

autocmd FileType mail set spell spelllang=fr syntax=mailrt

"====================
" Completion
"====================

" For completion of words (ctrl + x ctrl + k)
set dictionary+=/usr/share/dict/words

"====================
" Spellchecking
"====================

" Vim spell checker (z=)
if has("spell")
  map <leader>lf :set spell spelllang=fr<cr>
  map <leader>le :set spell spelllang=en<cr>
  map <leader>ln :set nospell<cr>
endif

set spellsuggest=5

"====================
" Plugins configuration
"====================

" ale
nmap <silent> <C-k> <Plug>(ale_previous_wrap)
nmap <silent> <C-j> <Plug>(ale_next_wrap)
let g:ale_fixers = {
  \   '*':      ['remove_trailing_lines', 'trim_whitespace'],
  \   'ruby':   ['rubocop'],
  \   'puppet': ['puppetlint'],
  \ }

" vim-yardoc
autocmd Filetype puppet hi link yardGenericTag PreProc
autocmd Filetype ruby   call SetRubyYard()

function SetRubyYard()
  hi link yardGenericTag  rubyInstanceVariable
  hi link yardType        Type
  hi link yardLiteral     Type
endfunction

" ultisnips
let g:UltiSnipsExpandTrigger="<tab>"
let g:UltiSnipsJumpForwardTrigger="<c-b>"
let g:UltiSnipsJumpBackwardTrigger="<c-z>"

" easy-align
" Start interactive EasyAlign in visual mode (e.g. vip<Enter>)
vmap <Enter> <Plug>(EasyAlign)

" vim-Grammalecte
let g:grammalecte_cli_py='~/.dotfiles/nvim/grammalecte/grammalecte-cli.py'
let g:grammalecte_disable_rules='typo_tiret_début_ligne typo_tiret_incise2 '
  \ . 'apostrophe_typographique apostrophe_typographique_après_t '
  \ . 'espaces_début_ligne espaces_milieu_ligne espaces_fin_de_ligne '
  \ . 'esp_début_ligne esp_milieu_ligne esp_fin_ligne esp_mélangés2 '
  \ . 'typo_points_suspension1 typo_tiret_incise '
  \ . 'nbsp_avant_double_ponctuation nbsp_avant_deux_points '
  \ . 'nbsp_après_chevrons_ouvrants nbsp_avant_chevrons_fermants1 '
  \ . 'unit_nbsp_avant_unités1 unit_nbsp_avant_unités2 '
  \ . 'unit_nbsp_avant_unités3'
hi GrammalecteGrammarError  gui=underline guifg=#83a598
hi GrammalecteSpellingError gui=underline guifg=#fb4934
noremap <silent> <leader>gc :GrammalecteCheck<CR>
noremap <silent> <leader>gl :GrammalecteClear<CR>

" increment-activator
let g:increment_activator_filetype_candidates = {
  \   'puppet': [
  \     ['present', 'absent'],
  \     ['running', 'stopped'],
  \   ],
  \ }

" vim-markdown
let g:markdown_fenced_languages = ['sh', 'bash=sh', 'sql']

" vim-table-mode
nmap <leader>tm :TableModeToggle<CR>
let g:table_mode_corner='|' " markdown-compatible tables

" barbar
let bufferline = get(g:, 'bufferline', {})
let bufferline.icons = v:false
let bufferline.closable = v:false
let bufferline.auto_hide = v:true
nnoremap <silent> <A-a> :BufferPrevious<CR>
nnoremap <silent> <A-z> :BufferNext<CR>
nnoremap <silent> <A-A> :BufferMovePrevious<CR>
nnoremap <silent> <A-Z> :BufferMoveNext<CR>
nnoremap <silent> <A-p> :BufferPin<CR>
nnoremap <silent> <A-c> :BufferClose<CR>

lua << EOF
require('fzf-lua').setup {
  files = {
    git_icons = false,
    file_icons = false,
    actions = {
      ['default'] = require('fzf-lua.actions').file_edit,
    }
  },
}
vim.api.nvim_set_keymap('n', '<leader>ff', "<cmd>lua require('fzf-lua').files()<CR>",     { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<leader>fg', "<cmd>lua require('fzf-lua').live_grep()<CR>", { noremap = true, silent = true })

require('lualine').setup {
  options = {
    icons_enabled = false,
    theme = 'gruvbox',
    component_separators = {'|', '|'},
    section_separators = {'', ''},
  }
}

require('Comment').setup()

require('gitsigns').setup {
  signs = {
    add    = {hl = 'GitSignsAdd'   , text = '+', numhl='GitSignsAddNr'   , linehl='GitSignsAddLn'},
    change = {hl = 'GitSignsChange', text = '~', numhl='GitSignsChangeNr', linehl='GitSignsChangeLn'},
  },
}
vim.cmd('highlight link GitSignsCurrentLineBlame Comment') -- https://github.com/lewis6991/gitsigns.nvim/issues/255
EOF
