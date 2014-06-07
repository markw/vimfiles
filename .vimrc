set nocompatible
execute pathogen#infect()

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
set hidden
set showcmd

filetype plugin indent on
syntax on

hi comment cterm=bold

nnoremap <c-tab> :bnext<cr>
nnoremap <s-c-tab> :bprev<cr>

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

"netrw default to tree view
let g:netrw_liststyle=3

"get rid of the banner
let g:netrw_banner=0

color desert

"todo: move to separate plugin
autocmd BufNewFile *.xsl  :0r ~/.vim/templates/template.xsl
autocmd BufNewFile *.html :0r ~/.vim/templates/template.html
autocmd BufNewFile *.jsp  :0r ~/.vim/templates/template.jsp
autocmd BufNewFile build.xml  :0r ~/.vim/templates/build.xml
autocmd BufNewFile build.properties  :0r ~/.vim/templates/build.properties
autocmd BufNewFile *.groovy  :0r ~/.vim/templates/template.groovy

autocmd BufLeave *.xsl aunmenu Xsl
au BufReadCmd *.jar,*.xpi call zip#Browse(expand("<amatch>"))
