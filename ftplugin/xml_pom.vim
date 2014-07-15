if expand("%:t") == "pom.xml" || search('<project\s\+name="') != 0
  function! FoldExpr()
    let line = getline(v:lnum)

    if     line =~ '<parent>'             | return '1'
    elseif line =~ '</parent>'            | return '<1'
    elseif line =~ '<plugin>'             | return 'a1'
    elseif line =~ '</plugin>'            | return 's1'
    elseif line =~ '<dependency>'         | return 'a1'
    elseif line =~ '</dependency>'        | return 's1'
    elseif line =~ '<profile>'            | return 'a1'
    elseif line =~ '</profile>'           | return 's1'
    elseif line =~ '<build>'              | return 'a1'
    elseif line =~ '</build>'             | return 's1'
    elseif line =~ '<modules>'            | return 'a1'
    elseif line =~ '</modules>'           | return 's1'
    elseif line =~ '<repositories>'       | return 'a1'
    elseif line =~ '</repositories>'      | return 's1'
    elseif line =~ '<pluginRepositories>' | return 'a1'
    elseif line =~ '</pluginRepositories>'| return 's1'
    else  
      return '='
    endif
  endfunction

  function! FoldText()
    let line = getline(v:foldstart) 
    if line =~ '<dependency>' || line =~ '<plugin>'
      let line_num = v:foldstart
      while line_num < v:foldend
        let line_num = line_num + 1
        let line=getline(line_num)
        if line =~ 'artifactId'
          let line = substitute(line,'.*<artifactId>','','')
          let line = substitute(line,'</artifactId>.*','','')
          let line = substitute(line,' ','','')
          return foldtext() . repeat('-',5).line
        endif
      endwhile
    endif
    if line =~ '<profile>'
      let line_num = v:foldstart
      while line_num < v:foldend
        let line_num = line_num + 1
        let line=getline(line_num)
        if line =~ 'id'
          let line = substitute(line,'.*<id>','','')
          let line = substitute(line,'</id>.*','','')
          let line = substitute(line,' ','','')
          return foldtext() . repeat('-',5).line
        endif
      endwhile
    endif
    return foldtext()
  endfunction

  set foldmethod=expr
  set foldexpr=FoldExpr()
  set foldtext=FoldText()
endif

