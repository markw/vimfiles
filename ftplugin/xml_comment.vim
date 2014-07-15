if exists("g:did_xml_comment")
    finish
endif

let g:did_xml_comment = 1
let maplocalleader=","

function! ToggleComment(start,end)
let n = a:start
while n <= a:end
  let s = getline(n)
  if s =~ "^\\s*<!--.*-->$"
      let s = substitute(s, '<!--', '','')
      let s = substitute(s, '-->', '','')
      call setline(n,s)
  elseif s =~ "\\S"
      let s = substitute(s, '\(\S\)',  '<!--\1', '')
      call setline(n, s.'-->')
  end
  let n = n + 1
endwhile
endfunction

function! XmlBlockComment(start,end)
let open  = repeat(' ',indent(a:start)) . '<!--'
let close = repeat(' ',indent(a:end))   . '-->'
call append(a:end,close)
call append(a:start-1,open)
endfunction

com! -range -nargs=0 Comment          :call ToggleComment(<line1>,<line2>)
com! -range -nargs=0 BlockComment     :call XmlBlockComment(<line1>,<line2>)

vmap <silent><LocalLeader>, :Comment<cr>
vmap <silent><LocalLeader>! :BlockComment<cr>

setlocal fo=croql
setlocal comments=sr:<!--,mb:\\|,e:-->

imap <silent><buffer> <F11> <!-- --><left><left><left>
imap <silent><buffer> <F12> <esc><F12>
nmap <silent><buffer> <F12> :s/\ \ \|\ -->/-->/<cr>
