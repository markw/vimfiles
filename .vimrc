set nocompatible
let mapleader = ","
set termguicolors

set rtp+=~/.vim/bundle/vundle/
filetype off

"-------------------------------------------------------------
" vundle
"-------------------------------------------------------------
call vundle#begin()
Plugin 'gmarik/vundle'
Plugin 'scrooloose/nerdtree'
Plugin 'ervandew/supertab'
Plugin 'tomtom/tlib_vim'
Plugin 'MarcWeber/vim-addon-mw-utils'
Plugin 'garbas/vim-snipmate'
Plugin 'tpope/vim-fugitive'
Plugin 'tpope/vim-surround'
Plugin 'tpope/vim-fireplace'
Plugin 'pangloss/vim-javascript'
Plugin 'derekwyatt/vim-scala'
Plugin 'sukima/xmledit'
Plugin 'guns/vim-clojure-static'
Plugin 'altercation/vim-colors-solarized'
Plugin 'scrooloose/syntastic'
Plugin 'regedarek/ZoomWin'
"Plugin 'amiorin/vim-project'
Plugin 'kien/ctrlp.vim'
Plugin 'bling/vim-airline'
Plugin 'mxw/vim-jsx'
Plugin 'tomasiser/vim-code-dark'
Plugin 'vim-scripts/oceandeep'
Plugin 'lifepillar/vim-solarized8'
Plugin 'wincent/command-t'
"Plugin 'bhurlow/vim-parinfer'
"Bundle 'venantius/vim-cljfmt'
Plugin 'eraserhd/parinfer-rust'
Plugin 'zcodes/vim-colors-basic'

call vundle#end()

"-------------------------------------------------------------
" settings
"-------------------------------------------------------------
filetype plugin indent on
syntax on

set expandtab 
set ruler nowrap nobackup
set copyindent autoindent smartindent
set tabstop=4 shiftwidth=4 shiftround
set nostartofline
set wildignore=*.class,*.jar,node_modules,.git
set notitle
set mouse=a
"set autochdir
set number
set directory=~/tmp,/tmp
set novisualbell noerrorbells 
set vb t_vb=
set hidden
set showcmd
set updatetime=1000
set clipboard=unnamed
set tags=tags,./tags;
set grepprg=rg\ -n\ -g\ '!node_modules'\ -g\ '!lib'

"-------------------------------------------------------------
" key mappings
"-------------------------------------------------------------

nnoremap <Leader>P :ptag <cword><cr>
nnoremap <c-tab> :bnext<cr>
nnoremap <s-c-tab> :bprev<cr>
inoremap jj <esc>
map <F6> :bn<cr>
map <S-F6> :sbn<cr>
map <leader><F6> :vert :sbn<cr>
"map <tab> <c-w>w
map <Leader>g :silent! :grep! <cword><cr>:cl<cr>
nmap <silent><F3> :call ViewBufferList()<cr>
"nmap <silent><F3> :Buffers<cr>

"-------------------------------------------------------------
" auto commands
"-------------------------------------------------------------
"todo: move somewhere else
autocmd BufNewFile *.xsl  :0r ~/.vim/templates/template.xsl
autocmd BufNewFile *.html :0r ~/.vim/templates/template.html
autocmd BufNewFile *.jsp  :0r ~/.vim/templates/template.jsp
autocmd BufNewFile build.xml  :0r ~/.vim/templates/build.xml
autocmd BufNewFile build.properties  :0r ~/.vim/templates/build.properties
autocmd BufNewFile *.groovy  :0r ~/.vim/templates/template.groovy
autocmd BufLeave *.xsl aunmenu Xsl
au BufReadCmd *.jar call zip#Browse(expand("<amatch>"))
"au BufEnter * exe 'set title titlestring='.expand("%:t")
au BufEnter * set cursorline
au BufLeave * set nocursorline
au WinEnter * set cursorline
au WinLeave * set nocursorline

"-------------------------------------------------------------
"NERDTree customizations
"-------------------------------------------------------------

nnoremap <F2> :NERDTreeToggle<cr>
nmap <Leader>t :NERDTreeFind<cr>

cabbrev ntfb NERDTreeFromBookmark
cabbrev ntt NERDTreeToggle
cabbrev nt NERDTree
cabbrev mt MavenTest %
cabbrev bk Bookmark

let NERDTreeHijackNetrw=1
let NERDTreeWinSize=50
let NERDTreeIgnore=['target','\.class$', '\~$']
let NERDTreeMouseMode=3

"-------------------------------------------------------------
" syntastic settings
"-------------------------------------------------------------

set statusline=%n\ %t\ %M%r%=%l,%c
set statusline+=%#warningmsg#
set statusline+=%{SyntasticStatuslineFlag()}
set statusline+=%*

let g:syntastic_always_populate_loc_list = 1
let g:syntastic_auto_loc_list = 1
let g:syntastic_check_on_open = 0
let g:syntastic_check_on_wq = 0

let g:syntastic_javascript_checkers = ['jsxhint']
let g:syntastic_java_checkers=['']

let g:syntastic_mode_map = {
    \ "mode" : "active" , 
    \ "active_filetypes" : ["js","javascript"],
    \ "passive_filetypes" : ["java","scala"] }

"-------------------------------------------------------------
" Projects
"-------------------------------------------------------------

"let g:project_use_nerdtree = 0
"set rtp+=~/.vim/bundle/vim-project/

"-------------------------------------------------------------
" airline / powerline
"-------------------------------------------------------------
let g:airline_powerline_fonts = 0
set laststatus=2

if !exists('g:airline_symbols')
let g:airline_symbols = {}
endif

" powerline symbols
let g:airline_left_sep = ''
let g:airline_left_alt_sep = ''
let g:airline_right_sep = ''
let g:airline_right_alt_sep = ''
let g:airline_symbols.branch = ''
let g:airline_symbols.readonly = ''
let g:airline_symbols.linenr = ''
let g:airline_theme='codedark'

set titleold=

"-------------------------------------------------------------
" colors
"-------------------------------------------------------------
au ColorScheme * so $HOME/.vim/after/colors/fix-colors.vim
let g:solarized_termcolors=256
let g:solarized_termtrans=1
set bg=dark
"color solarized
"color codedark
"color oceandeep
color basic-dark
let macvim_skip_colorscheme=1

"-------------------------------------------------------------
" vim-jsx
"-------------------------------------------------------------
let g:jsx_ext_required = 0

"-------------------------------------------------------------
" ctrl-p
"-------------------------------------------------------------
let g:ctrlp_custom_ignore='.git,node_modules'
