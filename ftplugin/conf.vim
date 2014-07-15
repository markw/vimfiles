if expand("%:t") == "resin.conf"
    set ft=xml
    runtime! syntax/xml.vim
endif
