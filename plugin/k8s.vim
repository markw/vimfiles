
function K8s(s)
    if len(a:s) < 4
        return a:s
    endif
    let first = a:s[0]
    let last = a:s[-1:]
    let middle = len(a:s) - 2
    exe 'normal ciw' . first . middle . last
endfunction

nmap <F9> :silent :call K8s(expand('<cword>'))<cr>
nmap <LocalLeader>k :K8s<cr>
command K8s :silent :call K8s(expand('<cword>'))<cr>

"relationships
