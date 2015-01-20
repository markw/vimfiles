"set background=dark
"color msw3
"color msw2
"color msw
color desert
"color mango

set lines=60 columns=160

"set guifont=Droid\ Sans\ Mono\ Slashed\ 10
"set guifont=DejaVu\ Sans\ Mono\ 10
"set guifont=Inconsolata\ Medium\ 12
"set guifont=Ubuntu\ Mono\ 12
set guifont=Source\ Code\ Pro\ 11,Ubuntu\ Mono\ 12,Droid\ Sans\ Mono\ Slashed\ 11

"
set clipboard=unnamed
set guioptions-=T
set guioptions-=r
set guioptions-=R
set t_vb=
winpos 0 0

" highlight current line
set cursorline

set guitablabel=%{GuiTabLabel()}


function! GuiTabLabel()
  let label = ''
  let bufnrlist = tabpagebuflist(v:lnum)

  " Add '+' if one of the buffers in the tab page is modified
  for bufnr in bufnrlist
    if getbufvar(bufnr, "&modified")
      let label = '* '
      break
    endif
  endfor

  " Append the buffer name
  return label . fnamemodify(bufname(bufnrlist[tabpagewinnr(v:lnum) - 1]),":t")
endfunction
