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

function! s:AutoComplete(A,L,P)   "{{{1
  let filenames = []
  for f in s:GrepIndexFile(a:A)
      call add(filenames,fnamemodify(f,":t"))
  endfor
  return filenames
endf

function! s:CreateVimIndexes()    "{{{1
  let root = fnamemodify(s:FindProjectRoot(),":p:h")
  echo "root=".root
  let srcdirs = map(finddir('src',root.'/**5',-1),"fnamemodify(v:val,':p')")
  " a tragically ugly hack
  call add(srcdirs, root.'/cjo/member-web/client/test')
  " end of tragically ugly hack
  echo "Building index file: ".root.'/.vimindex'
  echo 'find '.join(srcdirs,' ').' -type f -print '.root. '/.vimindex 2> /dev/null'
  call system('find '.join(srcdirs,' ').' -type f -print > '.root. '/.vimindex 2> /dev/null')
  echo "Done."
endf

function! s:FindFile(dir,...)  "{{{1

    function! FindFile0(dir,files)
        for f in a:files
            if filereadable(a:dir.'/'.f)
                return a:dir
            endif
        endfor
        return (a:dir == '.' || a:dir == '/' || toupper(a:dir) == 'C:\' || a:dir =~ 'zipfile:') ? '' : FindFile0(fnamemodify(a:dir,":h"), a:files)
    endf
    
    return FindFile0(a:dir, a:000)
endf

function! s:FindModuleRoot(dir) "{{{1
    return s:FindFile(a:dir,"pom.xml", "build.sbt","build.gradle")
endf


function! s:FindProjectRoot() "{{{1

    function! FindProjectRoot0(dir, lastFound)
        "echo a:dir. ' ' . a:lastFound
        let found =  s:FindModuleRoot(a:dir)
        if len(found) > 0
            let parent = fnamemodify(found,":p:h:h")
            silent exe "lcd ". parent
            return FindProjectRoot0(parent, found)
        elseif len(a:lastFound)
            return a:lastFound
        else
            throw "No project root"
        endif
    endf

    let curdir = getcwd()
    let result = FindProjectRoot0(curdir,'')
    silent exe "lcd ". curdir
    return result
endf

function! s:GrepIndexFile(s)            "{{{1
  let pattern = substitute(a:s,'\([A-Z]\)','[a-z1-9]*\1[a-z1-9]*', 'g').'.*'
  let root = fnamemodify(s:FindProjectRoot(),":p:h")
  return split(system("grep '".pattern."' ". root ."/.vimindex"))
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

function! s:RunMaven(cmd)  "{{{1
  if &modified == 1
    exe 'w'
  endif
  let savedir = getcwd()
  let pom = findfile('pom.xml', savedir.';')
  let pomdir = fnamemodify(pom,":p:h")

  exe "setlocal makeprg=".a:cmd
  
  setlocal errorformat=[ERROR]\ %f:[%l\\,%c]%m,%E%n.\ ERROR\ in\ %f\ (at\ line\ %l),%-C,%-C\\\\t%.%#,%Z%m

  exe "silent lcd ".pomdir
  make! 
  exe "silent lcd ".savedir
  let is_failure = 0
  for line in getqflist()
      if stridx(line['text'], 'BUILD FAILURE') > -1
          let is_failure = 1
      endif
  endfor
  if is_failure | :cc | else | exe "normal \<cr>" | endif
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
  let file = (a:file == "%" ? expand("%") : a:file)
  let testname = fnamemodify(file,":t:r")
  echom testname

  if &ft == 'coffee' || &ft == 'javascript'
    "let cmd = g:maven_exec.'\ -o\ -Dsurefire.useFile=false\ qunit:test\ -Dqunit.filter='.testname
    "call s:RunMaven(cmd)
    call s:MavenQunitTestFile(a:file)
  endif

  if &ft == 'java' || &ft == 'groovy'
    if testname !~ 'Test$' && testname !~ 'Integration'
        let testname = testname.'Test'
    endif
    let cmd = g:maven_exec.'\ -o\ -Dsurefire.useFile=false\ test\ -Dtest='.testname
    call s:RunMaven(cmd)
  endif

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

function! s:GrepFromProjectRoot(s) "{{{1
  setlocal grepprg=grep\ -n\ -R
  let root = s:FindProjectRoot()
  if len(root) == 0
      return
  endif
  let root = fnamemodify(root,":p:h")
  let srcdirs = join(finddir('src',root.'/**5',-1),' ')
  exe ':grep '.a:s.' '.srcdirs
endf

function! s:GrepFromModuleRoot(s) "{{{1
  setlocal grepprg=grep\ -n\ -R
  let root = &path
  if len(root) == 0
      return
  endif
  let root = fnamemodify(root,":p:h")
  let srcdirs = join(finddir('src',root.'/**5',-1),' ')
  silent exe ':grep '.a:s.' '.srcdirs
  redraw!
endf

function! s:ProjectPath()  "{{{1
    let root =  s:FindProjectRoot()
    if len(root) == 0
        return './*'
    endif
    let root = fnamemodify(root,":p:h")
    let srcdirs = finddir('src',root.'/**3',-1)
    return join(map(srcdirs, "v:val .'/**'"),',')
endf

function! s:QuickFixZenOutput() "{{{1
    if &ft == 'help'
        return
    endif
    setlocal errorformat=%f:[%l\\,%c]%m,%f:%l\ col\ %c:\ %m,[ERROR]\ %f:%l\ col\ %c:\ %m,[ERROR]\ %f:[%l\\,%c]%m,%E%n.\ ERROR\ in\ %f\ (at\ line\ %l),%-C,%-C\\\\t%.%#,%Z%m
    let file = '/tmp/zen.out'
    if filereadable(file)
        exe 'cfile '.file
    endif
endf

function! s:SetPath() "{{{1
    let root = s:FindModuleRoot(fnamemodify(expand('%'),":p:h"))
    if len(root) > 0
        exe 'setlocal path='.root.'/src/**,'.root.'/client/**'
    endif
endf

" Commands   {{{1
command! -nargs=0                                      Make               call s:RunMaven(g:maven_exec.'\ clean\ install')
command! -nargs=1                                      Run                call s:RunMaven(g:maven_exec.'\ test-compile\ exec:java\ -Dexec.mainClass='.<q-args>)
command! -nargs=1                                      MavenTest          call s:MavenUnitTest(<q-args>)
command! -nargs=1                                      MavenQunitTest     call s:MavenQunitTest(<q-args>)
command! -nargs=1                                      MavenQunitTestDir  call s:MavenQunitTestDir(<q-args>)
command! -nargs=1                                      MavenQunitTestFile call s:MavenQunitTestFile(<q-args>)
command! -nargs=0                                      Index              call s:CreateVimIndexes()
command! -nargs=1                                      Grep               call s:GrepFromModuleRoot(<q-args>)
command! -nargs=0                                      Zen                call s:QuickFixZenOutput()
command! -nargs=0                                      CC                 call s:QuickFixZenOutput()
command! -nargs=+ -complete=customlist,s:AutoComplete  Find               call s:FindFilesInIndex(<q-args>)


" Mappings  {{{1
nmap <F4> :call <SID>FindInIndexFile(expand('<cword>'))<cr>
nmap <F9> :call <SID>MavenUnitTest(fnamemodify(expand("%"),":p"))<cr>
" 1}}}

au BufEnter,VimEnter * call s:SetPath()

" vim: set fdm=marker:
