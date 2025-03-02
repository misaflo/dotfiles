local map = vim.keymap.set

-- Toggle display of diagnostics
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

-- Search LDAP email
function ldap_lookup()
  vim.cmd("let @a = system('ldap_search_email '.expand('<cword>'))")
end

-- Copy to clipboard, past from clipboard
map('', '<leader>y', '"+y')
map('n', '<leader>p', '"+p')

-- Email Signature
map('n', '<Leader>sd', ':read ~/.config/neomutt/signature_dio<CR>')
map('n', '<Leader>sp', ':read ~/.config/neomutt/signature_dio_permanence<CR>')
map('n', '<Leader>so', ':read ~/.config/neomutt/signature_obspm_dio<CR>')

-- Search email in LDAP
map('n', '<Leader>ls', ':lua ldap_lookup()<CR>:s/<C-R><C-W>/<C-R>a<BACKSPACE>/g<CR>:noh<CR>$')

-- LSP: toogle diagnostic
map('n', '<Leader>td', ':lua toggle_diagnostics()<CR>')

-- Spellchecking
map('n', '<leader>sf', ':set spell spelllang=fr<CR>')
map('n', '<leader>se', ':set spell spelllang=en<CR>')
map('n', '<leader>sn', ':set nospell<CR>')

-- Resize with arrows
map('n', '<C-Up>', ':resize -2<CR>')
map('n', '<C-Down>', ':resize +2<CR>')
map('n', '<C-Left>', ':vertical resize -2<CR>')
map('n', '<C-Right>', ':vertical resize +2<CR>')

-- Forgit log in terminal
map('n', '<Leader>gl', ':lua git_log(vim.api.nvim_buf_get_name(0))<CR>')
map('n', '<Leader>gL', ':lua git_log()<CR>')
