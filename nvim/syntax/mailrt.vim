set syntax=mail

syn match rtCommand /\%<15lSubject:\|\%<15lRequestor:\|\%<15lOwner:\|\%<15lStatus:\|\%<15lQueue:\|\%<15lTimeWorked:\|\%<15lAddCc:\|\%<15lRefersTo:/
" Values for Status
syn match rtValue /\%<15lnew\|\%<15lopen\|\%<15lstalled\|\%<15lresolved\|\%<15lrejected\|\%<15ldeleted/
" values for Queue
syn match rtValue /\%<15lcm.info\|\%<15lreseau.info\|\%<15lsi.info\|\%<15lsys.info\|\%<15ltel.info/

" And most usefull!
syntax match smiley "[:;]-[)(pPsS|D]"

highlight smiley guibg=#ffaf00 guifg=black ctermbg=yellow ctermfg=black
highlight default link rtCommand Identifier
highlight default link rtValue String
