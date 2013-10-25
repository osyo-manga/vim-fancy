scriptencoding utf-8
let s:save_cpo = &cpo
set cpo&vim


function! s:panic()
	let oldopt = &eventignore
	let &eventignore = "all"
	try
		call feedkeys(":set eventignore=all | normal! mzggg?G`z\<CR>")
	finally
	endtry
	call feedkeys(":set eventignore=" . oldopt . "\<CR>", "n")
endfunction


let s:fancy = {}

function! s:fancy.enable(...)
	call s:panic()
endfunction


function! s:fancy.disable(...)
	call s:panic()
endfunction


call fancy#regist("panic", s:fancy)

let &cpo = s:save_cpo
unlet s:save_cpo
