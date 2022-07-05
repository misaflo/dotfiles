-------------------- HELPERS -------------------------------
local opt = vim.opt
local g   = vim.g
local cmd = vim.cmd
local map = vim.keymap.set


-------------------- OPTIONS -------------------------------
g.mapleader       = ','

g.gruvbox_italic  = true
cmd 'colorscheme gruvbox'

opt.termguicolors = true
opt.number        = true
opt.foldenable    = false -- Disable folding
opt.splitbelow    = true  -- Split at the bottom
opt.splitright    = true  -- Vsplit at the right
opt.showmatch     = true  -- When a bracket is inserted, briefly jump to the matching one
opt.scrolloff     = 2     -- Minimal number of screen lines to keep above and below the cursor
opt.cursorline    = true  -- Highlight the screen line of the cursor
opt.ignorecase    = true  -- Ignoring case in a pattern
opt.smartcase     = true  -- Ignore uppercase letters unless the search term has an uppercase letter
opt.smartindent   = true  -- Do smart autoindenting when starting a new line
opt.tabstop       = 2     -- Number of spaces that a <Tab> in the file counts for
opt.shiftwidth    = 2     -- Alignment with '<' and '>'
opt.expandtab     = true  -- Use spaces instead of tab
opt.list          = true  -- Show hidden characters
opt.title         = true  -- Show the title of the window

opt.spellsuggest:prepend { 5 }
opt.dictionary = '/usr/share/dict/words' -- For completion of words (<C-x><C-k>)

if vim.opt.diff:get() then
  opt.cursorline = false
end

cmd 'highlight SpellBad gui=underline guifg=#fb4934'
cmd 'highlight SpellCap gui=underline guifg=#83a598'

cmd 'autocmd BufEnter todo set syntax=todo'
cmd 'autocmd FileType mail set spell spelllang=fr syntax=mailrt' -- Custom syntax for Request Tracker
cmd 'autocmd TermOpen * setlocal nonumber norelativenumber'      -- Disable line number in terminal-mode


-------------------- MAPPINGS ------------------------------
map('', '<leader>y', '"+y')  -- Copy to clipboard
map('n', '<leader>p', '"+p') -- Past from clipboard

-- Email Signature
map('n', '<Leader>sd', ':read ~/.config/neomutt/signature_dio<CR>')
map('n', '<Leader>sp', ':read ~/.config/neomutt/signature_dio_permanence<CR>')
map('n', '<Leader>so', ':read ~/.config/neomutt/signature_obspm_dio<CR>')

-- Search email in LDAP
function LDAPLookup()
  cmd "let @a = system('ldap_search_email '.expand('<cword>'))"
end
map('n', '<Leader>ls', ':lua LDAPLookup() <CR>:s/<C-R><C-W>/<C-R>a<BACKSPACE>/g<CR>:noh<CR>$')

-- Terminal
map('n', '<Leader>c', ':split +terminal<CR>:resize -4<CR>i')

-- Spellchecking
map('n', '<leader>lf', ':set spell spelllang=fr<cr>')
map('n', '<leader>le', ':set spell spelllang=en<cr>')
map('n', '<leader>ln', ':set nospell<cr>')

-- Resize with arrows
map('n', '<C-Up>', ':resize -2<CR>')
map('n', '<C-Down>', ':resize +2<CR>')
map('n', '<C-Left>', ':vertical resize -2<CR>')
map('n', '<C-Right>', ':vertical resize +2<CR>')


