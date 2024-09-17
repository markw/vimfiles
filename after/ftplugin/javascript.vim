map <Leader>j :%! python -mjson.tool<cr>
setlocal autoread

function s:FormatFile(file)
    exe ':silent !prettier  --write --loglevel silent '.a:file
    :redraw
endf

set formatprg=npx\ prettier\ --stdin-filepath\ %

set foldmethod=syntax
set foldlevel=0 foldnestmax=2 foldminlines=2
set sw=2 ts=2

if expand("%") =~ 'qunit\|.test.js'
  set foldnestmax=3
end

"autocmd! BufWritePost *.js :call s:FormatFile(fnamemodify("%", ":p"))

function! <SID>ExecCurrentBuffer()
    :stopinsert
    if &modified
        :w!
    endif
    :exe '! node '.expand("%:p")
endf

command! ExecCurrentBuffer -nargs=0 :call <SID>ExecCurrentBuffer()<cr>

nmap <F5> :call <SID>ExecCurrentBuffer()<cr>

