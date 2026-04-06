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
  callback = function(ev)
    -- Buffer local mappings
    -- See `:help vim.lsp.*` for documentation on any of the below functions
    local opts = { buffer = ev.buf }
    vim.keymap.set('n', 'gD', vim.lsp.buf.declaration, opts)
    vim.keymap.set('n', 'gd', vim.lsp.buf.definition, opts)

    -- Autocompletion for LSP
    local client = vim.lsp.get_client_by_id(ev.data.client_id)
    if client ~= nil and client:supports_method('textDocument/completion') then
      vim.lsp.completion.enable(true, client.id, ev.buf, {
        autotrigger = true,
        convert = function(item)
          -- Remove parameters (already in popupmenu)
          -- https://www.reddit.com/r/neovim/comments/1mglgn4/simple_native_autocompletion_with_autocomplete/
          local abbr = item.label
          abbr = abbr:gsub('%b()', ''):gsub('%b{}', '')
          -- abbr = abbr:match('[%w.]+.*') or abbr
          -- Remove return value
          local menu = ''

          return { abbr = abbr, menu = menu }
        end,
      })
    end
  end,
  group = vim.api.nvim_create_augroup('misaflo_lsp_config', { clear = true }),
})

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

-- lua-language-server
vim.lsp.enable('lua_ls')
-- See https://github.com/neovim/nvim-lspconfig/blob/master/lsp/lua_ls.lua
-- for neovim specific config
vim.lsp.config('lua_ls', {
  on_init = function(client)
    -- Disable lua_ls formater (EmmyLuaCodeStyle), use stylua with conform
    client.server_capabilities.documentFormattingProvider = false
    client.server_capabilities.documentFormattingRangeProvider = false

    if client.workspace_folders then
      local path = client.workspace_folders[1].name
      if
        path ~= vim.fn.stdpath('config')
        and (vim.uv.fs_stat(path .. '/.luarc.json') or vim.uv.fs_stat(path .. '/.luarc.jsonc'))
      then
        return
      end
    end

    -- See https://luals.github.io/wiki/settings/
    client.config.settings.Lua = vim.tbl_deep_extend('force', client.config.settings.Lua, {
      runtime = {
        -- Tell the language server which version of Lua you're using (most
        -- likely LuaJIT in the case of Neovim)
        version = 'LuaJIT',
        -- Tell the language server how to find Lua modules same way as Neovim
        -- (see `:h lua-module-load`)
        path = {
          'lua/?.lua',
          'lua/?/init.lua',
        },
      },
      -- Make the server aware of Neovim runtime files
      workspace = {
        checkThirdParty = false,
        library = {
          vim.env.VIMRUNTIME,
        },
      },
    })
  end,
  settings = {
    Lua = {},
  },
})

-- Install and manage LSP servers, DAP servers, linters, and formatters
require('mason').setup()
