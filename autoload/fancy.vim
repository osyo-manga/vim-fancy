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


function! s:idle_timer.reset()
	let self.latest_time = localtime()
	call fancy#disable()
endfunction


function! s:idle_timer.update()
	let now = localtime()
	if (now - self.latest_time) > self.interval
		call fancy#enable(self.fancy_name)
	endif
endfunction


function! fancy#enable_when_idle(time, name)
	if exists("s:timer)
		return
	endif
	let s:timer = deepcopy(s:idle_timer)
	call s:timer.start(a:time, a:name)
	augroup fancy-idle
		autocmd! * <buffer>
		autocmd InsertEnter,BufLeave,CursorMoved <buffer> call s:timer.reset()
		autocmd CursorHold <buffer> call feedkeys(mode() ==# 'i' ? "\<C-g>\<ESC>" : "g\<ESC>", 'n') | call s:timer.update()
	augroup END
endfunction


function! fancy#disable_when_idle()
	augroup fancy-idle
		autocmd! * <buffer>
	augroup END
	call s:timer.end()
	unlet! s:timer
endfunction


function! fancy#enable(name)
	if exists("b:fancy")
\	|| !has_key(s:fancies, a:name)
		return
	endif
	let b:fancy = deepcopy(s:fancies[a:name])
	call b:fancy.enable({})
endfunction


function! fancy#disable()
	if !exists("b:fancy")
		return
	endif
	call b:fancy.disable({})
	unlet! b:fancy
endfunction


function! s:load()
	for file in split(globpath(&rtp, "*/fancy/*.vim"), "\n")
		source `=file`
	endfor
endfunction
call s:load()


let &cpo = s:save_cpo
unlet s:save_cpo
