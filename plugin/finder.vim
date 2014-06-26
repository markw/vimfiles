if !exists('g:maven_exec')
  let g:maven_exec= 'mvn'
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

function! s:PickFromList(candidates) "{{{1
  let picklist = ['Select one:']
  let index = 1
  for c in a:candidates
      call add(picklist,index.'. '.c)
      let index += 1
  endfor
  return inputlist(picklist)
endfunction

function! s:GrepIndexFile(s)            "{{{1
  let pattern = substitute(a:s,'\([A-Z]\)','[a-z1-9]*\1[a-z1-9]*', 'g').'.*'
  return split(system("grep '".pattern."' ". s:FindProjectRoot() ."/.vimindex"))
endf

function! s:FindInIndexFile(s)  "{{{1
  let filenames = s:GrepIndexFile(a:s)
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

  let index = s:PickFromList(filenames)
  if index <= 0 || index > len(filenames) | return | endif
  call s:ActivateBuffer(filenames[index-1])
endf


function! s:FindFilesInIndex(files)  "{{{1
  for f in split(a:files)
    call s:FindInIndexFile(f)
  endfor
endf

function! s:CreateVimIndexes()    "{{{1
  let root = fnamemodify(s:FindProjectRoot(),":p:h")
  let srcdirs = map(finddir('src',root.'/**5',-1),"fnamemodify(v:val,':p')")
  echo "Building index file: ".root.'/.vimindex'
  call system('find '.join(srcdirs,' ').' -type f -fprint '.root. '/.vimindex 2> /dev/null')
  echo "Done."
endf

function! s:RunMaven(cmd)  "{{{1
  if &modified == 1
    exe 'w'
  endif
  let savedir = getcwd()
  let pom = findfile('pom.xml', savedir.';')
  let pomdir = fnamemodify(pom,":p:h")

  exe "setlocal makeprg=".a:cmd
  
  setlocal errorformat=[ERROR]\ %f:[%l\\,%c]%m

  silent exe "lcd ".pomdir

  make!
  "echo &makeprg

  silent exe "lcd ".savedir
endf

function! s:MavenQunitTestDir(path) "{{{1
    let segments = split(a:path,'/')
    let jsIndex = index(segments,'javascript')
    let subpath = join(segments[jsIndex+1 :], '/')
    let cmd = g:maven_exec.'\ -o\ -Dsurefire.useFile=false\ qunit:test\ -Dqunit.filter='.subpath
    silent exe 'lcd '.a:path
    call s:RunMaven(cmd)
endf

function! s:MavenQunitTestFile(path) "{{{1
    let segments = split(a:path,'/')
    let filedir = '/'.join(segments[:-2], '/')

    if len(filedir) > 0
        silent exe 'lcd '.filedir
    endif

    let fname = fnamemodify(segments[-1],":t:r")

    if fname !~ '\.qunit$'
        let fname = fname . '.qunit'
    endif

    let cmd = g:maven_exec.'\ -o\ -Dsurefire.useFile=false\ qunit:test\ -Dqunit.filter=' . fname

    call s:RunMaven(cmd)
endf

function! s:MavenUnitTest(file)  "{{{1
  let testname = fnamemodify(a:file,":r")

  if &ft == 'coffee' || &ft == 'javascript'
    "let cmd = g:maven_exec.'\ -o\ -Dsurefire.useFile=false\ qunit:test\ -Dqunit.filter='.testname
    "call s:RunMaven(cmd)
    call s:MavenQunitTestFile(a:file)
  endif

  if &ft == 'java'
    if testname !~ 'Test$'
        let testname = testname.'Test'
    endif
    let cmd = g:maven_exec.'\ -oq\ -Dsurefire.useFile=false\ test\ -Dtest='.testname
    call s:RunMaven(cmd)
  endif

endf

function! s:GrepFromProjectRoot(s) "{{{1
  setlocal grepprg=grep\ -n\ -R
  let root = s:FindProjectRoot()
  let srcdirs = join(finddir('src',root.'/**5',-1),' ')
  exe ':grep '.a:s.' '.srcdirs
endf

function! s:ProjectPath()  "{{{1
  let root = fnamemodify(s:FindProjectRoot(),":p:h")
  let srcdirs = finddir('src',root.'/**5',-1)
  return join(map(srcdirs, "v:val .'/**'"),',')
endf

function! s:AutoComplete(A,L,P)   "{{{1
  let filenames = []
  for f in s:GrepIndexFile(a:A)
      call add(filenames,fnamemodify(f,":t"))
  endfor
  return filenames
endf

"}}}1
" Commands   {{{1
command! -nargs=0 Make               call s:RunMaven(g:maven_exec.'\ clean\ install')
command! -nargs=1 MavenTest          call s:MavenUnitTest(<q-args>)
command! -nargs=1 MavenQunitTest     call s:MavenQunitTest(<q-args>)
command! -nargs=1 MavenQunitTestDir  call s:MavenQunitTestDir(<q-args>)
command! -nargs=1 MavenQunitTestFile call s:MavenQunitTestFile(<q-args>)
command! -nargs=0 Index              call s:CreateVimIndexes()
command! -nargs=1 Grep               call s:GrepFromProjectRoot(<q-args>)
command! -nargs=+ -complete=customlist,s:AutoComplete Find  call s:FindFilesInIndex(<q-args>)


" Mappings  {{{1
nmap <F4> :call <SID>FindInIndexFile(expand('<cword>'))<cr>
nmap <F9> :call <SID>MavenUnitTest(fnamemodify(expand("%"),":p"))<cr>
" 1}}}

au BufEnter,VimEnter * exe 'setlocal path='.s:ProjectPath()

" vim: set fdm=marker:
