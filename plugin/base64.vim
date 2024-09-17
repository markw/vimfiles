function Base64Encode(s) 
    :redir @b
    :echo system('echo ' . a:s . '|base64')
    :redir END
endf

function Base64Decode(s) 
    :redir @b
    :echo system('echo ' . a:s . '|base64 -d')
    :redir END
endf

command Base64Encode :call Base64Encode(expand("<cWORD>"))
command Base64Decode :call Base64Decode(expand("<cWORD>"))

