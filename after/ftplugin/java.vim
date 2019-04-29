
command! ExecCurrentBuffer -nargs=0 :call <SID>ExecCurrentBuffer()<cr>

function! <SID>ExecCurrentBuffer()
    if &modified
        :w!
    endif
    ":exe '! runghc '.expand("%:p")
    :exe '! javac '.expand("%:p").' && java '.expand("%:t:r")
endf

nmap <F5> :call <SID>ExecCurrentBuffer()<cr>
imap <F5> <esc><F5>
