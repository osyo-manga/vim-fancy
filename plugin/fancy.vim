scriptencoding utf-8
if exists('g:loaded_fancy')
  finish
endif
let g:loaded_fancy = 1

let s:save_cpo = &cpo
set cpo&vim

function! s:complete_list(arglead, ...)
	return filter(fancy#list(), "v:val =~? '".a:arglead."'")
endfunction

command! -nargs=1 -complete=customlist,s:complete_list
\	FancyEnable
\	call fancy#enable(<q-args>)

command! FancyDisable call fancy#disable()


let &cpo = s:save_cpo
unlet s:save_cpo
