function! s:eval_S_expression() " {{{
  let ch = strpart(getline('.'), col('.')-1, 1)
  let skip = 'index(["string", "schemeChar"], synIDattr(synID(line("."), col("."), 0), "name")) != -1'
  if ch == ')'
    let endline = line('.')
    let startline = searchpairpos('(', '', ')', 'nbW', skip)[0]
  elseif ch == '('
    let startline = line('.')
    let endline = searchpairpos('(', '', ')', 'nW', skip)[0]
  else
    let startline = searchpairpos('(', '', ')', 'nbW', skip)[0]
    let endline = searchpairpos('(', '', ')', 'nW', skip)[0]
  endif
  execute printf('%d,%dVimShellSendString', startline, endline)
endfunction " }}}

:command! Interactive execute ":VimShellInteractive gosh"
nmap <silent> <Space>e :call <SID>eval_S_expression()<CR>
