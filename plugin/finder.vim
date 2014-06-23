if !exists('g:maven_exec')
  let g:maven_exec= 'm3'
endif

function! s:ActivateBuffer(name) "{{{1
  if has('GUI')
    exe ':drop '.a:name
  else
    exe ':e '.a:name
  endif
  return
endfunction

function! s:FindFileRecursive(file,dir,curr) "{{{1
    let found = findfile(a:file,a:dir.';')
    if len(found)
        return s:FindFileRecursive(a:file,fnamemodify(found,":p:h:h"),found)
    elseif len(a:curr)
        return a:curr
    else
        "throw "No project root"
    endif
endf

function! s:FindProjectRoot() "{{{1
  return s:FindProjectRootFrom('.')
endf

function! s:FindProjectRootFrom(dir) "{{{1
  return fnamemodify(s:FindFileRecursive('pom.xml',a:dir,''),":p:h")
endf

function! <SID>PickFromList(candidates) "{{{1
  let picklist = ['Select one:']
  let index = 1
  for c in a:candidates
      call add(picklist,index.'. '.c)
      let index += 1
  endfor
  return inputlist(picklist)
endfunction

function! <SID>GrepIndexFile(s)            "{{{1
  let pattern = substitute(a:s,'\([A-Z]\)','[a-z1-9]*\1[a-z1-9]*', 'g').'.*'
  return split(system("grep '".pattern."' ". s:FindProjectRoot() ."/.vimindex"))
endf

function! <SID>FindInIndexFile(s)  "{{{1
  let filenames = <SID>GrepIndexFile(a:s)
  let numMatches = len(filenames)

  if 0 == numMatches
    echoerr "No matches."
    return
  endif

  if 1 == numMatches
    call s:ActivateBuffer(filenames[0])
    return
  endif

  if 100 < numMatches
    echoerr "Too many matches: ".numMatches
    return
  endif

  let index = <SID>PickFromList(filenames)
  if index <= 0 || index > len(filenames) | return | endif
  call s:ActivateBuffer(filenames[index-1])
endf


function! <SID>FindFilesInIndex(files)  "{{{1
  for f in split(a:files)
    call <SID>FindInIndexFile(f)
  endfor
endf

function! <SID>CreateVimIndexes()    "{{{1
  let root = s:FindProjectRoot()
  echo "Building index file: ".root.'/.vimindex'
  call system('find '. root .'/*/src  -type f -fprint '. root . '/.vimindex 2> /dev/null')
  echo "Done."
endf

function! <SID>RunMaven(cmd)  "{{{1
  if &modified == 1
    exe 'w'
  endif
  let savedir = getcwd()
  let pom = findfile('pom.xml', savedir.';')
  let pomdir = fnamemodify(pom,":p:h")

  exe "setlocal makeprg=".a:cmd
  
  setlocal errorformat=%A%f:%l:\ %m,%-Z%p^,%-C%.%#

  silent exe "lcd ".pomdir

  make!
  "echo &makeprg

  silent exe "lcd ".savedir
endf

function! <SID>MavenQunitTestDir(path) "{{{1
    let segments = split(a:path,'/')
    let jsIndex = index(segments,'javascript')
    let subpath = join(segments[jsIndex+1 :], '/')
    let cmd = g:maven_exec.'\ -o\ -Dsurefire.useFile=false\ qunit:test\ -Dqunit.filter='.subpath
    silent exe 'lcd '.a:path
    call <SID>RunMaven(cmd)
endf

function! <SID>MavenQunitTestFile(path) "{{{1
    let segments = split(a:path,'/')
    let filedir = '/'.join(segments[:-2], '/')

    if len(filedir) > 0
        silent exe 'lcd '.filedir
    endif

    let fname = fnamemodify(segments[-1],":t:r")

    if fname !~ '\.qunit$'
        fname = fname . '.qunit'
    endif

    let cmd = g:maven_exec.'\ -o\ -Dsurefire.useFile=false\ qunit:test\ -Dqunit.filter=' . fname

    call <SID>RunMaven(cmd)
endf

function! <SID>MavenUnitTest(file)  "{{{1
  let testname = fnamemodify(a:file,":r")

  if &ft == 'coffee' || &ft == 'javascript'
    "let cmd = g:maven_exec.'\ -o\ -Dsurefire.useFile=false\ qunit:test\ -Dqunit.filter='.testname
    "call <SID>RunMaven(cmd)
    call <SID>MavenQunitTestFile(a:file)
  endif

  if &ft == 'java'
    if testname !~ 'Test$'
        let testname = testname.'Test'
    endif
    let cmd = g:maven_exec.'\ -oq\ -Dsurefire.useFile=false\ test\ -Dtest='.testname
    call <SID>RunMaven(cmd)
  endif

endf

function! <SID>GrepFromProjectRoot(s) "{{{1
  setlocal grepprg=grep\ -n\ -R
  exe ':grep '.a:s.' '.s:FindProjectRoot().'/*/src'
endf

function! <SID>AutoComplete(A,L,P)   "{{{1
  let filenames = []
  for f in <SID>GrepIndexFile(a:A)
      call add(filenames,fnamemodify(f,":t"))
  endfor
  return filenames
endf

"}}}1
command! -nargs=1 MavenTest          call <SID>MavenUnitTest(<q-args>)
command! -nargs=1 MavenQunitTest     call <SID>MavenQunitTest(<q-args>)
command! -nargs=1 MavenQunitTestDir  call <SID>MavenQunitTestDir(<q-args>)
command! -nargs=1 MavenQunitTestFile call <SID>MavenQunitTestFile(<q-args>)
command! -nargs=0 Index              call <SID>CreateVimIndexes()
command! -nargs=1 Grep               call <SID>GrepFromProjectRoot(<q-args>)
command! -nargs=+ -complete=customlist,<SID>AutoComplete Find  call <SID>FindFilesInIndex(<q-args>)

nmap <F4> :call <SID>FindInIndexFile(expand('<cword>'))<cr>

nmap <F9> :call <SID>MavenUnitTest(fnamemodify(expand("%"),":p"))<cr>

"au BufEnter,VimEnter * exe 'setlocal path='.fnamemodify(findfile('pom.xml','.;'), ':p:h').'/src/**,./**'
au BufEnter,VimEnter * exe 'setlocal path='.fnamemodify(s:FindProjectRoot(), ':p:h').'/*/src/**,./*'

" vim: set fdm=marker:
