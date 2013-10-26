scriptencoding utf-8
let s:save_cpo = &cpo
set cpo&vim

let g:fancy_rainbow_enable_smart = get(g:, "fancy_rainbow_enable_smart", 0)


let s:rainbow_chart = [
\	"E60012",
\	"EB6100",
\	"F39800",
\	"FCC800",
\	"FFF100",
\	"CFDB00",
\	"8FC31F",
\	"22AC38",
\	"009944",
\	"009B6B",
\	"009E96",
\	"00A0C1",
\	"00A0E9",
\	"0086D1",
\	"0068B7",
\	"00479D",
\	"1D2088",
\	"601986",
\	"920783",
\	"BE0081",
\	"E4007F",
\	"E5006A",
\	"E5004F",
\	"E60033",
\]


let s:fancy = {}


function! s:set_highlight(...)
	if g:fancy_rainbow_enable_smart
		let count_ = get(a:, 1, 0)
		for line in range(line("w0"), line("w$"))
			if foldclosed(line) == -1
				for col in range(0, len(getline(line)))
					let pattern = printf('^\%%%dl\s*\(\S\s*\)\{%d}\zs\S', line, col)
					let color_num = (col + count_ + len(getline(line))) % len(s:rainbow_chart)
					call matchadd("Rainbow" . color_num, pattern)
				endfor
			endif
		endfor
	else
		let width = 200
		let count_ = get(a:, 1, 0)
		for col in range(0, width)
			let pattern = printf('^\s*\(\S\s*\)\{%d}\zs\S', col)
			let color_num = (col + count_) % len(s:rainbow_chart)
			call matchadd("Rainbow" . color_num, pattern)
		endfor
	endif
endfunction


function! s:unset_highlight()
	for _ in getmatches()
		if _.group =~ '^Rainbow\d'
			call matchdelete(_.id)
		endif
	endfor
endfunction


function! s:update()
	if !exists("b:counter")
		let b:counter = 0
	endif
	call s:unset_highlight()
	call s:set_highlight(b:counter)
	let b:counter += 1
endfunction


function! s:fancy.enable(context)
	let b:enable = 1
	call s:set_highlight()
	augroup fancy-rainbow
		autocmd! * <buffer>
		autocmd CursorHold <buffer> call feedkeys(mode() ==# 'i' ? "\<C-g>\<ESC>" : "g\<ESC>", 'n') | call s:update()
	augroup END
endfunction



function! s:fancy.disable(context)
	let b:enable = 0
	call s:unset_highlight()
	augroup fancy-rainbow
		autocmd! * <buffer>
	augroup END
endfunction


function! s:init()
	for [color, n] in map(s:rainbow_chart, '[v:val, v:key]')
		execute printf("highlight Rainbow%d guifg=#%s gui=bold", n, color)
	endfor
endfunction
call s:init()


call fancy#regist("rainbow", s:fancy)

let &cpo = s:save_cpo
unlet s:save_cpo
