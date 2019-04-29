function! BuildTagsCloseHandler(job,status) "{{{1
    echom 'BuildTags exit status: '.a:status
endf

function! s:RunBuildTagsScript()  "{{{1
  let script_path = fnamemodify(findfile('build-tags.sh', getcwd().';'), ":p")
  echom 'Executing '.script_path.'...'
  call job_start(['/bin/bash', '-c', script_path],{'exit_cb' : 'BuildTagsCloseHandler'})
endf

" Commands   {{{1
command! -nargs=0  BuildTags  call s:RunBuildTagsScript()

" vim: set fdm=marker:
