syn match notePeople ' @\S\+'
syn match notePeople ' @\S\+\s\u\S*'
syn match noteImportant '!!\s.*$' contains=notePeople,noteDate
syn match noteDate /\d\{2\}\/\d\{2\}\/\d\{4\}/
syn match noteCompleted '\[X].*'

" For colors:
" :so $VIMRUNTIME/syntax/hitest.vim
hi def link notePeople    Structure
hi def link noteImportant Exception
hi def link noteDate      Underlined
hi def link noteCompleted Grey
