command! ExecCurrentBuffer -nargs=0 :call <SID>ExecCurrentBuffer()<cr>

function! <SID>ExecCurrentBuffer()
    if &modified
        :w!
    endif
    ":exe '! runghc '.expand("%:p")
    :exe '! stack test'
endf

nmap <F5> :call <SID>ExecCurrentBuffer()<cr>
imap <F5> <esc><F5>

function! HaskellCommenter() range
    let l:comment = "--"
    for n in range(a:firstline, a:lastline)
        let s = getline(n)
        if strpart(s,0,2) == l:comment
            call setline(n, strpart(s,2))
        else
            call setline(n, l:comment . s)
        endif
    endfor
endf

vmap - :call HaskellCommenter()<cr>
