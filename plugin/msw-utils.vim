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

command! UrlEscape call UrlEscape()

function! RemoveTrailingWhitespace()
    let l:save = winsaveview()
    %s/\s\+$//e
    call winrestview(l:save)
endf

command! RemoveTrailingWhitespace call RemoveTrailingWhitespace()

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

vmap <Leader><space> :call AlignVertically()<cr>

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

vmap <Leader>= :call AlignEquals()<cr>

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

function! Unicode()
    let dec = char2nr(matchstr(getline('.'), '\%' . col('.') . 'c.'))
    let unicode = printf("\\u%04x", dec)
    exe 'normal s'.unicode
endf
