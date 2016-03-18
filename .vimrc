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
Plugin 'tpope/vim-repeat'
Plugin 'tpope/vim-surround'
Plugin 'pangloss/vim-javascript'
Plugin 'kchmck/vim-coffee-script'
Plugin 'derekwyatt/vim-scala'
Plugin 'sukima/xmledit'
Plugin 'guns/vim-clojure-static'
Plugin 'altercation/vim-colors-solarized'
Plugin 'scrooloose/syntastic'
Plugin 'regedarek/ZoomWin'
"Plugin 'amiorin/vim-project'
Plugin 'kien/ctrlp.vim'
Plugin 'kien/rainbow_parentheses.vim'
Plugin 'bling/vim-airline'
Plugin 'qpkorr/vim-bufkill'

call vundle#end()

filetype plugin indent on
syntax on

set expandtab 
set ruler nowrap nobackup
set copyindent autoindent smartindent
set tabstop=4 shiftwidth=4 shiftround
set nostartofline
set wildignore=*.class,*.jar
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

nmap <silent><F3> :call ViewBufferList()<cr>
"nmap <silent><F3> :Buffers<cr>

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

imap jj <esc>

" syntastic settings

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

" Projects
let g:project_use_nerdtree = 0
set rtp+=~/.vim/bundle/vim-project/

if isdirectory("/Users/mwilliams/git")
    call project#rc("~/git")
    Project '~/git/main/cjo/api-int-server/', 'api-int-server'
    Project '~/git/main/cjo/member-web/', 'member-web'
    Project '~/git/main/cjo/member-web/src/main/webapp/javascript/report/clickPath', 'clickpath'
    Project '~/git/jaws', 'jaws'
    Project '~/git/jaws-configuration', 'jaws-configuration'
    Project '~/git/main/data/click-path-analyzer', 'click-path-analyzer'
    Project 'sudoku'
    File    '~/dev/clj/4clojure/sudoku.clj', 'sudoku'

    FileList ['~/git/cis-194-winter-2016/test/Homework/Week05Spec.hs', '~/git/cis-194-winter-2016/src/Homework/Week05/Assignment.hs'], 'haskell-week5'
    Callback  'haskell-week5', 'HaskellTests'

    FileList ['~/git/cis-194-winter-2016/test/Homework/Week06Spec.hs', '~/git/cis-194-winter-2016/src/Homework/Week06/Assignment.hs'], 'haskell-week6'
    Callback  'haskell-week6', 'HaskellTests'

    FileList ['~/git/cis-194-winter-2016/test/Homework/Week07Spec.hs', '~/git/cis-194-winter-2016/src/Homework/Week07/Assignment.hs'], 'haskell-week7'
    Callback  'haskell-week7', 'HaskellTests'

    FileList ['~/git/cis-194-winter-2016/test/Homework/Week09Spec.hs', '~/git/cis-194-winter-2016/src/Homework/Week09/Assignment.hs'], 'haskell-week9'
endif

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
        let idx = stridx(getline(index), '=')
        let eqPos = max([eqPos, idx])
        let index = index + 1
    endwhile
    let index = first
    while index <= last
        exe 'normal ' . index . 'G0'
        if search('=','',index) > 0
            let spacesNeeded = eqPos - col(".") + 1
            if spacesNeeded > 0
                exe 'normal ' . spacesNeeded. 'i '
            endif
        endif
        let index = index + 1
    endwhile
endf

vmap = :call AlignEquals()<cr>

function! AlignVertically()

    " capture indent for current line
    let indent = repeat(' ', indent("."))

    " capture all lines in selected range
    let linesToFormat    = []
    let numTokensPerLine = []

    let firstLineNum = line("'<")
    let lastLineNum  = line("'>")

    let lineNum = firstLineNum

    while lineNum <= lastLineNum
        let tokens = split(getline(lineNum))
        call add(linesToFormat, tokens)
        call add(numTokensPerLine, len(tokens))
        let lineNum = lineNum + 1
    endwhile

    let maxLengths = repeat([1], max(numTokensPerLine))

    " calc max length for each token position

    for tokens in linesToFormat
        let tokenNum = 0
        for token in tokens
            let maxLengths[tokenNum] = max([maxLengths[tokenNum], len(token)])
            let tokenNum = tokenNum + 1
        endfor
    endfor
    
    " re-render each line, formatted
    let lineNum = firstLineNum
    for tokens in linesToFormat
        let s = indent
        let tokenNum = 0
        for token in tokens
            let length = get(maxLengths,tokenNum) + 1
            let mask = "%-" . length . "s"
            let s = s . printf(mask, token)
            let tokenNum = tokenNum + 1
        endfor
        call setline(lineNum, s)
        let lineNum = lineNum + 1
    endfor
endfunction

vmap <space> :call AlignVertically()<cr>

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

set titleold=

au ColorScheme * so $HOME/.vim/after/colors/fix-colors.vim
let g:solarized_termcolors=256
let g:solarized_termtrans=1
set bg=dark
color solarized
let macvim_skip_colorscheme=1

map <F6> :bn<cr>
map <S-F6> :sbn<cr>
map <leader><F6> :vert :sbn<cr>
map <tab> <c-w>w
