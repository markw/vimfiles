"
function! ExecutePerforceCommand(cmd,suffix)
  " workaround for :exe :lcd problems in --remote
  let tail = expand("%:t")
  let path = expand("%:p")
  let dir = substitute(path,tail,'','')
  :exe '!export P4CONFIG=.p4config;cd' dir ';p4' a:cmd tail a:suffix
  :silent :e!
endf

function! PerforceBasic(cmd)
  call ExecutePerforceCommand(a:cmd, '')
endf

function! PerforceFileLog()
  call ExecutePerforceCommand('filelog', '|grep change | head -50')
endf

command! -complete=custom,PerforceCommands -nargs=1 Perforce  call ExecutePerforceCommand(<q-args>)

command! -complete=custom,PerforceCommands -nargs=0 P4add    call PerforceBasic('add')
command! -complete=custom,PerforceCommands -nargs=0 P4edit   call PerforceBasic('edit')
command! -complete=custom,PerforceCommands -nargs=0 P4revert call PerforceBasic('revert')
command! -complete=custom,PerforceCommands -nargs=0 P4sync   call PerforceBasic('sync')

function! PerforceCommands(A,L,P)
  return "edit\nadd\nrevert\ndiff\ndelete\nsync\nfilelog"
endfun

:menu &P4.&Add    :call PerforceBasic("add")<cr>
:menu &P4.&Edit   :call PerforceBasic("edit")<cr>
:menu &P4.&Revert :call PerforceBasic("revert")<cr>
:menu &P4.&Diff   :call PerforceBasic("diff -du -db")<cr>
:menu &P4.&Sync   :call PerforceBasic("sync")<cr>
:menu &P4.&Log    :call PerforceFileLog()<cr>
