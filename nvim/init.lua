-------------------- HELPERS -------------------------------
local opt     = vim.opt
local g       = vim.g
local map     = vim.keymap.set
local autocmd = vim.api.nvim_create_autocmd
local cmd     = vim.cmd

local function augroup(group)
  vim.api.nvim_create_augroup(group, { clear = true })
end


-------------------- OPTIONS -------------------------------
g.mapleader       = ','

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
opt.mouse         = ''    -- Disable mouse

if opt.diff:get() then
  opt.cursorline = false
end

-- Spellcheck
opt.spellsuggest:prepend { 5 }
opt.dictionary = '/usr/share/dict/words' -- For completion of words (<C-x><C-k>)


------------------- FUNCTIONS ------------------------------
function ldap_lookup()
  cmd "let @a = system('ldap_search_email '.expand('<cword>'))"
end


-------------------- AUTOCMD -------------------------------
augroup('Eyaml')
autocmd('BufEnter', {
  pattern = '*.eyaml',
  command = 'set filetype=yaml',
  group   = 'Eyaml',
})

augroup('TermConfig')
autocmd('TermOpen', {
  desc    = 'Disable line number in terminal-mode',
  pattern = '*',
  command = 'setlocal nonumber norelativenumber',
  group   = 'TermConfig',
})

augroup('TextYanked')
autocmd('TextYankPost', {
  desc    = 'Highlight yanked region',
  pattern = '*',
  command = 'lua vim.highlight.on_yank{higroup="Search", timeout=700}',
  group   = 'TextYanked',
})

augroup('PackerUserConfig')
autocmd('BufWritePost', {
  desc    = 'Source and compile Packer config',
  pattern = 'nvim/init.lua',
  command = 'source ~/.config/nvim/init.lua | PackerCompile',
  group   = 'PackerUserConfig',
})
autocmd('BufWinLeave', {
  desc    = 'Wait for compilation of Packer config',
  pattern = 'nvim/init.lua',
  command = 'sleep 100m',
  group   = 'PackerUserConfig',
})


-------------------- MAPPINGS ------------------------------
-- Copy to clipboard, past from clipboard
map('', '<leader>y', '"+y')
map('n', '<leader>p', '"+p')

-- Email Signature
map('n', '<Leader>sd', ':read ~/.config/neomutt/signature_dio<CR>')
map('n', '<Leader>sp', ':read ~/.config/neomutt/signature_dio_permanence<CR>')
map('n', '<Leader>so', ':read ~/.config/neomutt/signature_obspm_dio<CR>')

-- Search email in LDAP
map('n', '<Leader>ls', ':lua ldap_lookup() <CR>:s/<C-R><C-W>/<C-R>a<BACKSPACE>/g<CR>:noh<CR>$')

-- Terminal
map('n', '<Leader>c', ':split +terminal<CR>:resize -4<CR>i')

-- Spellchecking
map('n', '<leader>lf', ':set spell spelllang=fr<CR>')
map('n', '<leader>le', ':set spell spelllang=en<CR>')
map('n', '<leader>ln', ':set nospell<CR>')

-- Resize with arrows
map('n', '<C-Up>', ':resize -2<CR>')
map('n', '<C-Down>', ':resize +2<CR>')
map('n', '<C-Left>', ':vertical resize -2<CR>')
map('n', '<C-Right>', ':vertical resize +2<CR>')


