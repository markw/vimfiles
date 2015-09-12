"hi MatchParen ctermfg=black ctermbg=lightmagenta
hi MatchParen ctermfg=yellow ctermbg=black

nmap <F5> :! ~/bin/clj %<cr>

imap <buffer> ( ()<left>
imap <buffer> [ []<left>
imap <buffer> { {}<left>
