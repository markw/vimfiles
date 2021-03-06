map <Leader>j :%! python -mjson.tool<cr>
setlocal autoread

function s:FormatFile(file)
    exe ':silent !npx  prettier  --write --loglevel silent '.a:file
    :redraw
endf

"autocmd! BufWritePost *.js :call s:FormatFile(fnamemodify("%", ":p"))
set formatprg=npx\ prettier\ --stdin-filepath\ %

set foldmethod=syntax
set foldlevel=0 foldnestmax=2
set sw=2

