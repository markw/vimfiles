set ts=2 sw=2 foldmethod=indent foldnestmax=2 foldlevel=0 foldminlines=4

if expand("%") =~ 'test.ts'
  set foldlevel=0 foldnestmax=3
end

if expand("%") =~ 'integration.ts'
  set foldlevel=0 foldnestmax=3
end