-------------------- PLUGINS -------------------------------
require('packer').startup(function()
  -- Plugin manager
  use 'wbthomason/packer.nvim'

  -- Color scheme
  use 'gruvbox-community/gruvbox'

  -- Fuzzy finder FZF
  use {
    'ibhagwan/fzf-lua',
    requires = {'vijaymarupudi/nvim-fzf'},
    config = function()
      require('fzf-lua').setup {
        keymap = {
          builtin = {
            ['<C-l>'] = 'preview-page-down',
            ['<C-h>'] = 'preview-page-up',
          },
        },
        files = {
          git_icons = false,
          file_icons = false,
          actions = {
            ['default'] = require('fzf-lua.actions').file_edit,
          },
        },
      }
    end,
  }
  map('n', '<leader>ff', "<cmd>lua require('fzf-lua').files()<CR>")
  map('n', '<leader>fg', "<cmd>lua require('fzf-lua').live_grep()<CR>")

  -- Status line
  use {
    'nvim-lualine/lualine.nvim',
    config = function()
      require('lualine').setup {
        options = {
          icons_enabled = false,
          theme = 'gruvbox',
          component_separators = {'|', '|'},
          section_separators = {'', ''},
        },
      }
    end,
  }

  -- Tabline
  use 'romgrk/barbar.nvim'
  g.bufferline = {
    closable = false,
    icons = false,
    auto_hide = true,
  }
  map('n', '<A-a>', ':BufferPrevious<CR>')
  map('n', '<A-z>', ':BufferNext<CR>')
  map('n', '<A-A>', ':BufferMovePrevious<CR>')
  map('n', '<A-Z>', ':BufferMoveNext<CR>')
  map('n', '<A-p>', ':BufferPin<CR>')
  map('n', '<A-c>', ':BufferClose<CR>')

  -- Git decorations
  use {
    'lewis6991/gitsigns.nvim',
    requires = {'nvim-lua/plenary.nvim'},
    config = function()
      require('gitsigns').setup {
        signs = {
          add    = {hl = 'GitSignsAdd'   , text = '+', numhl='GitSignsAddNr'   , linehl='GitSignsAddLn'},
          change = {hl = 'GitSignsChange', text = '~', numhl='GitSignsChangeNr', linehl='GitSignsChangeLn'},
        },
      }
    end,
  }
  cmd 'highlight link GitSignsCurrentLineBlame Comment' -- https://github.com/lewis6991/gitsigns.nvim/issues/255
  map('n', '<leader>hb', '<cmd>lua require"gitsigns".blame_line{full=true}<CR>')
  map('n', '<leader>tb', '<cmd>Gitsigns toggle_current_line_blame<CR>')

  -- Syntax checking (linting)
  use 'dense-analysis/ale'
  map('n', '<C-k>', ':ALEPreviousWrap<CR>')
  map('n', '<C-j>', ':ALENextWrap<CR>')
  cmd([[
    let g:ale_fixers = {
    \   '*':      ['remove_trailing_lines', 'trim_whitespace'],
    \   'ruby':   ['rubocop'],
    \   'puppet': ['puppetlint'],
    \ }
  ]])

  -- French grammar checker 
  use 'dpelle/vim-Grammalecte'
  g.grammalecte_cli_py = '~/.dotfiles/nvim/grammalecte/grammalecte-cli.py'
  g.grammalecte_disable_rules = 'typo_tiret_début_ligne typo_tiret_incise2' ..
    ' apostrophe_typographique apostrophe_typographique_après_t' ..
    ' espaces_début_ligne espaces_milieu_ligne espaces_fin_de_ligne' ..
    ' esp_début_ligne esp_milieu_ligne esp_fin_ligne esp_mélangés2' ..
    ' typo_points_suspension1 typo_tiret_incise' ..
    ' nbsp_avant_double_ponctuation nbsp_avant_deux_points' ..
    ' nbsp_après_chevrons_ouvrants nbsp_avant_chevrons_fermants1' ..
    ' unit_nbsp_avant_unités1 unit_nbsp_avant_unités2' ..
    ' unit_nbsp_avant_unités3 typo_guillemets_typographiques_doubles_ouvrants' ..
    ' typo_guillemets_typographiques_doubles_fermants' ..
    ' typo_tiret_incise1'
  cmd 'highlight GrammalecteGrammarError  gui=underline guifg=#83a598'
  cmd 'highlight GrammalecteSpellingError gui=underline guifg=#fb4934'
  map('n', '<leader>gc', ':GrammalecteCheck<CR>')
  map('n', '<leader>gl', ':GrammalecteClear<CR>')

  -- Alignment 
  use 'junegunn/vim-easy-align'
  map('v', '<Enter>', ':EasyAlign<CR>')

  -- Color name highlighter
  use 'ap/vim-css-color'


  -- Comment
  use {
    'numToStr/Comment.nvim',
    config = function()
      require('Comment').setup()
    end,
  }

  -- Autopairs
  use {
    'windwp/nvim-autopairs',
    config = function()
      require('nvim-autopairs').setup()

      local Rule = require('nvim-autopairs.rule')
      local npairs = require('nvim-autopairs')
      npairs.add_rule(Rule('« ',' »'))
    end,
  }

  -- Add/change/delete surrounding delimiter pairs
  use {
    'kylechui/nvim-surround',
    config = function()
      require('nvim-surround').setup()
    end,
  }

  -- Enhance to increment/decrement (<C-a>, <C-x>)
  use 'nishigori/increment-activator'
  g.increment_activator_filetype_candidates = {
    puppet = {
      {'present', 'absent'},
      {'running', 'stopped'},
      {'installed', 'purged'},
    },
  }

  -- Toggles between hybrid and absolute line numbers automatically
  use 'jeffkreeftmeijer/vim-numbertoggle'

  ----------------------------------------
  --------------- Snippets ---------------
  ----------------------------------------

  -- Snippet engine
  use {
    'dcampos/nvim-snippy',
    config = function()
      require('snippy').setup {
        mappings = {
          is = {
            ['<Tab>'] = 'expand',
            ['<C-j>'] = 'next',
            ['<C-k>'] = 'previous',
          },
        },
      }
    end,
  }

  --- Snippets source
  use 'honza/vim-snippets'

  -- Completion for snippets with <C-x><C-s>
  use 'dcampos/cmp-snippy'
  use {
    'hrsh7th/nvim-cmp',
    config = function()
      local cmp = require('cmp')

      cmp.setup({
        completion = {
          autocomplete = false,
        },
        snippet = {
          expand = function(args)
            require('snippy').expand_snippet(args.body) -- For `snippy` users.
          end,
        },
        mapping = cmp.mapping.preset.insert({
          ['<C-b>'] = cmp.mapping.scroll_docs(-4),
          ['<C-f>'] = cmp.mapping.scroll_docs(4),
          ['<C-Space>'] = cmp.mapping.complete(),
          ['<C-e>'] = cmp.mapping.abort(),
          ['<CR>'] = cmp.mapping.confirm({ select = true }),
        }),
        sources = cmp.config.sources({
          { name = 'snippy' },
        }, {
          { name = 'buffer' },
        })
      })

      _G.vimrc = _G.vimrc or {}
      _G.vimrc.cmp = _G.vimrc.cmp or {}
      _G.vimrc.cmp.snippet = function()
        cmp.complete {
          config = {
            sources = {
              {name = 'snippy'}
            }
          }
        }
      end
    end,
  }
  map('i',  '<C-x><C-s>', '<Cmd>lua vimrc.cmp.snippet()<CR>')

  ----------------------------------------
  --------------- Markdown ---------------
  ----------------------------------------

  -- Markdown runtime files (more up to date)
  use 'tpope/vim-markdown'
  g.markdown_fenced_languages = {'sh', 'bash=sh', 'sql'}

  -- Preview markdown in browser
  use {
    'iamcco/markdown-preview.nvim',
    run = 'cd app && yarn install',
    ft = 'markdown',
  }
  g.mkdp_theme = 'light'

  -- Table creator and formatter
  use 'dhruvasagar/vim-table-mode'
  map('n', '<leader>tm', ':TableModeToggle<CR>')
  g.table_mode_corner = '|' -- markdown-compatible tables

  ----------------------------------------
  ---------------- Puppet ----------------
  ----------------------------------------

  -- Make vim more Puppet friendly
  use 'rodjek/vim-puppet'

  -- Syntax for highlighting YARD documentation
  use 'noprompt/vim-yardoc'
  cmd([[
    autocmd Filetype puppet highlight link yardGenericTag PreProc
    autocmd Filetype ruby call SetRubyYard()

    function SetRubyYard()
      hi link yardGenericTag  rubyInstanceVariable
      hi link yardType        Type
      hi link yardLiteral     Type
    endfunction
  ]])
end)
