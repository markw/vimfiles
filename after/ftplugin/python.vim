" :nnoremap <buffer> <F5> :!python3 %<cr>
":nnoremap <buffer> <F5> :w<cr>:exe '!python3 '.fnamemodify("%",":p")<cr>

command! ExecCurrentBuffer -nargs=0 :call <SID>ExecCurrentBuffer()<cr>

function! <SID>ExecCurrentBuffer()
    if &modified
        :w!
    endif
    :exe '! python3 '.expand("%:p")
endf

nmap <buffer> <F5> :call <SID>ExecCurrentBuffer()<cr>
imap <buffer> <F5> <esc><F5>
