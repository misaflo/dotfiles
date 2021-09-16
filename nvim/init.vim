"====================
" Plugins (vim-plug)
"====================

call plug#begin()

Plug 'junegunn/fzf'
Plug 'junegunn/fzf.vim'
Plug 'dense-analysis/ale'
Plug 'majutsushi/tagbar', { 'on': 'TagbarToggle' } " require exuberant-ctags or universal-ctags
Plug 'hoob3rt/lualine.nvim'
Plug 'romgrk/barbar.nvim'
Plug 'mg979/vim-visual-multi'
Plug 'mhinz/vim-signify'
Plug 'tpope/vim-fugitive'
Plug 'SirVer/ultisnips' | Plug 'honza/vim-snippets'
Plug 'junegunn/vim-easy-align'
Plug 'othree/html5.vim'
Plug 'ap/vim-css-color'
Plug 'pangloss/vim-javascript'
Plug '1995eaton/vim-better-javascript-completion'
Plug 'vim-ruby/vim-ruby'
Plug 'noprompt/vim-yardoc'
Plug 'scrooloose/nerdcommenter'
Plug 'scrooloose/nerdtree', { 'on': 'NERDTreeToggle' }
Plug 'gruvbox-community/gruvbox'
Plug 'previm/previm'
Plug 'dpelle/vim-Grammalecte'
Plug 'rodjek/vim-puppet'
Plug 'tpope/vim-markdown'
Plug 'dhruvasagar/vim-table-mode'
Plug 'tpope/vim-surround'
Plug 'nishigori/increment-activator'
Plug 'jeffkreeftmeijer/vim-numbertoggle'
Plug 'cespare/vim-toml'

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
set hidden            " Buffer becomes hidden when it is abandoned

" Highlighted off
nmap <silent> <leader><space> :noh<CR>

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

" Live substitution
set inccommand=nosplit

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
" PHP
"====================

let php_sql_query=1       " SQL syntax highlighting inside Strings
let php_htmlInStrings=1   " Enable HTML syntax highlighting inside strings

"====================
" Ruby
"====================

" see :help ft-ruby-omni

"autocmd FileType ruby,eruby let g:rubycomplete_rails = 1
"autocmd FileType ruby,eruby let g:rubycomplete_buffer_loading = 1 " This may cause some code execution
"autocmd FileType ruby,eruby let g:rubycomplete_classes_in_global = 1
"autocmd FileType ruby,eruby let g:rubycomplete_include_object = 1
"autocmd FileType ruby,eruby let g:rubycomplete_include_objectspace = 1
let ruby_spellcheck_strings = 1

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

" fzf
let g:fzf_layout = { 'window': { 'width': 0.9, 'height': 0.8 } }
let g:fzf_preview_window = ['right:50%:hidden', 'ctrl-/']
noremap <silent> <leader>f :Files<CR>

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

" vim-signify
let g:signify_vcs_list = [ 'git' ]

" ultisnips
let g:UltiSnipsExpandTrigger="<tab>"
let g:UltiSnipsJumpForwardTrigger="<c-b>"
let g:UltiSnipsJumpBackwardTrigger="<c-z>"

" tagbar
nmap <F8> :TagbarToggle<CR>

" vim-javascript
let g:javascript_plugin_jsdoc = 1 " Enables syntax highlighting for JSDocs

" easy-align
" Start interactive EasyAlign in visual mode (e.g. vip<Enter>)
vmap <Enter> <Plug>(EasyAlign)

" nerdcommenter
nnoremap <leader>c :call nerdcommenter#Comment(0,"toggle")<CR>
vnoremap <leader>c :call nerdcommenter#Comment(0,"toggle")<CR>

" nerdtree
nmap <F9> :NERDTreeToggle<CR>
" Close vim if the only window left open is a NERDTree
autocmd bufenter * if (winnr("$") == 1 && exists("b:NERDTree") && b:NERDTree.isTabTree()) | q | endif

" previm (markdown preview)
let g:previm_open_cmd = 'xdg-open'

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
require'lualine'.setup {
  options = {
    icons_enabled = false,
    theme = 'gruvbox',
    component_separators = {'|', '|'},
    section_separators = {'', ''},
  }
}
EOF
