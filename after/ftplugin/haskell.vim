command! ExecCurrentBuffer -nargs=0 :call <SID>ExecCurrentBuffer()<cr>

function! <SID>ExecCurrentBuffer()
    :stopinsert
    if &modified
        :w!
    endif
    :exe '! runghc '.expand("%:p")
endf

nmap <F5> :call <SID>ExecCurrentBuffer()<cr>
imap <F5> <esc><F5>
