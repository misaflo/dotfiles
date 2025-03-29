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
      -- Open float when jumping to diagnostic
      vim.keymap.set('n', '[d', function()
        vim.diagnostic.jump({ count = -1, float = true })
      end)
      vim.keymap.set('n', ']d', function()
        vim.diagnostic.jump({ count = 1, float = true })
      end)
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
    config = true,
  },
}
