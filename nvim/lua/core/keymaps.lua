local map = vim.keymap.set

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
map('n', '<leader>sd', ':read ~/.config/neomutt/signature_dio<CR>')
map('n', '<leader>sp', ':read ~/.config/neomutt/signature_dio_permanence<CR>')
map('n', '<leader>so', ':read ~/.config/neomutt/signature_obspm_dio<CR>')

-- Search email in LDAP
map('n', '<leader>ls', ':lua ldap_lookup()<CR>:s/<C-R><C-W>/<C-R>a<BACKSPACE>/g<CR>:noh<CR>$')

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
map('n', '<leader>gl', ':lua git_log(vim.api.nvim_buf_get_name(0))<CR>')
map('n', '<leader>gL', ':lua git_log()<CR>')