-------------------- PLUGINS -------------------------------
require('packer').startup(function(use)
  -- Plugin manager
  use 'wbthomason/packer.nvim'

  -- Color scheme
  use {
    'sainnhe/gruvbox-material',
    config = function()
      vim.g.gruvbox_material_better_performance = true
      vim.g.gruvbox_material_foreground = 'original'
      vim.cmd 'colorscheme gruvbox-material'
    end,
  }

  -- Icons configuration for plugins
  use {
    'nvim-tree/nvim-web-devicons',
    config = function()
      require('nvim-web-devicons').setup {
        color_icons = false,
      }
    end,
  }


  -- Treesitter configurations and abstraction layer
  use {
    'nvim-treesitter/nvim-treesitter',
    run = ':TSUpdate',
    config = function()
      require('nvim-treesitter.configs').setup {
        highlight = {
          enable = true,
        },
      }
    end,
  }

  -- Fuzzy finder FZF
  use {
    'ibhagwan/fzf-lua',
    cmd = 'FzfLua',
    config = function()
      require('fzf-lua').setup {
        keymap = {
          builtin = {
            ['<A-j>'] = 'preview-page-down',
            ['<A-k>'] = 'preview-page-up',
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
  map('n', '<leader>ff', ':FzfLua files<CR>')
  map('n', '<leader>fg', ':FzfLua live_grep<CR>')

  -- Status line
  use {
    'nvim-lualine/lualine.nvim',
    config = function()
      require('lualine').setup {
        options = {
          icons_enabled = false,
          theme = 'gruvbox-material',
          component_separators = { '|', '|' },
          section_separators = { '', '' },
        },
      }
    end,
  }

  -- Tabline
  use {
    'romgrk/barbar.nvim',
    requires = 'nvim-web-devicons',
    config = function()
      require('bufferline').setup {
        auto_hide = true,
        closable = false,
      }
      vim.keymap.set('n', '<A-a>', ':BufferPrevious<CR>')
      vim.keymap.set('n', '<A-z>', ':BufferNext<CR>')
      vim.keymap.set('n', '<A-A>', ':BufferMovePrevious<CR>')
      vim.keymap.set('n', '<A-Z>', ':BufferMoveNext<CR>')
      vim.keymap.set('n', '<A-p>', ':BufferPin<CR>')
      vim.keymap.set('n', '<A-c>', ':BufferClose<CR>')
    end,
  }

  -- Syntax checking (linting)
  use {
    'dense-analysis/ale',
    config = function()
      vim.g.ale_use_neovim_diagnostics_api = true
      vim.g.ale_fixers = {
        ['*']  = { 'remove_trailing_lines', 'trim_whitespace' },
        ruby   = { 'rubocop' },
        puppet = { 'puppetlint' },
      }
      vim.keymap.set('n', '<C-k>', ':ALEPreviousWrap<CR>')
      vim.keymap.set('n', '<C-j>', ':ALENextWrap<CR>')
      vim.keymap.set('n', '<leader>at', ':ALEToggle<CR>')
      vim.keymap.set('n', '<leader>af', ':ALEFix<CR>')
    end,
  }

  -- French grammar checker
  use {
    'dpelle/vim-Grammalecte',
    cmd = 'GrammalecteCheck',
    config = function()
      vim.g.grammalecte_cli_py = '~/.dotfiles/nvim/grammalecte/grammalecte-cli.py'
      vim.g.grammalecte_disable_rules = 'typo_tiret_début_ligne typo_tiret_incise2' ..
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
      vim.cmd 'highlight link GrammalecteGrammarError spellCap'
      vim.cmd 'highlight link GrammalecteSpellingError spellBad'
      vim.keymap.set('n', '<leader>gl', ':GrammalecteClear<CR>')
    end,
  }
  map('n', '<leader>gc', ':GrammalecteCheck<CR>')

  -- Alignment
  use {
    'junegunn/vim-easy-align',
    cmd = 'EasyAlign',
  }
  map('v', '<Enter>', ':EasyAlign<CR>')

  -- Color name highlighter
  use {
    'NvChad/nvim-colorizer.lua',
    config = function()
      require('colorizer').setup()
    end,
  }

  -- Comment
  use {
    'numToStr/Comment.nvim',
    config = function()
      require('Comment').setup()
    end,
  }

  -- Add/change/delete surrounding delimiter pairs
  use {
    'kylechui/nvim-surround',
    config = function()
      require('nvim-surround').setup {
        surrounds = {
          ['«'] = {
            add = { '« ', ' »'}
          },
          ['»'] = {
            add = { '«', '»'}
          },
        },
      }
    end,
  }

  -- Enhance to increment/decrement (<C-a>, <C-x>)
  use {
    'nishigori/increment-activator',
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

  -- Toggles between hybrid and absolute line numbers automatically
  use 'jeffkreeftmeijer/vim-numbertoggle'

  -- Autodect and cd to project directory
  use {
    'ahmedkhalf/project.nvim',
    config = function()
      require('project_nvim').setup {
        detection_methods = { 'pattern' },
        patterns = { '.git' },
      }
    end,
  }

  -- Outline window for quick navigation
  use {
    'stevearc/aerial.nvim',
    cmd = 'AerialToggle',
    config = function()
      require('aerial').setup()
    end,
  }
  map('n', '<F9>', ':AerialToggle<CR>')

  -- Better '%' navigation and highlight matching words
  use 'andymass/vim-matchup'

  ----------------------------------------
  ----------------- Git ------------------
  ----------------------------------------

  -- Git integration: signs, hunk actions, blame, etc.
  use {
    'lewis6991/gitsigns.nvim',
    config = function()
      require('gitsigns').setup {
        signs = {
          add    = { hl = 'GitSignsAdd'   , text = '+', numhl='GitSignsAddNr'   , linehl='GitSignsAddLn' },
          change = { hl = 'GitSignsChange', text = '~', numhl='GitSignsChangeNr', linehl='GitSignsChangeLn' },
        },
      }
      vim.keymap.set('n', '<leader>gb', ":lua require('gitsigns').toggle_current_line_blame()<CR>")
      vim.keymap.set('n', '<leader>gd', ":lua require('gitsigns').diffthis()<CR>")
      vim.keymap.set('n', '<leader>gm', ":lua require('gitsigns').blame_line{full=true}<CR>")
    end,
  }

  -- Magit clone: stage, commit, pull, push
  use {
    'TimUntersberger/neogit',
    requires = 'nvim-lua/plenary.nvim',
    cmd = 'Neogit',
    config = function()
      require('neogit').setup {
        disable_commit_confirmation = true,
      }
    end,
  }
  map('n', '<leader>gg', ':Neogit<CR>')

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
              { name = 'snippy' }
            }
          }
        }
      end
      vim.keymap.set('i',  '<C-x><C-s>', '<Cmd>lua vimrc.cmp.snippet()<CR>')
    end,
  }

  ----------------------------------------
  --------------- Markdown ---------------
  ----------------------------------------

  -- Markdown runtime files (more up to date)
  use {
    'tpope/vim-markdown',
    ft = 'markdown',
    setup = function()
      vim.g.markdown_fenced_languages = { 'sh', 'bash=sh', 'sql' }
    end,
  }

  -- Preview markdown in browser
  use {
    'iamcco/markdown-preview.nvim',
    run = 'cd app && yarn install',
    ft = 'markdown',
    config = function()
      vim.g.mkdp_theme = 'light'
    end,
  }

  -- Table creator and formatter
  use {
    'dhruvasagar/vim-table-mode',
    cmd = 'TableModeToggle',
    config = function()
      vim.g.table_mode_corner = '|' -- markdown-compatible tables
    end,
  }
  map('n', '<leader>tm', ':TableModeToggle<CR>')

  -- Management of markdown notebooks
  use {
    'jakewvincent/mkdnflow.nvim',
    ft = 'markdown',
    config = function()
      require('mkdnflow').setup {
        modules = {
          bib = false,
          buffers = false,
          conceal = false,
          folds = false,
          tables = false
        },
        filetypes = { md = true, mdwn = true, markdown = true },
        links = {
          transform_implicit = false,
          transform_explicit = function(text)
            text = text:gsub(" ", "-")
            text = text:lower()
            return(text)
          end
        },
      }
    end,
  }

  ----------------------------------------
  ---------------- Puppet ----------------
  ----------------------------------------

  -- Make vim more Puppet friendly
  use {
    'rodjek/vim-puppet',
    ft = 'puppet',
  }

  -- Syntax for highlighting YARD documentation
  use {
    'noprompt/vim-yardoc',
    ft = 'puppet',
  }
end)
