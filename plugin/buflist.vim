
function! s:Error(msg)
    echohl ErrorMsg | echo a:msg | echohl None
endf

function! ViewBufferList()

  if bufexists(bufnr("__buffer_list__"))
    exec ':' . bufnr("__buffer_list__") . 'bwipeout!'
    wincmd p
    return
  endif

  if &ft == 'help'
      return
  endif

  if bufname('') =~ 'NERD_tree'
      call s:Error("Can't use from NERDTree")
      return
  endif

  call <sid>GenerateList()
endf

function! <sid>GenerateList()
  let cur_buf = bufnr('%')
  let s:buflist = []
  let nums = filter(s:mru, 'buflisted(v:val)')
  for n in nums
    let fname = bufname(n)
    let bufname = printf("%-25s %s", fnamemodify(fname,':t'), fnamemodify(fname,':h'))
    call add(s:buflist, [bufname, n])
  endfor
  if len(s:buflist) < 2
      call s:Error("Not enough buffers")
      return
  endif
  silent! exe ':silent! :topleft :split __buffer_list__'
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
  wincmd p
  return l:bufnum
endf

function! <sid>EditSelectedBuffer()
  let l:bufnum = <sid>SelectAndClose()
  exe ':b'.get(l:bufnum,1)
endf

function! <sid>EditSelectedBufferInSplit()
  let l:bufnum = <sid>SelectAndClose()
  exe ':sb'.get(l:bufnum,1)
endf

function! <sid>EditSelectedBufferInVSplit()
  let l:bufnum = <sid>SelectAndClose()
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

let s:mru = []

function! <SID>UpdateMru(n)
    if (!buflisted(a:n))
        return
    endif
    call filter(s:mru, 'v:val != '.a:n)
    call insert(s:mru, a:n)
endf

function! <SID>MruEchoBuffers()
    echo filter(s:mru, 'buflisted(v:val)')
endf

au BufCreate,BufAdd,BufEnter * call s:UpdateMru(bufnr('%'))

map <F12> :call <SID>MruEchoBuffers()<CR>

