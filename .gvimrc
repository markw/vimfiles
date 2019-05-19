"set background=dark
"color msw3
"color msw2
"color msw
"color desert
"color solarized
color oceandeep
"set bg=light
"color mango

set lines=80 columns=160

"set guifont=Droid\ Sans\ Mono\ Slashed\ 10
"set guifont=DejaVu\ Sans\ Mono\ 10
"set guifont=Inconsolata\ Medium\ 12
set guifont=Droid\ Sans\ Mono\ Slashed\ For\ Powerline:h14
"set guifont=Ubuntu\ Mono\ 12,Consolas:h12
"set guifont=Meslo\ LG\ S\ for\ Powerline:h14

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
