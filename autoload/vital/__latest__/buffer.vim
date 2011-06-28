" Utilities for buffer.

let s:save_cpo = &cpo
set cpo&vim



let s:Functor = {}
function! s:_vital_loaded(V)
    let s:Functor = a:V.import('Functor')
endfunction


" TODO: Move these functions to a module.
function! s:__eventignore_call(callable, args)
    set eventignore=all
    try
        return s:Functor.call(a:callable, a:args)
    finally
        set eventignore=
    endtry
endfunction
function! s:__get_list(args, idx)
    let V = a:args[a:idx]
    if type(V) ==# type([])
        throw '`V` is not List.'
    endif
    return V
endfunction

function! s:__get_sid()
    return matchstr(expand('<sfile>'), '<SNR>\zs\d\+\ze___get_sid$')
endfunction
let s:__SID = s:__get_sid()
delfunction s:__get_sid


" Create proxy object for public functions.
" TODO: Create vital proxy module.
function! s:new(bufnr)
    let obj = {}
    for method in ['jump_to', 'call_in', 'append_lines', 'empty']
        let obj[method] = s:Functor.curry(s:Functor.localfunc(method, s:__SID), a:bufnr)
    endfor
    return obj
endfunction

function! s:jump_to(...)
    return s:__eventignore_call(s:Functor.localfunc('__jump_to', s:__SID), a:000)
endfunction
function! s:__jump_to(bufnr)
    let winnr = bufwinnr(a:bufnr)
    if a:bufnr != bufnr('%') && winnr != -1
        execute winnr 'wincmd w'
    endif
endfunction

function! s:call_in(...)
    return s:__eventignore_call(s:Functor.localfunc('__call_in', s:__SID), a:000)
endfunction
function! s:__call_in(bufnr, callable, ...)
    let args = s:__get_list(a:000, 0)
    let save_bufnr = bufnr('%')
    " Already `set eventignore=all`.
    call s:__jump_to(a:bufnr)
    try
        return s:Functor.call(a:callable, args)
    finally
        call s:jump_to(save_bufnr)
    endtry
endfunction

function! s:append_lines(bufnr, lines)
    return s:call_in(a:bufnr, s:Functor.localfunc('__append_lines', s:__SID), [a:lines])
endfunction
function! s:__append_lines(lines)
    if type(a:lines) !=# type([])
        return s:append_lines([a:lines])
    endif
    call setline(line('$') + 1, a:lines)
endfunction

function! s:empty(bufnr)
    return s:call_in(a:bufnr, s:Functor.localfunc('__empty', s:__SID))
endfunction
function! s:__empty()
    return line('$') <= 1 && getline(1) ==# ''
endfunction


let &cpo = s:save_cpo
