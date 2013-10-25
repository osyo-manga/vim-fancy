scriptencoding utf-8
let s:save_cpo = &cpo
set cpo&vim


let s:fancies = {}


function! fancy#regist(name, fancy)
	let s:fancies[a:name] = a:fancy
endfunction



let s:idle_timer = {}

function! s:idle_timer.start(interval, fancy_name)
	let self.latest_time = localtime()
	let self.fancy_name = a:fancy_name
	let self.interval = a:interval
endfunction


function! s:idle_timer.end()
	call fancy#disable()
endfunction

function! fancy#disable_when_idle()
	augroup fancy-idle
		autocmd! * <buffer>
	augroup END
	call s:timer.end()
	unlet! s:timer
endfunction


function! fancy#enable(name)
	if !exists("b:fancies")
		let b:fancies = {}
	endif
	if has_key(b:fancies, a:name)
\	|| !has_key(s:fancies, a:name)
		return
	endif
	let fancy = deepcopy(s:fancies[a:name])
	call fancy.enable({})
	let b:fancies[a:name] = fancy
endfunction


function! fancy#disable()
	if !exists("b:fancies")
		return
	endif
	for fancy in values(b:fancies)
		call fancy.disable({})
	endfor
	unlet! b:fancies
endfunction


function! fancy#list()
	return map(split(globpath(&rtp, "*/fancy/*.vim"), "\n"), 'fnamemodify(v:val, ":t:r")')
endfunction

function! s:load()
	for file in split(globpath(&rtp, "*/fancy/*.vim"), "\n")
		source `=file`
	endfor
endfunction
call s:load()


let &cpo = s:save_cpo
unlet s:save_cpo
