:command! Interactive execute ":VimShellInteractive sbcl"
:command! TestIt execute ":VimShellInteractive sbcl --load " . expand("%")
nmap <silent> Q :TestIt<CR>
