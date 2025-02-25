return {
  -- Configs for Neovim LSP
  {
    'neovim/nvim-lspconfig',
    dependencies = {
      'williamboman/mason.nvim',
      'barreiroleo/ltex_extra.nvim',
    },
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

      -- Add additional capabilities supported by nvim-cmp
      local capabilities = require('cmp_nvim_lsp').default_capabilities()

      -- ltex-ls-plus (Grammar/Spell Checker Using LanguageTool)
      if vim.fn.executable('ltex-ls-plus') == 1 then
        require('lspconfig').ltex_plus.setup({
          autostart = false,
          settings = {
            ltex = {
              language = 'fr',
            },
          },
          -- sed -i 's/name = "ltex"/name = "ltex_plus"/' ~/.local/share/nvim/lazy/ltex_extra.nvim/lua/ltex_extra/commands-lsp.lua
          -- waiting for https://github.com/barreiroleo/ltex_extra.nvim/pull/66
          on_attach = function(client, bufnr)
            require('ltex_extra').setup({
              load_langs = { 'fr' },
              path = vim.fn.expand('~') .. '/.local/share/ltex',
            })
          end,
        })
      end

      -- solargraph (Ruby)
      if vim.fn.executable('solargraph') == 1 then
        require('lspconfig').solargraph.setup({
          capabilities = capabilities,
        })
      end
    end,
  },

  -- Install and manage LSP servers, DAP servers, linters, and formatters
  {
    'williamboman/mason.nvim',
    dependencies = { 'ibhagwan/fzf-lua' },
    build = ':MasonUpdate',
    opts = {
      registries = {
        'github:mason-org/mason-registry',
        'github:visimp/mason-registry', -- for ltex_plus
      },
    },
  },
}
