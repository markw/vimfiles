
map <silent><F3> :call ViewBufferList()<cr>

function! ViewBufferList()

  if bufexists(bufnr("__buffer_list__"))
    exec ':' . bufnr("__buffer_list__") . 'bwipeout!'
    wincmd p
    return
  endif
  call <sid>GenerateList()
endf

function! <sid>GenerateList()
  let cur_buf = bufnr('')
  let s:buflist = []
  let maxbuf = bufnr('$')
  let i=1 
  let width=10
  while i <= maxbuf
    if buflisted(i)
      let bufname = fnamemodify(bufname(i),':t')
      call add(s:buflist, [bufname, i])
      let width = max([width, len(bufname)])
    endif
    let i = i+1
  endwhile
  call sort(s:buflist)
  silent! exe ':silent! :vertical :topleft :' . (width+2) .'split __buffer_list__'
  let cursor_line=1
  for [bufname,bufnum] in s:buflist  
    if cur_buf == bufnum | let cursor_line = line('$') | endif
    call append(line('$'), bufname)
  endfor
  :1delete _
  call cursor(cursor_line,1)
  setlocal nomodifiable nobuflisted nowrap nonumber cursorline
  setlocal buftype=nofile bufhidden=delete
  map <silent><buffer><cr> :call <sid>EditSelectedBuffer()<cr>
  map <silent><buffer>s :call <sid>EditSelectedBufferInSplit()<cr>
  map <silent><buffer>v :call <sid>EditSelectedBufferInVSplit()<cr>
  map <silent><buffer>q :bwipeout<cr>
  map <silent><buffer>d :call <sid>DeleteSelectedBuffer()<cr>
endf

function! <sid>SelectedBuffer()
  return get(s:buflist, line('.')-1)
endf

function!<sid>SelectAndClose()
  let l:bufnum = <sid>SelectedBuffer()
  bwipeout
  return l:bufnum
endf

function! <sid>EditSelectedBuffer()
  let l:bufnum = <sid>SelectAndClose()
  wincmd p
  exe ':b'.get(l:bufnum,1)
endf

function! <sid>EditSelectedBufferInSplit()
  let l:bufnum = <sid>SelectAndClose()
  wincmd p
  exe ':sb'.get(l:bufnum,1)
endf

function! <sid>EditSelectedBufferInVSplit()
  let l:bufnum = <sid>SelectAndClose()
  wincmd p
  exe ':vertical sb'.get(l:bufnum,1)
endf

function! <sid>DeleteSelectedBuffer()
  let l:bufnum = <sid>SelectedBuffer()
  try
    exe ":confirm bwipeout".get(l:bufnum,1)
  catch
    return
  endtry
  setlocal modifiable
  call remove(s:buflist, line('.')-1)
  delete _
  setlocal nomodifiable
  if len(s:buflist) == 0
    bwipeout
  endif
endf
