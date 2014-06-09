"set background=dark
"color msw3
"color msw2
"color msw
color desert
"color mango

set lines=999 columns=999

"set guifont=Droid\ Sans\ Mono\ Slashed\ 10
"set guifont=DejaVu\ Sans\ Mono\ 10
"set guifont=Inconsolata\ Medium\ 12
set guifont=Ubuntu\ Mono\ 12

"
set clipboard=unnamed
set guioptions-=T
set guioptions-=r
set guioptions-=R
winpos 0 0

" no visualbell
set vb t_vb=

" highlight current line
"autocmd WinLeave * setlocal nocursorline
"autocmd WinEnter * setlocal cursorline
"autocmd BufLeave * setlocal nocursorline
"autocmd BufEnter * setlocal cursorline 

set guitablabel=%{GuiTabLabel()}
"set showtabline=1


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

nnoremap <silent> <F8> :TlistToggle<CR>
