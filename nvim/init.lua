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

-- Search for visually selected text
-- https://vim.fandom.com/wiki/Search_for_visually_selected_text
-- https://github.com/neovim/neovim/issues/21676
-- map('v', '/', 'y/\\V<C-R>=escape(@",\'/\\\')<CR><CR>')
map('x', '*', [[y/\V<C-R>=substitute(escape(@", '/\'), '\n', '\\n', 'g')<NL>]])
map('x', '#', [[y?\V<C-R>=substitute(escape(@", '?\'), '\n', '\\n', 'g')<NL>]])


-------------------- PLUGINS -------------------------------

-- Install the package manager
local lazypath = vim.fn.stdpath('data') .. '/lazy/lazy.nvim'
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    'git',
    'clone',
    '--filter=blob:none',
    'https://github.com/folke/lazy.nvim.git',
    '--branch=stable', -- latest stable release
    lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)

require('lazy').setup({
  -- Color scheme
  {
    'sainnhe/gruvbox-material',
    lazy = false,
    priority = 1000,
    config = function()
      vim.g.gruvbox_material_better_performance = true
      vim.g.gruvbox_material_foreground = 'original'
      vim.cmd 'colorscheme gruvbox-material'
    end,
  },

  -- Icons for plugins
  {
    'nvim-tree/nvim-web-devicons',
    opts = { color_icons = false },
  },

  -- Treesitter configurations and abstraction layer
  {
    'nvim-treesitter/nvim-treesitter',
    build = ':TSUpdate',
    config = function()
      require('nvim-treesitter.configs').setup {
        highlight = {
          enable = true,
        },
        indent = {
          enable = true
        },
      }
    end,
  },

  -- Fuzzy finder FZF
  {
    'ibhagwan/fzf-lua',
    keys = {
      { '<leader>ff', ":lua require('fzf-lua').files()<CR>" },
      { '<leader>fg', ":lua require('fzf-lua').live_grep()<CR>" },
    },
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
        grep = {
          git_icons = false,
          file_icons = false,
        },
      }
    end,
  },

  -- Status line
  {
    'nvim-lualine/lualine.nvim',
    dependencies = 'nvim-tree/nvim-web-devicons',
    opts = {
      options = {
        icons_enabled = false,
        theme = 'gruvbox-material',
        section_separators = '',
        component_separators = '|',
      },
    },
  },

  -- Tabline
  {
    'romgrk/barbar.nvim',
    dependencies = 'nvim-tree/nvim-web-devicons',
    config = function()
      require('barbar').setup {
        auto_hide = true,
        icons = {
          button = false,
          modified = false,
        },
      }
      vim.keymap.set('n', '<A-a>', ':BufferPrevious<CR>')
      vim.keymap.set('n', '<A-z>', ':BufferNext<CR>')
      vim.keymap.set('n', '<A-A>', ':BufferMovePrevious<CR>')
      vim.keymap.set('n', '<A-Z>', ':BufferMoveNext<CR>')
      vim.keymap.set('n', '<A-p>', ':BufferPin<CR>')
      vim.keymap.set('n', '<A-c>', ':BufferClose<CR>')
    end,
  },

  -- Syntax checking (linting)
  {
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
  },

  -- French grammar checker
  {
    'dpelle/vim-Grammalecte',
    keys = {
      { '<leader>gc', ':GrammalecteCheck<CR>' },
      { '<leader>gl', ':GrammalecteClear<CR>' }
    },
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
    end,
  },

  -- Alignment
  {
    'junegunn/vim-easy-align',
    keys = { { '<Enter>', ':EasyAlign<CR>', mode = 'v' } },
  },

  -- Color name highlighter
  {
    'NvChad/nvim-colorizer.lua',
    config = true,
  },

  -- Comment
  {
    'numToStr/Comment.nvim',
    keys = { { 'gc', mode = { 'n', 'v' } } },
    config = true,
  },

  -- Add/change/delete surrounding delimiter pairs
  {
    'kylechui/nvim-surround',
    opts =  {
      surrounds = {
        ['«'] = {
          add = { '« ', ' »'}
        },
        ['»'] = {
          add = { '«', '»'}
        },
      },
    }
  },

  -- Enhance to increment/decrement (<C-a>, <C-x>)
  {
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
  },

  -- Toggles between hybrid and absolute line numbers automatically
  'jeffkreeftmeijer/vim-numbertoggle',

  -- Autodect and cd to project directory
  {
    'ahmedkhalf/project.nvim',
    config = function()
      require('project_nvim').setup {
        detection_methods = { 'pattern' },
        patterns = { '.git' },
      }
    end,
  },

  -- Outline window for quick navigation
  {
    'stevearc/aerial.nvim',
    keys = { { '<F9>', ':AerialToggle<CR>' } },
    config = true,
  },

  -- Better '%' navigation and highlight matching words
  'andymass/vim-matchup',

  ----------------------------------------
  ----------------- Git ------------------
  ----------------------------------------

  -- Git integration: signs, hunk actions, blame, etc.
  {
    'lewis6991/gitsigns.nvim',
    config = function()
      require('gitsigns').setup()
      vim.keymap.set('n', '<leader>gb', ":lua require('gitsigns').toggle_current_line_blame()<CR>")
      vim.keymap.set('n', '<leader>gd', ":lua require('gitsigns').diffthis()<CR>")
      vim.keymap.set('n', '<leader>gm', ":lua require('gitsigns').blame_line{full=true}<CR>")
    end,
  },

  -- Magit clone: stage, commit, pull, push
  {
    'TimUntersberger/neogit',
    dependencies = 'nvim-lua/plenary.nvim',
    keys = { { '<leader>gg', ":lua require('neogit').open()<CR>" } },
    opts = { disable_commit_confirmation = true };
  },

  ----------------------------------------
  --------------- Snippets ---------------
  ----------------------------------------

  -- Snippet engine
  {
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
      vim.keymap.set('i', '<C-x><C-s>', "<cmd>lua require('snippy').complete()<CR>")
    end,
  },

  --- Snippets source
  'honza/vim-snippets',

  ----------------------------------------
  --------------- Markdown ---------------
  ----------------------------------------

  -- Preview markdown in browser
  {
    'iamcco/markdown-preview.nvim',
    build = 'cd app && yarn install',
    ft = 'markdown',
    config = function()
      vim.g.mkdp_theme = 'light'
    end,
  },

  -- Table creator and formatter
  {
    'dhruvasagar/vim-table-mode',
    keys = { { '<leader>tm', ':TableModeToggle<CR>' } },
    config = function()
      vim.g.table_mode_corner = '|' -- markdown-compatible tables
    end,
  },

  -- Management of markdown notebooks
  {
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
  },

  ----------------------------------------
  ---------------- Puppet ----------------
  ----------------------------------------

  -- Make vim more Puppet friendly
  'rodjek/vim-puppet',

  -- Syntax for highlighting YARD documentation
  'noprompt/vim-yardoc',
}, { diff = { cmd = 'terminal_git' }})
