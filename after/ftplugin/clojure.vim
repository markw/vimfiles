if exists ("b:did_clojure_after_plugin")
    finish
endif

let b:did_clojure_after_plugin = 1

hi MatchParen ctermfg=yellow ctermbg=black

function! <SID>ExecCurrentBuffer()
    :stopinsert
    if &modified
        :w!
    endif
    ":exe '! ~/bin/clj '.expand("%:p")
    :exe '! clj -M '.expand("%:p")
endf

command! ExecCurrentBuffer -nargs=0 :call <SID>ExecCurrentBuffer()<cr>

nmap <F5> :call <SID>ExecCurrentBuffer()<cr>
imap <F5> <esc><F5>

function! ClojureCommenter() range
    for n in range(a:firstline, a:lastline)
        let s = getline(n)
        if strpart(s,0,2) == ";;"
            call setline(n, strpart(s,2))
        else
            call setline(n, ";;" . s)
        endif
    endfor
endf

function! SurroundWithPrintln() range
    call append(a:lastline,")")
    call append(a:firstline - 1,"(println")
endf

let maplocalleader = ","

vmap <buffer> ; :call ClojureCommenter()<cr>
vmap <buffer> <LocalLeader>p :call SurroundWithPrintln()<cr>
nmap <buffer> <LocalLeader>e :Eval<cr>
nmap <buffer> <LocalLeader>E :%Eval<cr>
nmap <buffer> <LocalLeader>, cpp
