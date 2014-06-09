set nocompatible

set rtp+=~/.vim/bundle/vundle/
filetype off

call vundle#begin()
Plugin 'gmarik/Vundle.vim'
Plugin 'scrooloose/nerdtree'
Plugin 'ervandew/supertab'
Plugin 'tomtom/tlib_vim'
Plugin 'MarcWeber/vim-addon-mw-utils'
Plugin 'kchmck/vim-coffee-script'
Plugin 'tpope/vim-fugitive'
Plugin 'garbas/vim-snipmate'
call vundle#end()

filetype plugin indent on
syntax on

set expandtab 
set ruler nowrap nobackup
set copyindent autoindent smartindent
set tabstop=4 shiftwidth=4 shiftround
set nostartofline
set noshowmatch
set autochdir
set number
set directory=~/tmp,/tmp
set novisualbell noerrorbells 
set vb t_vb=
set hidden
set showcmd


nnoremap <c-tab> :bnext<cr>
nnoremap <s-c-tab> :bprev<cr>
nnoremap <F2> :NERDTreeToggle<cr>

function! UrlEscape()
let c = getline(".")[col(".") - 1]
let cmd = ''
if c == ':' | let cmd = 's%3A' | endif
if c == '/' | let cmd = 's%2F' | endif
if c == '?' | let cmd = 's%3F' | endif
if c == '=' | let cmd = 's%3D' | endif
if c == '&' | let cmd = 's%26' | endif
if len(cmd) > 0
    exe 'normal '.cmd
endif
endf


let NERDTreeHijackNetrw=1
let NERDTreeIgnore=['target','\.class$', '\~$']

"todo: move somewhere else
autocmd BufNewFile *.xsl  :0r ~/.vim/templates/template.xsl
autocmd BufNewFile *.html :0r ~/.vim/templates/template.html
autocmd BufNewFile *.jsp  :0r ~/.vim/templates/template.jsp
autocmd BufNewFile build.xml  :0r ~/.vim/templates/build.xml
autocmd BufNewFile build.properties  :0r ~/.vim/templates/build.properties
autocmd BufNewFile *.groovy  :0r ~/.vim/templates/template.groovy

autocmd BufLeave *.xsl aunmenu Xsl
au BufReadCmd *.jar,*.xpi call zip#Browse(expand("<amatch>"))

hi comment cterm=bold

au BufEnter * set cursorline
au BufLeave * set nocursorline
au WinEnter * set cursorline
au WinLeave * set nocursorline

au ColorScheme * so $HOME/.vim/after/colors/fix-colors.vim
color desert
