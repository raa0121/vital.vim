let s:typelist = ['number', 'string', 'func', 'list', 'dict', 'float', 'bool', 'none', 'job', 'channel', 'blob']

let s:types = {}
let s:type_names = {}

for i in range(len(s:typelist))
 let s:types[s:typelist[i]] = i
 let s:type_names[i] = s:typelist[i]
endfor

unlet s:typelist

lockvar 1 s:types
lockvar 1 s:type_names

function! s:_vital_created(module) abort
  let a:module.types = s:types
  let a:module.type_names = s:type_names
endfunction


function! s:is_numeric(value) abort
  let t = type(a:value)
  return t == s:types.number || t == s:types.float
endfunction

function! s:is_special(value) abort
  let t = type(a:value)
  return t == s:types.bool || t == s:types.none
endfunction

function! s:is_predicate(value) abort
  let t = type(a:value)
  return t == s:types.number || t == s:types.string ||
  \ t == s:types.bool || t == s:types.none
endfunction

function! s:is_comparable(value1, value2) abort
  if !exists('s:is_comparable_cache')
    let s:is_comparable_cache = s:_make_is_comparable_cache()
  endif
  return s:is_comparable_cache[type(a:value1)][type(a:value2)]
endfunction

function! s:_make_is_comparable_cache() abort
  let vals = [
  \   0, '', function('type'), [], {}, 0.0,
  \   get(v:, 'false'),
  \   get(v:, 'null'),
  \   exists('*test_null_job') ? test_null_job() : 0,
  \   exists('*test_null_channel') ? test_null_channel() : 0,
  \ ]
  if has('patch-8.1.0735')
    let vals += [0z00]
  endif

  let result = []
  for l:V1 in vals
    let result_V1 = []
    let result += [result_V1]
    for l:V2 in vals
      try
        let _ = V1 == V2
        let result_V1 += [1]
      catch
        let result_V1 += [0]
      endtry
      unlet V2
    endfor
    unlet V1
  endfor
  return result
endfunction
