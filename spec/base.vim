let &runtimepath = expand('<sfile>:h:h')

let s:results = {}
let s:context_stack = []

function! s:should(cond, result)
  " FIXME: validate
  let it = s:context_stack[-1][1]
  let context = s:context_stack[-2][1]
  if !has_key(s:results, context)
    let s:results[context] = []
  endif
  call add(s:results[context], a:result ? '.' : it . a:cond)
endfunction

function! s:_should(it, cond)
  echo a:cond
  echo eval(a:cond)
  return eval(a:cond) ? '.' : a:it
endfunction

function! s:has_failed(results_value)
    let failed = 'v:val !=# "."'
    return !empty(filter(copy(a:results_value), failed))
endfunction
function! s:fin(cond)
    " Write failed results only.
    let failed = {}
    for context in sort(keys(s:results))
        if s:has_failed(s:results[context])
            let failed[context] = s:results[context]
        endif
    endfor
    " TODO: use PP() instead of string() if it is available.
    call writefile([empty(failed) ? 'All tests were passed.' : string(failed)], a:cond)
    qa!
endfunction

command! -nargs=+ Context
      \ call add(s:context_stack, ['c', <q-args>])
command! -nargs=+ It
      \ call add(s:context_stack, ['i', <q-args>])
command! -nargs=+ Should
      \ call s:should(<q-args>, eval(<q-args>))
command! -nargs=0 End
      \ call remove(s:context_stack, -1) |
      \ redraw!

command! -nargs=+ Fin
      \ call s:fin(<q-args>)
