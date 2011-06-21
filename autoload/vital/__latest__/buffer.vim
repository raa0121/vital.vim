" Utilities for buffer.

let s:save_cpo = &cpo
set cpo&vim



let s:Functor = vital#of('vital').import('Functor')


function! s:jump_to(bufnr)
    let winnr = bufwinnr(a:bufnr)
    if a:bufnr != bufnr('%') && winnr != -1
        execute winnr 'wincmd w'
    endif
endfunction

function! s:call_in(bufnr, callable)
    set eventignore=all
    let save_bufnr = bufnr('%')
    call s:jump_to(a:bufnr)
    try
        return s:Functor.call(a:callable, [])
    finally
        call s:jump_to(save_bufnr)
        set eventignore=
    endtry
endfunction

function! s:append_lines(lines)
    if type(a:lines) !=# type([])
        return s:append_lines([a:lines])
    endif
    call setline(line('$') + 1, a:lines)
endfunction

function! s:empty(bufnr)
    return s:call_in(a:bufnr, function('s:__empty'))
endfunction
function! s:__empty()
    return line('$') <= 1 && getline(1) ==# ''
endfunction


let &cpo = s:save_cpo
