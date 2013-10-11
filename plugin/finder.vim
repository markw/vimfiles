if !exists('g:project_root_dir')
  let g:project_root_dir = '/home/mwilliams/p4-clients/main'
endif

au BufEnter,VimEnter * exe 'setlocal path='.fnamemodify(findfile('pom.xml','.;'), ':p:h').'/src/**,./**'

function! s:ActivateBuffer(name) "{{{1
  if has('GUI')
    exe ':drop '.a:name
  else
    exe ':e '.a:name
  endif
  return
endfunction

function! <SID>PickFromList(candidates) "{{{1
  let picklist = ['Select one:']
  let index = 1
  for c in a:candidates
      call add(picklist,index.'. '.c)
      let index += 1
  endfor
  return inputlist(picklist)
endfunction

function! <SID>FindInIndexFile(s)
  let pattern = substitute(a:s,'\([A-Z]\)','[a-z1-9]*\1[a-z1-9]*', 'g').'.*'
  "let pattern = substitute(a:s,'\([A-Z]\)','.*\1.*', 'g').'.*'
  "echo pattern
  let filenames = split(system("grep '".pattern."' ". g:project_root_dir ."/.vimindex"))

  if 0 == len(filenames)
    echo "No matches."
    return
  endif

  if 1 == len(filenames)
    call s:ActivateBuffer(filenames[0])
    return
  endif

  let index = <SID>PickFromList(filenames)
  if index <= 0 || index > len(filenames) | return | endif
  call s:ActivateBuffer(filenames[index-1])
endf

function! <SID>CreateVimIndexes() "{{{1
  echo "Building index file: ".g:project_root_dir.'/.vimindex'
  call system('find '. g:project_root_dir .'/*/src  -type f -fprint '. g:project_root_dir. '/.vimindex 2> /dev/null')
endf


command! -nargs=0 Index call <SID>CreateVimIndexes()
command! -nargs=1 Find  call <SID>FindInIndexFile(<q-args>)

nmap <F4> :call <SID>FindInIndexFile(expand('<cword>'))<cr>
