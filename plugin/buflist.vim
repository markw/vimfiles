
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

  let s:current_bufnr = bufnr('%')
  let s:filterstr = ""

  if !exists("s:comparator")
      let s:comparator = function("s:MruComparator")
  endif
  call <sid>GenerateList()
endf

function! <sid>FormatBufName(fhead,ftail,len)
    let l:padded_len = a:len + 5
    let l:mask = "%-".l:padded_len."s %s"
    return printf(l:mask, a:ftail, a:fhead)
endf

function! <sid>GenerateList()
  let nums = filter(s:mru, 'buflisted(v:val)')
  let maxlen = 0
  let s:buflist = []
  for n in nums
    let fname = bufname(n)
    let ftail = fnamemodify(fname,':t')
    let fhead = fnamemodify(fname,':h')
    if empty(s:filterstr) || ftail =~ s:filterstr || fhead =~ s:filterstr
        let maxlen = max([maxlen, len(ftail)])
        call add(s:buflist, [fhead, ftail, n])
    endif
  endfor
  if len(s:buflist) < 2 && empty(s:filterstr)
      call s:Error("Not enough buffers")
      return
  endif
  call sort(s:buflist, s:comparator)
  if "__buffer_list__" == bufname('%')
    setlocal modifiable
    silent 1,$delete
  else
    silent! exe ':silent! :topleft :split __buffer_list__'
  endif
  let cursor_line=1
  for [fhead, ftail, bufnum] in s:buflist
    if s:current_bufnr == bufnum | let cursor_line = line('$') | endif
    call append(line('$'), s:FormatBufName(fhead, ftail, maxlen))
  endfor
  :1delete _
  call cursor(cursor_line,1)
  setlocal nomodifiable nobuflisted nowrap nonumber cursorline
  setlocal buftype=nofile bufhidden=delete
  map <silent><buffer><cr> :call <sid>EditSelectedBuffer()<cr>
  map <silent><buffer>s    :call <sid>EditSelectedBufferInSplit()<cr>
  map <silent><buffer>v    :call <sid>EditSelectedBufferInVSplit()<cr>
  map <silent><buffer>q    :bwipeout<cr>:wincmd p<cr>
  map <silent><buffer>d    :call <sid>DeleteSelectedBuffer()<cr>
  map <silent><buffer>n    :call <sid>SortByName()<cr>
  map <silent><buffer>m    :call <sid>SortByMru()<cr>
  map <silent><buffer>p    :call <sid>SortByPath()<cr>
  map <silent><buffer>f    :call <sid>FilterList()<cr>
endf

function! <sid>Compare(a,b)
    return a:a == a:b ? 0 : a:a > a:b ? 1 : -1
endf

function! <sid>NameComparator(a,b)
    return <sid>Compare(a:a[1], a:b[1])
endf

function! <sid>PathComparator(a,b)
    return <sid>Compare(a:a[0], a:b[0])
endf

function! <sid>MruComparator(a,b)
    return 0
endf

function! <sid>SortList(comparator)
    let s:comparator = a:comparator
    call s:GenerateList()
endf

function! <sid>SortByName()
    call s:SortList(function("s:NameComparator"))
endf

function! <sid>SortByMru()
    call s:SortList(function("s:MruComparator"))
endf

function! <sid>SortByPath()
    call s:SortList(function("s:PathComparator"))
endf

function! <sid>SelectedBuffer()
  if len(s:buflist) == 0
      return 0
  endif
  let l:bufinfo = get(s:buflist, line('.')-1)
  return get(l:bufinfo, 2)
endf

function!<sid>SelectAndClose()
  let l:bufnum = <sid>SelectedBuffer()
  if l:bufnum > 0
    bwipeout
    wincmd p
  endif
  return l:bufnum
endf

function! <sid>EditSelectedBuffer()
  let l:bufnum = <sid>SelectAndClose()
  if l:bufnum > 0
    exe ':b'.l:bufnum
  endif
endf

function! <sid>EditSelectedBufferInSplit()
  let l:bufnum = <sid>SelectAndClose()
  if l:bufnum > 0
    exe ':sb'.l:bufnum
  endif
endf

function! <sid>EditSelectedBufferInVSplit()
  let l:bufnum = <sid>SelectAndClose()
  if l:bufnum > 0
    exe ':vertical sb'.l:bufnum
  endif
endf

function! <sid>DeleteSelectedBuffer()
  let l:bufnum = <sid>SelectedBuffer()
  if l:bufnum == 0
    return
  endif
  setlocal modifiable
  delete _
  setlocal nomodifiable
  exe ":bdelete".l:bufnum
  call remove(s:buflist, line('.')-1)
  if len(s:buflist) == 0
    bwipeout
  endif
endf

let s:filterstr = ""

function! <sid>FilterList()
    let s:filterstr = input("Filter:")
    call <sid>GenerateList()
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
        let l:bufnr -= 1
    endwhile
endf

if v:vim_did_enter
    call s:InitMru()
else
    au VimEnter * call s:InitMru()
endif
