set nocompatible

set rtp+=~/.vim/bundle/vundle/
filetype off

call vundle#begin()
Plugin 'gmarik/vundle'
Plugin 'scrooloose/nerdtree'
Plugin 'ervandew/supertab'
Plugin 'tomtom/tlib_vim'
Plugin 'MarcWeber/vim-addon-mw-utils'
Plugin 'garbas/vim-snipmate'
Plugin 'tpope/vim-fugitive'
Plugin 'tpope/vim-surround'
Plugin 'pangloss/vim-javascript'
Plugin 'kchmck/vim-coffee-script'
Plugin 'derekwyatt/vim-scala'
Plugin 'sukima/xmledit'
Plugin 'guns/vim-clojure-static'
Plugin 'altercation/vim-colors-solarized'
Plugin 'scrooloose/syntastic'
Plugin 'regedarek/ZoomWin'
Plugin 'amiorin/vim-project'
Plugin 'kien/ctrlp.vim'

call vundle#end()

filetype plugin indent on
syntax on

set expandtab 
set ruler nowrap nobackup
set copyindent autoindent smartindent
set tabstop=4 shiftwidth=4 shiftround
set nostartofline
set wildignore=*.class,*.jar

"set autochdir
set number
set directory=~/tmp,/tmp
set novisualbell noerrorbells 
set vb t_vb=
set hidden
set showcmd
set updatetime=1000

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


"todo: move somewhere else
autocmd BufNewFile *.xsl  :0r ~/.vim/templates/template.xsl
autocmd BufNewFile *.html :0r ~/.vim/templates/template.html
autocmd BufNewFile *.jsp  :0r ~/.vim/templates/template.jsp
autocmd BufNewFile build.xml  :0r ~/.vim/templates/build.xml
autocmd BufNewFile build.properties  :0r ~/.vim/templates/build.properties
autocmd BufNewFile *.groovy  :0r ~/.vim/templates/template.groovy

autocmd BufLeave *.xsl aunmenu Xsl
au BufReadCmd *.jar call zip#Browse(expand("<amatch>"))

hi comment cterm=bold

au BufEnter * exe 'set title titlestring='.expand("%:t")
au BufEnter * set cursorline
au BufLeave * set nocursorline
au WinEnter * set cursorline
au WinLeave * set nocursorline

au ColorScheme * so $HOME/.vim/after/colors/fix-colors.vim
color desert

"nmap <silent><F3> :call ViewBufferList()<cr>
nmap <silent><F3> :Buffers<cr>

"-------------------------------------------------------------
"NERDTree customizations
"-------------------------------------------------------------

nnoremap <F2> :NERDTreeToggle<cr>

cabbrev ntfb NERDTreeFromBookmark
cabbrev ntt NERDTreeToggle
cabbrev nt NERDTree
cabbrev mt MavenTest %
cabbrev bk Bookmark

let NERDTreeHijackNetrw=1
let NERDTreeWinSize=50
let NERDTreeIgnore=['target','\.class$', '\~$']

imap jj <esc>

" syntastic settings

set statusline+=%#warningmsg#
set statusline+=%{SyntasticStatuslineFlag()}
set statusline+=%*

let g:syntastic_always_populate_loc_list = 1
let g:syntastic_auto_loc_list = 1
let g:syntastic_check_on_open = 0
let g:syntastic_check_on_wq = 0

let g:syntastic_javascript_checkers = ['jsxhint']
let g:syntastic_java_checkers=['']

" Projects
let g:project_use_nerdtree = 1
set rtp+=~/.vim/bundle/vim-project/

call project#rc("~/git")
Project '~/git/main/cjo/member-web/', 'member-web'
Project '~/git/main/cjo/member-web/src/main/webapp/javascript/report/clickPath', 'clickpath'
Project '~/git/jaws', 'jaws'
Project '~/git/jaws-configuration', 'jaws-configuration'

function! s:CompareTwoLines()
    let thisLine = getline(".")
    let nextLine = getline(line(".")+1)
    let thisLen  = strlen(thisLine)
    let nextLen  = strlen(nextLine)
    let numChars = min([thisLen, nextLen]) - 1
    let index = col(".")
    while index < numChars
        if strpart(thisLine, index, 1) != strpart(nextLine, index, 1)
            exe 'normal '. index . '|l'
            return
        endif
        let index = index + 1
    endwhile
    if thisLen != nextLen
        exe 'normal '. index . '|l'
        return
    endif
    echo "No differences found"
endf

command! CompareLines call s:CompareTwoLines()

function! AlignEquals()
    let first = line("'<")
    let last =  line("'>")
    let index = first
    let eqPos = 0
    while index <= last
        exe 'normal ' . index . 'G0'
        call search('=','',index)
        let eqPos = max([eqPos, col(".")])
        let index = index + 1
    endwhile
    let index = first
    while index <= last
        exe 'normal ' . index . 'G0'
        if search('=','',index) > 0
            f=
            let spacesNeeded = eqPos - col(".")
            exe 'normal  i' . spacesNeeded
        endif
        let index = index + 1
    endwhile
endf

