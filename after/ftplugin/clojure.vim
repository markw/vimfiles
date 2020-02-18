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
    :exe '! clj '.expand("%:p")
endf

command! ExecCurrentBuffer -nargs=0 :call <SID>ExecCurrentBuffer()<cr>

function! <SID>ExecMain()
    :stopinsert
    if &modified
        :w!
    endif
    :exe '! clj '.expand("%:p")
endf

nmap <F5> :call <SID>ExecCurrentBuffer()<cr>
imap <F5> <esc><F5>
nmap <F9> :call <SID>ExecMain()<cr>

"imap <buffer> ( ()<left>
"imap <buffer> [ []<left>
"imap <buffer> { {}<left>
"
"
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

vmap ; :call ClojureCommenter()<cr>
vmap <LocalLeader>p :call SurroundWithPrintln()<cr>
nmap <LocalLeader>e :%Eval<cr>


