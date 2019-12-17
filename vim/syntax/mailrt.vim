set syntax=mail

syn match rtCommand /\%<6lOwner:\|\%<6lStatus:\|\%<6lQueue:\|\%<6lTimeWorked:\|\%<6lAddCC:/
" Values for Status
syn match rtValue /\%<6lnew\|\%<6lopen\|\%<6lstalled\|\%<6lresolved\|\%<6lrejected\|\%<6ldeleted/
" values for Queue
syn match rtValue /\%<6lcm.info\|\%<6lreseau.info\|\%<6lsi.info\|\%<6lsys.info\|\%<6ltel.info/

" And most usefull!
syntax match smiley "[:;]-[)(pPsS|D]"

highlight smiley guibg=#ffaf00 guifg=black ctermbg=yellow ctermfg=black
highlight default link rtCommand Identifier
highlight default link rtValue String
