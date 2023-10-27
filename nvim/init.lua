-------------------- HELPERS -------------------------------
local opt = vim.opt
local map = vim.keymap.set
local autocmd = vim.api.nvim_create_autocmd

local function augroup(group)
  vim.api.nvim_create_augroup(group, { clear = true })
end

-------------------- OPTIONS -------------------------------
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

if opt.diff:get() then
  opt.cursorline = false
end

-- Spellcheck
opt.spellsuggest:prepend({ 5 })
opt.dictionary = '/usr/share/dict/words' -- For completion of words (<C-x><C-k>)

------------------- FUNCTIONS ------------------------------
function ldap_lookup()
  vim.cmd("let @a = system('ldap_search_email '.expand('<cword>'))")
end

-- https://github.com/neovim/neovim/issues/14825#issuecomment-1304791407
function toggle_diagnostics()
  local vars, bufnr, cmd
  if global then
    vars = vim.g
    bufnr = nil
  else
    vars = vim.b
    bufnr = 0
  end
  vars.diagnostics_disabled = not vars.diagnostics_disabled
  if vars.diagnostics_disabled then
    cmd = 'disable'
    vim.api.nvim_echo({ { 'Disabling diagnostics…' } }, false, {})
  else
    cmd = 'enable'
    vim.api.nvim_echo({ { 'Enabling diagnostics…' } }, false, {})
  end
  vim.schedule(function()
    vim.diagnostic[cmd](bufnr)
  end)
end

-- Forgit log the file
function git_log(file)
  file = (file or '')
  vim.cmd('terminal ~/.zsh/forgit/bin/git-forgit log ' .. file)
  vim.cmd('startinsert')
end

-------------------- AUTOCMD -------------------------------
augroup('TermConfig')
autocmd('TermOpen', {
  desc = 'Disable line number in terminal-mode',
  command = 'setlocal nonumber norelativenumber',
  group = 'TermConfig',
})

