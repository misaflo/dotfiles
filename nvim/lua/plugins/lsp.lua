return {
  -- Quickstart configs for Neovim LSP
  {
    'neovim/nvim-lspconfig',
    config = function()
      -- Global mappings.
      -- See `:help vim.diagnostic.*` for documentation on any of the below functions
      -- https://github.com/neovim/neovim/issues/28909#issuecomment-2123773710
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
          vim.keymap.set('n', 'gi', vim.lsp.buf.implementation, opts)
          vim.keymap.set('i', '<C-S>', vim.lsp.buf.signature_help, opts)
          vim.keymap.set('n', '<space>wa', vim.lsp.buf.add_workspace_folder, opts)
          vim.keymap.set('n', '<space>wr', vim.lsp.buf.remove_workspace_folder, opts)
          vim.keymap.set('n', '<space>wl', function()
            print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
          end, opts)
          vim.keymap.set('n', '<space>D', vim.lsp.buf.type_definition, opts)
          vim.keymap.set('n', 'grn', vim.lsp.buf.rename, opts)
          vim.keymap.set({ 'n', 'x' }, 'gra', vim.lsp.buf.code_action, opts)
          vim.keymap.set('n', 'grr', vim.lsp.buf.references, opts)
        end,
      })
    end,
  },

  -- Install and manage LSP servers, DAP servers, linters, and formatters
  {
    'williamboman/mason.nvim',
    dependencies = { 'ibhagwan/fzf-lua' },
    build = ':MasonUpdate',
    config = true,
  },

  -- Makes it easier to use lspconfig with mason.nvim
  {
    'williamboman/mason-lspconfig.nvim',
    dependencies = 'barreiroleo/ltex_extra.nvim',
    config = function()
      require('mason-lspconfig').setup()

      -- Add additional capabilities supported by nvim-cmp
      local capabilities = require('cmp_nvim_lsp').default_capabilities()

      -- Automatic server setup
      require('mason-lspconfig').setup_handlers({
        -- Default handler
        function(server_name)
          require('lspconfig')[server_name].setup({
            capabilities = capabilities,
          })
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
}
