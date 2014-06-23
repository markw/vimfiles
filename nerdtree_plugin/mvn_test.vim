call NERDTreeAddKeyMap({
    \ 'key': '<F9>',
    \ 'callback': 'RunQunitTestsForDir',
    \ 'quickhelpText': 'Run QUnit Tests',
    \ 'scope': 'DirNode'})

function! RunQunitTestsForDir(dirnode)
    exe ':MavenQunitTestDir '.a:dirnode.path.str()
endfunction

call NERDTreeAddKeyMap({
    \ 'key': '<F9>',
    \ 'callback': 'RunQunitTestsForFile',
    \ 'quickhelpText': 'Run QUnit Tests',
    \ 'scope': 'FileNode'})

function! RunQunitTestsForFile(fileNode)
    let name = a:fileNode.path.str()
    if name =~ '\.coffee$' || name =~ '\.js$'
        exe ':MavenQunitTestFile '.name
    endif
endfunction
