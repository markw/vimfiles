
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

function! <sid>FormatBufName(fhead,ftail,len)
    let l:padded_len = a:len + 5
    let l:mask = "%-".l:padded_len."s %s"
    return printf(l:mask, a:ftail, a:fhead)
endf

function! <sid>GenerateList()
  let cur_buf = bufnr('%')
  let nums = filter(s:mru, 'buflisted(v:val)')
  let maxlen = 0
  let s:buflist = []
  for n in nums
    let fname = bufname(n)
    let ftail = fnamemodify(fname,':t')
    let fhead = fnamemodify(fname,':h')
    let maxlen = max([maxlen, len(ftail)])
    call add(s:buflist, [fhead, ftail, n])
  endfor
  if len(s:buflist) < 2
      call s:Error("Not enough buffers")
      return
  endif
  silent! exe ':silent! :topleft :split __buffer_list__'
  let cursor_line=1
  for [fhead, ftail, bufnum] in s:buflist
    if cur_buf == bufnum | let cursor_line = line('$') | endif
    call append(line('$'), s:FormatBufName(fhead, ftail, maxlen))
  endfor
  :1delete _
  call cursor(cursor_line,1)
  setlocal nomodifiable nobuflisted nowrap nonumber cursorline
  setlocal buftype=nofile bufhidden=delete
  map <silent><buffer><cr> :call <sid>EditSelectedBuffer()<cr>
  map <silent><buffer>s    :call <sid>EditSelectedBufferInSplit()<cr>
  map <silent><buffer>v    :call <sid>EditSelectedBufferInVSplit()<cr>
  map <silent><buffer>q    :bwipeout<cr>
  map <silent><buffer>d    :call <sid>DeleteSelectedBuffer()<cr>
endf

function! <sid>SelectedBuffer()
  let l:bufinfo = get(s:buflist, line('.')-1)
  return get(l:bufinfo, 2)
endf

function!<sid>SelectAndClose()
  let l:bufnum = <sid>SelectedBuffer()
  bwipeout
  wincmd p
  return l:bufnum
endf

function! <sid>EditSelectedBuffer()
  let l:bufnum = <sid>SelectAndClose()
  exe ':b'.l:bufnum
endf

function! <sid>EditSelectedBufferInSplit()
  let l:bufnum = <sid>SelectAndClose()
  exe ':sb'.l:bufnum
endf

function! <sid>EditSelectedBufferInVSplit()
  let l:bufnum = <sid>SelectAndClose()
  exe ':vertical sb'.l:bufnum
endf

function! <sid>DeleteSelectedBuffer()
  let l:bufnum = <sid>SelectedBuffer()
  setlocal modifiable
  delete _
  setlocal nomodifiable
  exe ":bdelete".l:bufnum
  call remove(s:buflist, line('.')-1)
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

au BufCreate,BufAdd,BufEnter,BufNew * call s:UpdateMru(bufnr('%'))

"map <F12> :call <SID>MruEchoBuffers()<CR>

function! <sid>InitMru()
    let l:bufnr = bufnr('$')
    while l:bufnr > 0
        call s:UpdateMru(l:bufnr)
        let l:bufnr = l:bufnr - 1
    endwhile
endf

if v:vim_did_enter
    call s:InitMru()
else
    au VimEnter * call s:InitMru()
endif
