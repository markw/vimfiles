map <Leader>j :%! python -mjson.tool<cr>
setlocal autoread

function s:FormatFile(file)
    exe ':silent !npx  prettier  --write --loglevel silent '.a:file
    :redraw
endf

"autocmd! BufWritePost *.js :call s:FormatFile(fnamemodify("%", ":p"))
set formatprg=npx\ prettier\ --stdin-filepath\ %

set foldmethod=syntax

autocmd BufReadPost *.js set foldlevel=0 | set foldnestmax=2

autocmd BufReadPost *.test.js set foldlevel=2 | set foldnestmax=3

