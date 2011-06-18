" Utilities for buffer.

let s:save_cpo = &cpo
set cpo&vim


function! s:append_lines(lines)
    if type(a:lines) !=# type([])
        return s:append_lines([a:lines])
    endif
    call setline(line('$') + 1, a:lines)
endfunction


let &cpo = s:save_cpo
