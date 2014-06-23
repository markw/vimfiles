" Prolog   {{{1
if exists("g:loaded_file_templates")
  finish
endif

let g:loaded_file_templates = 1

let s:save_cpo = &cpo
set cpo&vim


function s:ClassName(s) "{{{1
    let tokens = split(a:s,'\.')
    return substitute(tokens[0], '\<.', '\u&', '')
endf

function s:Expand(variable, value)    "{{{1
	silent! exe "%s/\${" . a:variable . "}/" .  escape(a:value,'/') . "/g"
endf

function s:ExpandFilePathAfter(filedir)  "{{{1
    call cursor(1,1)
    let [row,col] = searchpos('\${FILE_PATH_AFTER\:','W') 

    if row == 0
        return
    endif

    let colonCol = searchpos(':','nW', row)[1]
    let braceCol = searchpos('}','nW', row)[1]
    let tokenlen = braceCol - colonCol - 1
    let after = strpart(getline("."), colonCol, tokenlen)

    let segments = split(a:filedir, "/")
    let afterIndex = index(segments, after)

    if afterIndex >= 0
        unlet segments[0:afterIndex]
    endif

    call s:Expand('FILE_PATH_AFTER:'.after, join(segments, '/'))

    " recurse
    call s:ExpandFilePathAfter(a:filedir)
endf

function s:LoadTemplate(template) "{{{1
    silent exe ':0r '. a:template
    let l:filename   = expand("%:t:r")
    let l:filedir    = expand("%:p:h")
    let l:class      = s:ClassName(l:filename)

    call s:Expand('FILE_NAME',  l:filename)
    call s:Expand('CLASS_NAME', l:class)
    call s:ExpandFilePathAfter(l:filedir)

    call s:PlaceCursor()
endf

function s:NormalizePath(path)  "{{{1
    return substitute(a:path,'\\','/','g')
endf
 
function s:PickFromList(prompt, candidates) "{{{1
  let picklist = [a:prompt]
  let index = 1
  for c in a:candidates
      let l:candidate = fnamemodify(c,":p:t")
      call add(picklist,index.'. '.l:candidate)
      let index += 1
  endfor
  let choice = inputlist(picklist)
  return (choice > 0 && choice <= len(a:candidates))  ? choice : 0
endfunction

function s:PlaceCursor() "{{{1
	call cursor(1,1)
	if search("${^}", "W")
		let l:column = col(".")
		let l:line   = line(".")
		s/${^}//
		call cursor(l:line, l:column)
	endif
endfunction

function s:Main() "{{{1
    if len(&ft) == 0
        return
    endif

    let templateDir = finddir("file-templates", &rtp)

    if len (templateDir) == 0
        echoerr "Could not find file-templates directory on the Vim runtime path"
        return
    endif

    let templateDir = s:NormalizePath(templateDir . '/' . &ft)

    if !isdirectory(templateDir)
        return
    endif

    let templates = split(s:NormalizePath(glob(templateDir . '/*')),'\n')

    if len(templates) == 1
        call s:LoadTemplate(templates[0])
    else 
        let index = s:PickFromList('Pick a template:', templates)
        if index > 0
            call s:LoadTemplate(templates[index-1])
        endif
    endif
endf


" Epilog   {{{1

let &cpo = s:save_cpo
unlet s:save_cpo

command! Template call s:Main()
au BufNewFile * call s:Main()

" vim: set fdm=marker:
