"=============================================================================
" FILE: command_complete.vim
" AUTHOR: Shougo Matsushita <Shougo.Matsu@gmail.com>
" Last Modified: 07 Jul 2010
" License: MIT license  {{{
"     Permission is hereby granted, free of charge, to any person obtaining
"     a copy of this software and associated documentation files (the
"     "Software"), to deal in the Software without restriction, including
"     without limitation the rights to use, copy, modify, merge, publish,
"     distribute, sublicense, and/or sell copies of the Software, and to
"     permit persons to whom the Software is furnished to do so, subject to
"     the following conditions:
"
"     The above copyright notice and this permission notice shall be included
"     in all copies or substantial portions of the Software.
"
"     THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS
"     OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
"     MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.
"     IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY
"     CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT,
"     TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE
"     SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
" }}}
"=============================================================================

function! vimshell#complete#command_complete#complete()"{{{
  call vimshell#imdisable()

  if !vimshell#check_prompt()
    " Ignore.
    return ''
  endif

  if len(vimshell#get_current_args()) > 1
    " Args completion.

    return vimshell#complete#args_complete#complete()
  endif

  " Command completion.

  if exists(':NeoComplCacheDisable')
    return neocomplcache#sources#completefunc_complete#call_completefunc('vimshell#complete#command_complete#omnifunc')
  else
    " Set complete function.
    let &l:omnifunc = 'vimshell#complete#command_complete#omnifunc'

    return "\<C-x>\<C-o>\<C-p>"
  endif
endfunction"}}}

function! vimshell#complete#command_complete#omnifunc(findstart, base)"{{{
  if a:findstart
    return len(vimshell#get_prompt())
  endif

  " Save option.
  let l:ignorecase_save = &ignorecase

  " Complete.
  if g:vimshell_smart_case && a:base =~ '\u'
    let &ignorecase = 0
  else
    let &ignorecase = g:vimshell_ignore_case
  endif

  let l:complete_words = s:get_complete_commands(a:base)

  " Restore option.
  let &ignorecase = l:ignorecase_save
  if &l:omnifunc != 'vimshell#complete#auto_complete#omnifunc'
    let &l:omnifunc = 'vimshell#complete#auto_complete#omnifunc'
  endif

  return l:complete_words
endfunction"}}}

function! s:get_complete_commands(cur_keyword_str)"{{{
  if a:cur_keyword_str =~ '/'
    " Filename completion.
    return vimshell#complete#helper#files(a:cur_keyword_str)
  endif

  let l:directories = vimshell#complete#helper#directories(a:cur_keyword_str)
  if a:cur_keyword_str =~ '^\./'
    for l:keyword in l:directories
      let l:keyword.word = './' . l:keyword.word
    endfor
  endif
  
  let l:ret =    l:directories
        \+ vimshell#complete#helper#cdpath_directories(a:cur_keyword_str)
        \+ vimshell#complete#helper#aliases(a:cur_keyword_str)
        \+ vimshell#complete#helper#internals(a:cur_keyword_str)

  if len(a:cur_keyword_str) >= 1
    let l:ret += vimshell#complete#helper#executables(a:cur_keyword_str)
  endif

  return l:ret
endfunction"}}}

" vim: foldmethod=marker
