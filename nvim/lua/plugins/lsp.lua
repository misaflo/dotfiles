return {
  -- Configs for Neovim LSP
  {
    'neovim/nvim-lspconfig',
    dependencies = {
      'williamboman/mason.nvim',
      'barreiroleo/ltex_extra.nvim',
    },
    config = function()
      vim.keymap.set('n', '<space>q', vim.diagnostic.setloclist)

      -- Use LspAttach autocommand to only map the following keys
      -- after the language server attaches to the current buffer
      vim.api.nvim_create_autocmd('LspAttach', {
        group = vim.api.nvim_create_augroup('UserLspConfig', {}),
        callback = function(ev)
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
        vim.lsp.enable('ltex_plus')
        vim.lsp.config('ltex_plus', {
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
        vim.lsp.enable('solargraph')
        vim.lsp.config('solargraph', {
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