augroup('TextYanked')
autocmd('TextYankPost', {
  desc = 'Highlight yanked region',
  callback = function()
    vim.highlight.on_yank({ higroup = 'Search', timeout = 700 })
  end,
  group = 'TextYanked',
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

-- LSP: toogle diagnostic
map('n', '<Leader>td', function()
  toggle_diagnostics()
end)

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

-- Forgit log in terminal
map('n', '<Leader>gl', function()
  git_log(vim.api.nvim_buf_get_name(0))
end)
map('n', '<Leader>gL', function()
  git_log()
end)

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
      vim.g.gruvbox_material_foreground = 'original'
      vim.cmd('colorscheme gruvbox-material')
    end,
  },

  -- Icons for plugins
  {
    'nvim-tree/nvim-web-devicons',
    lazy = true,
    opts = { color_icons = false },
  },

  -- Improve the default vim.ui interfaces
  { 'stevearc/dressing.nvim', event = 'VeryLazy' },

  -- Notification manager
  {
    'rcarriga/nvim-notify',
    event = 'VeryLazy',
    config = function()
      require('notify').setup({
        stages = 'static',
        timeout = 4000,
      })
      vim.notify = require('notify')
    end,
  },

  -- Treesitter configurations and abstraction layer
  {
    'nvim-treesitter/nvim-treesitter',
    build = ':TSUpdate',
    config = function()
      require('nvim-treesitter.configs').setup({
        highlight = {
          enable = true,
        },
        indent = {
          enable = true,
          disable = { 'markdown' },
        },
      })
    end,
  },

  -- Easily add additional highlights
  {
    'folke/paint.nvim',
    ft = 'puppet',
    opts = {
      highlights = {
        {
          filter = { filetype = 'puppet' },
          pattern = '^# (@%w+)',
          hl = 'Constant',
        },
        {
          filter = { filetype = 'puppet' },
          pattern = '^# @param (%S+)',
          hl = 'Identifier',
        },
      },
    },
  },

  -- Jump anywhere in a document with as few keystrokes as possible
  {
    'smoka7/hop.nvim',
    event = 'VeryLazy',
    config = function()
      require('hop').setup({ keys = 'etovxqpdygfblzhckisuran' })

      local hop = require('hop')
      local directions = require('hop.hint').HintDirection
      map('', 'f', function()
        hop.hint_char1({ direction = directions.AFTER_CURSOR, current_line_only = true })
      end)
      map('', 'F', function()
        hop.hint_char1({ direction = directions.BEFORE_CURSOR, current_line_only = true })
      end)
      map('', 't', function()
        hop.hint_char1({ direction = directions.AFTER_CURSOR, current_line_only = true, hint_offset = -1 })
      end)
      map('', 'T', function()
        hop.hint_char1({ direction = directions.BEFORE_CURSOR, current_line_only = true, hint_offset = 1 })
      end)
      map('n', 's', ':HopWord<CR>')

      -- Gruvbox colors
      vim.cmd([[
      highlight! HopNextKey ctermfg=208 guifg=#fe8019
      highlight! HopNextKey1 ctermfg=142 guifg=#b8bb26
      highlight! link HopNextKey2 Green
      highlight! link HopUnmatched Grey
      ]])
    end,
  },

  -- Fuzzy finder FZF
  {
    'ibhagwan/fzf-lua',
    keys = {
      { '<leader>ff', ':FzfLua files<CR>' },
      { '<leader>fg', ':FzfLua live_grep<CR>' },
      { '<leader>fb', ':FzfLua buffers<CR>' },
    },
    config = function()
      require('fzf-lua').setup({
        fzf_colors = {
          ['fg'] = { 'fg', 'CursorLine' },
          ['bg'] = { 'bg', 'Normal' },
          ['hl'] = { 'fg', 'Aqua' },
          ['fg+'] = { 'fg', 'Normal' },
          ['bg+'] = { 'bg', 'CursorLine' },
          ['hl+'] = { 'fg', 'Aqua' },
          ['info'] = { 'fg', 'PreProc' },
          ['border'] = { 'fg', 'Grey' },
          ['prompt'] = { 'fg', 'Blue' },
          ['pointer'] = { 'fg', 'Exception' },
          ['marker'] = { 'fg', 'Keyword' },
          ['spinner'] = { 'fg', 'Label' },
          ['header'] = { 'fg', 'Comment' },
          ['gutter'] = { 'bg', 'Normal' },
        },
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
      })
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
    lazy = false,
    keys = {
      { '<A-a>', ':BufferPrevious<CR>' },
      { '<A-z>', ':BufferNext<CR>' },
      { '<A-A>', ':BufferMovePrevious<CR>' },
      { '<A-Z>', ':BufferMoveNext<CR>' },
      { '<A-p>', ':BufferPin<CR>' },
      { '<A-c>', ':BufferClose<CR>' },
    },
    opts = {
      auto_hide = true,
      icons = {
        button = false,
        modified = false,
      },
    },
  },

  -- Align text interactively
  {
    'echasnovski/mini.align',
    event = 'VeryLazy',
    config = function()
      require('mini.align').setup()
    end,
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
    event = 'VeryLazy',
    opts = {
      surrounds = {
        ['«'] = {
          add = { '« ', ' »' },
        },
        ['»'] = {
          add = { '«', '»' },
        },
      },
    },
  },

  -- Enhance to increment/decrement (<C-a>, <C-x>)
  {
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
  },

  -- Toggles between hybrid and absolute line numbers automatically
  'sitiom/nvim-numbertoggle',

  -- Autodect and cd to project directory
  {
    'ahmedkhalf/project.nvim',
    config = function()
      require('project_nvim').setup({
        detection_methods = { 'pattern' },
        patterns = { '.git' },
      })
    end,
  },

  -- Outline window for quick navigation
  {
    'stevearc/aerial.nvim',
    dependencies = {
      'nvim-treesitter/nvim-treesitter',
      'nvim-tree/nvim-web-devicons',
    },
    keys = { { '<F9>', ':AerialToggle<CR>' } },
    config = true,
  },

  -- Better '%' navigation and highlight matching words
  'andymass/vim-matchup',

  -- "Edit" mp3 files with Vim, or rather, their ID3 tags
  'AndrewRadev/id3.vim',

  -- Make vim more Puppet friendly
  {
    'rodjek/vim-puppet',
    ft = 'puppet',
  },

  ----------------------------------------
  ----------------- Git ------------------
  ----------------------------------------

  -- Git integration: signs, hunk actions, blame, etc.
  {
    'lewis6991/gitsigns.nvim',
    opts = {
      on_attach = function(bufnr)
        local gs = package.loaded.gitsigns

        -- Navigation
        map('n', ']c', function()
          if vim.wo.diff then
            return ']c'
          end
          vim.schedule(function()
            gs.next_hunk()
          end)
          return '<Ignore>'
        end, { expr = true })

        map('n', '[c', function()
          if vim.wo.diff then
            return '[c'
          end
          vim.schedule(function()
            gs.prev_hunk()
          end)
          return '<Ignore>'
        end, { expr = true })

        -- Actions
        map('n', '<leader>gb', gs.toggle_current_line_blame)
        map('n', '<leader>gd', gs.diffthis)
      end,
    },
  },

  -- Magit clone: stage, commit, pull, push
  {
    'NeogitOrg/neogit',
    dependencies = 'nvim-lua/plenary.nvim',
    keys = { { '<leader>gg', ':Neogit<CR>' } },
    opts = { disable_commit_confirmation = true },
  },

  ----------------------------------------
  --------------- Snippets ---------------
  ----------------------------------------

  -- Snippet engine
  {
    'dcampos/nvim-snippy',
    dependencies = { 'honza/vim-snippets' },
    ft = { 'snippets' },
    event = 'InsertEnter',
    keys = {
      {
        '<C-x><C-s>',
        function()
          require('snippy').complete()
        end,
        mode = 'i',
      },
    },
    opts = {
      mappings = {
        is = {
          ['<Tab>'] = 'expand',
          ['<C-j>'] = 'next',
          ['<C-k>'] = 'previous',
        },
      },
    },
  },

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
      require('mkdnflow').setup({
        modules = {
          bib = false,
          buffers = false,
          conceal = false,
          folds = false,
          tables = false,
        },
        filetypes = { md = true, mdwn = true, markdown = true },
        links = {
          transform_implicit = false,
          transform_explicit = function(text)
            text = text:gsub(' ', '-')
            text = text:lower()
            return text
          end,
        },
      })
    end,
  },

  ----------------------------------------
  ----------------- LSP ------------------
  ----------------------------------------

  -- Install and manage LSP servers, DAP servers, linters, and formatters
  {
    'williamboman/mason.nvim',
    build = ':MasonUpdate',
    config = true,
  },

  -- Makes it easier to use lspconfig with mason.nvim
  {
    'williamboman/mason-lspconfig.nvim',
    dependencies = 'barreiroleo/ltex_extra.nvim',
    config = function()
      require('mason-lspconfig').setup()

      -- Automatic server setup
      require('mason-lspconfig').setup_handlers({
        -- Default handler
        function(server_name)
          require('lspconfig')[server_name].setup({})
        end,

        -- Grammar/Spell Checker Using LanguageTool
        ['ltex'] = function()
          require('lspconfig').ltex.setup({
            filetypes = { 'gitcommit', 'NeogitCommitMessage', 'markdown', 'mail' },
            autostart = false,
            on_attach = function(client, bufnr)
              require('ltex_extra').setup({
                load_langs = { 'fr' },
                path = vim.fn.expand('~') .. '/.local/share/ltex',
              })
            end,
            settings = {
              ltex = {
                language = 'fr',
              },
            },
          })
        end,
      })
    end,
  },

  -- Quickstart configs for Neovim LSP
  {
    'neovim/nvim-lspconfig',
    config = function()
      -- Global mappings.
      -- See `:help vim.diagnostic.*` for documentation on any of the below functions
      vim.keymap.set('n', '<space>e', vim.diagnostic.open_float)
      vim.keymap.set('n', '[d', vim.diagnostic.goto_prev)
      vim.keymap.set('n', ']d', vim.diagnostic.goto_next)
      vim.keymap.set('n', '<space>q', vim.diagnostic.setloclist)

      -- Use LspAttach autocommand to only map the following keys
      -- after the language server attaches to the current buffer
      vim.api.nvim_create_autocmd('LspAttach', {
        group = vim.api.nvim_create_augroup('UserLspConfig', {}),
        callback = function(ev)
          -- Enable completion triggered by <c-x><c-o>
          vim.bo[ev.buf].omnifunc = 'v:lua.vim.lsp.omnifunc'

          -- Buffer local mappings.
          -- See `:help vim.lsp.*` for documentation on any of the below functions
          local opts = { buffer = ev.buf }
          vim.keymap.set('n', 'gD', vim.lsp.buf.declaration, opts)
          vim.keymap.set('n', 'gd', vim.lsp.buf.definition, opts)
          vim.keymap.set('n', 'K', vim.lsp.buf.hover, opts)
          vim.keymap.set('n', 'gi', vim.lsp.buf.implementation, opts)
          vim.keymap.set('n', '<C-k>', vim.lsp.buf.signature_help, opts)
          vim.keymap.set('n', '<space>wa', vim.lsp.buf.add_workspace_folder, opts)
          vim.keymap.set('n', '<space>wr', vim.lsp.buf.remove_workspace_folder, opts)
          vim.keymap.set('n', '<space>wl', function()
            print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
          end, opts)
          vim.keymap.set('n', '<space>D', vim.lsp.buf.type_definition, opts)
          vim.keymap.set('n', '<space>rn', vim.lsp.buf.rename, opts)
          vim.keymap.set({ 'n', 'v' }, '<space>ca', vim.lsp.buf.code_action, opts)
          vim.keymap.set('n', 'gr', vim.lsp.buf.references, opts)
          vim.keymap.set('n', '<space>f', function()
            vim.lsp.buf.format({ async = true })
          end, opts)
        end,
      })
    end,
  },

  -- Linter
  {
    'mfussenegger/nvim-lint',
    ft = { 'puppet', 'sh', 'yaml' },
    config = function()
      require('lint').linters_by_ft = {
        puppet = { 'puppet-lint' },
        sh = { 'shellcheck' },
        yaml = { 'yamllint' },
      }

      augroup('Lint')
      autocmd({ 'BufEnter', 'BufWritePost' }, {
        desc = 'Check the file',
        callback = function()
          require('lint').try_lint()
        end,
        group = 'Lint',
      })
    end,
  },

  -- Formatter
  {
    'stevearc/conform.nvim',
    cmd = { 'ConformInfo' },
    keys = {
      {
        '<space>f',
        function()
          require('conform').format({ async = true, lsp_fallback = true })
        end,
        mode = '',
        desc = 'Format buffer',
      },
    },
    opts = {
      formatters_by_ft = {
        lua = { 'stylua' },
        puppet = { 'puppet-lint' },
        sh = { 'shellcheck' },
        ['*'] = { 'trim_newlines', 'trim_whitespace' },
      },
    },
  },

  ----------------------------------------
  -------------- Completion --------------
  ----------------------------------------

  {
    'hrsh7th/nvim-cmp',
    dependencies = {
      'hrsh7th/cmp-nvim-lsp',
      'hrsh7th/cmp-buffer',
      'dcampos/cmp-snippy',
    },
    event = 'InsertEnter',
    config = function()
      local cmp = require('cmp')

      cmp.setup({
        snippet = {
          expand = function(args)
            require('snippy').expand_snippet(args.body)
          end,
        },
        completion = {
          autocomplete = false,
        },
        mapping = cmp.mapping.preset.insert({
          ['<C-n>'] = cmp.mapping.select_next_item({ behavior = cmp.SelectBehavior.Insert }),
          ['<C-p>'] = cmp.mapping.select_prev_item({ behavior = cmp.SelectBehavior.Insert }),
          ['<C-b>'] = cmp.mapping.scroll_docs(-4),
          ['<C-f>'] = cmp.mapping.scroll_docs(4),
          ['<C-x><C-o>'] = cmp.mapping.complete(),
          ['<C-e>'] = cmp.mapping.abort(),
          ['<CR>'] = cmp.mapping.confirm({ select = true }),
        }),
        sources = cmp.config.sources({
          { name = 'nvim_lsp' },
          { name = 'snippy' },
        }, {
          { name = 'buffer' },
        }),
      })
    end,
  },
}, { diff = { cmd = 'terminal_git' } })
