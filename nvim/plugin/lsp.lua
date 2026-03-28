vim.api.nvim_create_autocmd('PackChanged', {
  callback = function(ev)
    local name, kind = ev.data.spec.name, ev.data.kind
    if name == 'mason.nvim' and kind == 'update' then
      if not ev.data.active then
        vim.cmd.packadd('mason.nvim')
      end
      vim.cmd('MasonUpdate')
    end
  end,
})

vim.pack.add({
  'https://github.com/neovim/nvim-lspconfig',
  'https://github.com/mason-org/mason.nvim',
  'https://github.com/barreiroleo/ltex_extra.nvim',
})

-- Configs for Neovim LSP
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

-- solargraph (Ruby)
vim.lsp.enable('solargraph')
vim.lsp.config('solargraph', {
  capabilities = capabilities,
})

-- Install and manage LSP servers, DAP servers, linters, and formatters
require('mason').setup()
