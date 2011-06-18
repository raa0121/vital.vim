" "Callable thing" in vital.

let s:save_cpo = &cpo
set cpo&vim


let s:Functor = vital#of('vital').import('Functor')


" Echo a:msg with highlight a:hl.
function! s:echomsg(hl, msg)
    execute 'echohl' a:hl
    try
        echomsg a:msg
    finally
        echohl None
    endtry
endfunction

" printf() like function.
" Pass its message string to s:echomsg().
function! s:echomsgf(hl, fmt, ...)
    let msg = call('printf', [a:fmt] + a:000)
    return s:echomsg(a:hl, msg)
endfunction


" Create shorthands for s:echomsg(), s:echomsgf().
function! s:__init()
    for [funcname, hl] in items({
    \   'warn': 'WarningMsg',
    \   'error': 'Error',
    \})
        let s:[funcname] = s:Functor.curry(
        \   function('s:echomsg'),
        \   hl
        \)
        let s:[funcname . 'f'] = s:Functor.curry(
        \   function('s:echomsgf'),
        \   hl
        \)
    endfor
endfunction
call s:__init()


let &cpo = s:save_cpo
