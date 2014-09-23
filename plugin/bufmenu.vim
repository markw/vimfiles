function! s:BufferInputList()
  let cur_bufnr = bufnr('%')
  let alt_bufnr = bufnr('#')
  let s:buflist = []
  let maxbuf = bufnr('$')
  let i=1 
  let width=10
  while i <= maxbuf
    if buflisted(i)
        let buf_char = ' '
        if  cur_bufnr == i
            let buf_char = '%'
        elseif alt_bufnr == i
            let buf_char = '#'
        endif
      let bufname = fnamemodify(bufname(i),':t')
      let bufdir = fnamemodify(bufname(i),':p:h')
      let dirs = split(bufdir,"/")
      if len(dirs) > 3
          let bufdir = '...' . join(dirs[-3:],"/")
      endif
      call add(s:buflist, printf("%3s %s %-30s %s", i, buf_char, bufname, bufdir))
      let width = max([width, len(bufname)])
    endif
    let i = i+1
  endwhile
  let n =  inputlist(s:buflist)
  if n > 0 && buflisted(n)
    silent exe 'buffer '.n
  endif
endf

command! Buffers :call <sid>BufferInputList()
