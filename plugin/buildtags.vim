function! BuildTagsCloseHandler(job,status) "{{{1
    echom 'BuildTags exit status: '.a:status
endf

function! s:RunBuildTagsScript(script_name)  "{{{1
  let build_tags_script_file = findfile(a:script_name, getcwd().';')
  if empty(build_tags_script_file)
      echom 'Not found: '.a:script_name
      return
  endif
  let build_tags_script_path = fnamemodify(build_tags_script_file, ":p")
  if !executable(build_tags_script_path)
      echom 'Not executable: '.build_tags_script_path
      return
  endif
  echom 'Executing '.build_tags_script_path.'...'
  call job_start(['/bin/bash', '-c', build_tags_script_path],{'exit_cb' : 'BuildTagsCloseHandler'})
endf

" Variables   {{{1
if !exists("g:build_tags_script_name")
  let g:build_tags_script_name = 'build-tags.sh'
endif

" Commands   {{{1
command! -nargs=0  BuildTags  call s:RunBuildTagsScript(g:build_tags_script_name)

" vim: set fdm=marker:
