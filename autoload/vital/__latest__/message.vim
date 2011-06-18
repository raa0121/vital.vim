" "Callable thing" in vital.

let s:save_cpo = &cpo
set cpo&vim


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


let &cpo = s:save_cpo
