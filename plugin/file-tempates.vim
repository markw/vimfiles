if exists("g:loaded_file_templates")
  finish
endif

let g:loaded_file_templates = 1

let s:save_cpo = &cpo
set cpo&vim

function s:PlaceCursor()
	0 
	if search("${^}", "W")
		let l:column = col(".")
		let l:lineno = line(".")
		s/${^}//
		call cursor(l:lineno, l:column)
	endif
endfunction

function! s:NormalizePath(path)
    return substitute(a:path,'\\','/','g')
endf
 
function! s:Start() "{{{1
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
        echoerr "Not found " . templateDir
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

function s:Expand(variable, value)
	silent! exe "%s/\${" . a:variable . "}/" .  a:value . "/g"
endf

function! s:LoadTemplate(template) "{{{1
    silent exe ':0r '. a:template
    let l:filename   = expand("%:t:r")
    let l:class      = substitute(l:filename, "\\([a-zA-Z]\\+\\)", "\\u\\1\\e", "g")

    call s:Expand('FILE_NAME',  l:filename)
    call s:Expand('CLASS_NAME', l:class)
    call s:PlaceCursor()
endf

function! s:PickFromList(prompt, candidates) "{{{1
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



let &cpo = s:save_cpo
unlet s:save_cpo

command! Template call s:Start()
au BufNewFile * call s:Start()
