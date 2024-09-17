function! <SID>ExecCurrentBuffer()
    :stopinsert
    if &modified
        :w!
    endif
    :exe '!go run %'
endf

nmap <F5> :call <SID>ExecCurrentBuffer()<cr>
imap <F5> <esc><F5>
