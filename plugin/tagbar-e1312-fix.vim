"=============================================================================
" tagbar-e1312-fix.vim - 修复 tagbar 在 Vim 9.0.907+ 下关闭窗口的 E1312 报错
"=============================================================================
"
" 问题：
"   tagbar（3.1.1 及当前 HEAD）在 WinEnter 自动命令里直接执行
"   close/quit/wincmd 来收拾“最后一个文件窗口被关闭”的场景。
"   Vim 9.0.907 开始禁止在 WinEnter/WinNew 自动命令中修改窗口布局，
"   于是关闭文件窗口时会报：
"     E1312: Not allowed to change the window layout in this autocmd
"
" 方案：
"   与上游修复思路（preservim/tagbar 的 PR #875）一致——把 WinEnter
"   里要做的事情用 timer_start(0, ...) 延迟到自动命令结束之后再执行，
"   行为完全不变，只是绕开了 E1312 的限制。
"
"   这里不改动 tagbar 插件源码：tagbar 是惰性加载的，首次执行
"   :TagbarToggle 打开窗口时 autoload 才被载入。我们等 Tagbar 窗口
"   出现（BufWinEnter）后，把 TagbarAutoCmds 组里那条 WinEnter *
"   自动命令替换成延迟执行版本即可。tagbar 未安装时本脚本自动跳过。
"
" 用法：无需配置。放到 plugin 目录后 Vim 启动时自动生效。
"=============================================================================

if exists('g:loaded_tagbar_e1312_fix')
	finish
endif
let g:loaded_tagbar_e1312_fix = 1

" 从 scriptnames 里找到 tagbar autoload 脚本的编号，
" 用于构造 <SNR> 开头的脚本私有函数名（s:HandleOnlyWindow）。
function! s:TagbarSid() abort
	redir => l:names
	silent scriptnames
	redir END
	for l:line in split(l:names, "\n")
		if l:line =~# 'autoload[/\\]tagbar\.vim$'
			return str2nr(matchstr(l:line, '^\s*\d\+'))
		endif
	endfor
	return 0
endfunction

let s:installed = 0

function! s:InstallFix() abort
	if s:installed
		return
	endif

	" 确认 tagbar 的脚本私有函数存在，避免未来版本改名后误替换
	let l:sid = s:TagbarSid()
	if l:sid <= 0 || !exists('*<SNR>' . l:sid . '_HandleOnlyWindow')
		return
	endif
	let s:fn = '<SNR>' . l:sid . '_HandleOnlyWindow'

	" 删除 tagbar 自带的 WinEnter * 自动命令，换成 timer_start 延迟执行。
	" timer 回调会收到 timer id 参数，而 s:HandleOnlyWindow 不接受参数，
	" 所以用 lambda 包一层。
	autocmd! TagbarAutoCmds WinEnter *
	autocmd TagbarAutoCmds WinEnter * nested call timer_start(0, {-> call(s:fn, [])})
	let s:installed = 1
endfunction

" tagbar 惰性加载：首次打开 Tagbar 窗口（BufWinEnter）后再安装修复，
" 会话恢复场景同样会触发该事件。
augroup TagbarE1312Fix
	autocmd!
	autocmd BufWinEnter __Tagbar__.* call s:InstallFix()
augroup END
