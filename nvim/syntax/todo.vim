syn match todoTitle '^\w\+.*$'
syn match todoProject '^_.*$'
syn match todoPeople ' @\S\+'
syn match todoPeople ' @\S\+\s\u\S*'
syn match todoImportant '^\s*!\s.*$' contains=todoProject,todoPeople,todoDate
syn match todoList '^\s*\-\s'
syn match todoDate /\d\{2\}\/\d\{2\}\/\d\{4\}/
syn match todoUrl /http[s]\?:\/\/[[:alnum:]%\/_#.-]*/

" For colors:
" :so $VIMRUNTIME/syntax/hitest.vim
hi def link todoTitle     Title
hi def link todoProject   markdownH5
hi def link todoPeople    Structure
hi def link todoImportant Exception
hi def link todoList      Comment
hi def link todoDate      Underlined
hi def link todoUrl       markdownUrl
