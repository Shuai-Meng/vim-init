"======================================================================
"
" init-plugins.vim - 
"
" Created by skywind on 2018/05/31
" Last Modified: 2018/06/10 23:11
"
"======================================================================
" vim: set ts=4 sw=4 tw=78 noet :



"----------------------------------------------------------------------
" 默认情况下的分组，可以再前面覆盖之
"----------------------------------------------------------------------
if !exists('g:bundle_group')
	let g:bundle_group = ['basic', 'tags', 'enhanced', 'filetypes', 'textobj']
	let g:bundle_group += ['tags', 'airline', 'nerdtree', 'ale', 'echodoc']
	let g:bundle_group += ['leaderf', 'lsp']
endif


"----------------------------------------------------------------------
" 计算当前 vim-init 的子路径
"----------------------------------------------------------------------
let s:home = fnamemodify(resolve(expand('<sfile>:p')), ':h:h')

function! s:path(path)
	let path = expand(s:home . '/' . a:path )
	return substitute(path, '\\', '/', 'g')
endfunc


"----------------------------------------------------------------------
" 在 ~/.vim/bundles 下安装插件
"----------------------------------------------------------------------
call plug#begin(get(g:, 'bundle_home', '~/.vim/bundles'))


"----------------------------------------------------------------------
" 默认插件 
"----------------------------------------------------------------------

" 全文快速移动，<leader><leader>f{char} 即可触发
Plug 'easymotion/vim-easymotion'

"----------------------------------------------------------------------
" easymotion 配置：快速跳转插件
"----------------------------------------------------------------------
" 核心映射：s{char}{label} 跨窗口跳转
nmap s <Plug>(easymotion-overwin-f)
" s{char}{char}{label} 双字符跳转（更精准）
" Turn on case-insensitive feature
let g:EasyMotion_smartcase = 1
" JK motions: Line motions
map <Leader>j <Plug>(easymotion-j)
map <Leader>k <Plug>(easymotion-k)
" <Leader>f{char} to move to {char}
map  <Leader>f <Plug>(easymotion-bd-f)
nmap <Leader>f <Plug>(easymotion-overwin-f)
" Move to line
map <Leader>L <Plug>(easymotion-bd-jk)
nmap <Leader>L <Plug>(easymotion-overwin-line)
" Move to word
map  <Leader>w <Plug>(easymotion-bd-w)
nmap <Leader>w <Plug>(easymotion-overwin-w)

" 文件浏览器，代替 netrw
Plug 'justinmk/vim-dirvish'

" 表格对齐，使用命令 Tabularize
Plug 'godlygeek/tabular', { 'on': 'Tabularize' }

" Diff 增强，支持 histogram / patience 等更科学的 diff 算法
Plug 'chrisbra/vim-diff-enhanced'

" 按键提示
Plug 'liuchengxu/vim-which-key'

" 注释插件
Plug 'tpope/vim-commentary'


"----------------------------------------------------------------------
" which-key 配置：按下 Leader 键后显示可用的快捷键
"----------------------------------------------------------------------
" leader 键统一在 init-keymaps.vim 中定义，这里只配置 which-key 菜单

" which-key 会自动检测 <leader> 按键，在 timeout 后弹出菜单
" 不要手动映射 <leader>，否则会和 EasyMotion 等插件冲突
set timeoutlen=500

" 定义 which-key 菜单内容
let g:which_key_map =  {}

" 窗口操作菜单
let g:which_key_map['w'] = {
      \ 'name' : '+windows' ,
      \ 'w' : ['<C-W>w'     , '切换到另一个窗口']          ,
      \ 'd' : ['<C-W>c'     , '关闭当前窗口']         ,
      \ '-' : ['<C-W>s'     , '水平分割窗口']    ,
      \ '|' : ['<C-W>v'     , '垂直分割窗口']    ,
      \ 'h' : ['<C-W>h'     , '移动到左边窗口']           ,
      \ 'j' : ['<C-W>j'     , '移动到下方窗口']          ,
      \ 'l' : ['<C-W>l'     , '移动到右边窗口']          ,
      \ 'k' : ['<C-W>k'     , '移动到上方窗口']             ,
      \ '=' : ['<C-W>='     , '均衡窗口大小']        ,
      \ }

" 注册 which-key 菜单（必须在 g:which_key_map 定义之后）
autocmd VimEnter * call which_key#register('<Space>', "g:which_key_map")

" which-key 会自动检测 <leader> 按键，在 timeout 后弹出菜单
" 不需要手动映射 <leader>，which-key 会自动处理


"----------------------------------------------------------------------
" Dirvish 设置：自动排序并隐藏文件，同时定位到相关文件
" 这个排序函数可以将目录排在前面，文件排在后面，并且按照字母顺序排序
" 比默认的纯按照字母排序更友好点。
"----------------------------------------------------------------------
function! s:setup_dirvish()
	if &buftype != 'nofile' && &filetype != 'dirvish'
		return
	endif
	if has('nvim')
		return
	endif
	" 取得光标所在行的文本（当前选中的文件名）
	let text = getline('.')
	if ! get(g:, 'dirvish_hide_visible', 0)
		exec 'silent keeppatterns g@\v[\/]\.[^\/]+[\/]?$@d _'
	endif
	" 排序文件名
	exec 'sort ,^.*[\/],'
	let name = '^' . escape(text, '.*[]~\') . '[/*|@=|\\*]\=\%($\|\s\+\)'
	" 定位到之前光标处的文件
	call search(name, 'wc')
	noremap <silent><buffer> ~ :Dirvish ~<cr>
	noremap <buffer> % :e %
endfunc

augroup MyPluginSetup
	autocmd!
	autocmd FileType dirvish call s:setup_dirvish()
augroup END


"----------------------------------------------------------------------
" 基础插件
"----------------------------------------------------------------------
if index(g:bundle_group, 'basic') >= 0

	" 展示开始画面，显示最近编辑过的文件
	Plug 'mhinz/vim-startify'

	" 一次性安装一大堆 colorscheme
	Plug 'flazz/vim-colorschemes'

	" 支持库，给其他插件用的函数库
	Plug 'xolox/vim-misc'

	" 用于在侧边符号栏显示 marks （ma-mz 记录的位置）
	Plug 'kshenoy/vim-signature'

	" 用于在侧边符号栏显示 git/svn 的 diff
	Plug 'mhinz/vim-signify'

	" 根据 quickfix 中匹配到的错误信息，高亮对应文件的错误行
	" 使用 :RemoveErrorMarkers 命令或者 <space>ha 清除错误
	Plug 'mh21/errormarker.vim'

	" 使用 ALT+e 会在不同窗口/标签上显示 A/B/C 等编号，然后字母直接跳转
	Plug 't9md/vim-choosewin'

	" 提供基于 TAGS 的定义预览，函数参数预览，quickfix 预览
	Plug 'skywind3000/vim-preview'

	" Git 支持
	Plug 'tpope/vim-fugitive'

	" 使用 ALT+E 来选择窗口
	nmap <m-e> <Plug>(choosewin)

	" 默认不显示 startify
	let g:startify_disable_at_vimenter = 1
	let g:startify_session_dir = '~/.vim/session'

	" 使用 <space>ha 清除 errormarker 标注的错误
	noremap <silent><space>ha :RemoveErrorMarkers<cr>

	" signify 调优
	let g:signify_vcs_list = ['git', 'svn']
	let g:signify_sign_add               = '+'
	let g:signify_sign_delete            = '_'
	let g:signify_sign_delete_first_line = '‾'
	let g:signify_sign_change            = '~'
	let g:signify_sign_changedelete      = g:signify_sign_change

	" git 仓库使用 histogram 算法进行 diff
	let g:signify_vcs_cmds = {
			\ 'git': 'git diff --no-color --diff-algorithm=histogram --no-ext-diff -U0 -- %f',
			\}
endif


"----------------------------------------------------------------------
" 增强插件
"----------------------------------------------------------------------
if index(g:bundle_group, 'enhanced') >= 0

	" 用 v 选中一个区域后，ALT_+/- 按分隔符扩大/缩小选区
	Plug 'terryma/vim-expand-region'

	" 快速文件搜索
	Plug 'junegunn/fzf'

	" 给不同语言提供字典补全，插入模式下 c-x c-k 触发
	Plug 'asins/vim-dict'

	" 使用 :FlyGrep 命令进行实时 grep
	Plug 'wsdjeg/FlyGrep.vim'

	" 使用 :CtrlSF 命令进行模仿 sublime 的 grep
	Plug 'dyng/ctrlsf.vim'

	" 配对括号和引号自动补全
	Plug 'Raimondi/delimitMate'

	" 提供 gist 接口
	Plug 'lambdalisue/vim-gista', { 'on': 'Gista' }
	
	" ALT_+/- 用于按分隔符扩大缩小 v 选区
	map <m-=> <Plug>(expand_region_expand)
	map <m--> <Plug>(expand_region_shrink)
endif


"----------------------------------------------------------------------
" 自动生成 ctags/gtags，并提供自动索引功能
" 不在 git/svn 内的项目，需要在项目根目录 touch 一个空的 .root 文件
" 详细用法见：https://zhuanlan.zhihu.com/p/36279445
"----------------------------------------------------------------------
if index(g:bundle_group, 'tags') >= 0

	" 提供 ctags/gtags 后台数据库自动更新功能
	Plug 'skywind3000/vim-gutentags'

	" 提供 GscopeFind 命令并自动处理好 gtags 数据库切换
	" 支持光标移动到符号名上：<leader>cg 查看定义，<leader>cs 查看引用
	Plug 'skywind3000/gutentags_plus'

	" 设定项目目录标志：除了 .git/.svn 外，还有 .root 文件
	let g:gutentags_project_root = ['.root']
	let g:gutentags_ctags_tagfile = '.tags'

	" 默认生成的数据文件集中到 ~/.cache/tags 避免污染项目目录，好清理
	let g:gutentags_cache_dir = expand('~/.cache/tags')

	" 默认禁用自动生成
	let g:gutentags_modules = [] 

	" 如果有 ctags 可执行就允许动态生成 ctags 文件
	if executable('ctags')
		let g:gutentags_modules += ['ctags']
	endif

	" 如果有 gtags 可执行就允许动态生成 gtags 数据库
	if executable('gtags') && executable('gtags-cscope')
		let g:gutentags_modules += ['gtags_cscope']
	endif

	" 设置 ctags 的参数
	let g:gutentags_ctags_extra_args = []
	let g:gutentags_ctags_extra_args = ['--fields=+niazS', '--extra=+q']
	let g:gutentags_ctags_extra_args += ['--c++-kinds=+px']
	let g:gutentags_ctags_extra_args += ['--c-kinds=+px']

	" 使用 universal-ctags 的话需要下面这行，请反注释
	" let g:gutentags_ctags_extra_args += ['--output-format=e-ctags']

	" 禁止 gutentags 自动链接 gtags 数据库
	let g:gutentags_auto_add_gtags_cscope = 0
endif


"----------------------------------------------------------------------
" tagbar：大纲式导航
"----------------------------------------------------------------------
if index(g:bundle_group, 'tags') >= 0
	Plug 'majutsushi/tagbar'

	" Tagbar 切换键默认为 <F12>，避免与 init-keymaps.vim 的 F9 编译冲突。
	" 自定义：在 ~/.vimrc 中 source init.vim 之前设置
	"   let g:tagbar_toggle_key = '<F9>'
	" （若改回 F9，请同时把 g:keymap_compile 换成其他键位）
	let g:tagbar_toggle_key = get(g:, 'tagbar_toggle_key', '<F12>')
	execute 'nmap <silent> ' . g:tagbar_toggle_key . ' :TagbarToggle<CR>'

	let g:tagbar_autofocus = 1
	let g:tagbar_width = 30
endif


"----------------------------------------------------------------------
" 文本对象：textobj 全家桶
"----------------------------------------------------------------------
if index(g:bundle_group, 'textobj') >= 0

	" 基础插件：提供让用户方便的自定义文本对象的接口
	Plug 'kana/vim-textobj-user'

	" indent 文本对象：ii/ai 表示当前缩进，vii 选中当缩进，cii 改写缩进
	Plug 'kana/vim-textobj-indent'

	" 语法文本对象：iy/ay 基于语法的文本对象
	Plug 'kana/vim-textobj-syntax'

	" 函数文本对象：if/af 支持 c/c++/vim/java
	Plug 'kana/vim-textobj-function', { 'for':['c', 'cpp', 'vim', 'java'] }

	" 参数文本对象：i,/a, 包括参数或者列表元素
	Plug 'sgur/vim-textobj-parameter'

	" 提供 python 相关文本对象，if/af 表示函数，ic/ac 表示类
	Plug 'bps/vim-textobj-python', {'for': 'python'}

	" 提供 uri/url 的文本对象，iu/au 表示
	Plug 'jceb/vim-textobj-uri'
endif


"----------------------------------------------------------------------
" 文件类型扩展
"----------------------------------------------------------------------
if index(g:bundle_group, 'filetypes') >= 0

	" powershell 脚本文件的语法高亮
	Plug 'pprovost/vim-ps1', { 'for': 'ps1' }

	" lua 语法高亮增强
	Plug 'tbastos/vim-lua', { 'for': 'lua' }

	" C++ 语法高亮增强，支持 11/14/17 标准
	Plug 'octol/vim-cpp-enhanced-highlight', { 'for': ['c', 'cpp'] }

	" 额外语法文件
	Plug 'justinmk/vim-syntax-extra', { 'for': ['c', 'bison', 'flex', 'cpp'] }

	" python 语法文件增强
	Plug 'vim-python/python-syntax', { 'for': ['python'] }

	" rust 语法增强
	Plug 'rust-lang/rust.vim', { 'for': 'rust' }

	" vim org-mode 
	Plug 'jceb/vim-orgmode', { 'for': 'org' }
endif


"----------------------------------------------------------------------
" airline
"----------------------------------------------------------------------
if index(g:bundle_group, 'airline') >= 0
	Plug 'vim-airline/vim-airline'
	Plug 'vim-airline/vim-airline-themes'
	let g:airline_left_sep = ''
	let g:airline_left_alt_sep = ''
	let g:airline_right_sep = ''
	let g:airline_right_alt_sep = ''
	let g:airline_powerline_fonts = 0
	let g:airline_exclude_preview = 1
	let g:airline_theme='deus'

	" 极简状态栏：只保留模式、git 分支（含 hunks）与诊断错误/警告计数。
	" b 区保持 airline 默认（分支扩展默认开启），无需再设置 section_b 或
	" airline#extensions#branch#enabled。
	let g:airline_section_c = ''
	let g:airline_section_x = ''
	let g:airline_section_y = ''
	let g:airline_section_z = ''
endif


"----------------------------------------------------------------------
" NERDTree
"----------------------------------------------------------------------
if index(g:bundle_group, 'nerdtree') >= 0
	Plug 'scrooloose/nerdtree', {'on': ['NERDTree', 'NERDTreeFocus', 'NERDTreeToggle', 'NERDTreeCWD', 'NERDTreeFind'] }
	Plug 'tiagofumo/vim-nerdtree-syntax-highlight'
	Plug 'Xuyuanp/nerdtree-git-plugin'
	let g:NERDTreeMinimalUI = 1
	let g:NERDTreeDirArrows = 1
	let g:NERDTreeHijackNetrw = 0
	let g:NERDTreeShowLineNumbers = 1        " 显示行号
	let g:NERDTreeAutoCenter = 1             " 打开文件时居中显示
	let g:NERDTreeShowHidden = 1             " 显示隐藏文件
	let g:NERDTreeWinSize = 20               " 设置宽度为20
	let g:NERDTreeIgnore = ['\.pyc','\~$','\.swp'] " 忽略这些文件
	let g:NERDTreeShowBookmarks = 2          " 打开时显示书签
	let g:nerdtree_tabs_open_on_console_startup = 1 " 终端启动时共享NERDTree
	noremap <space>nn :NERDTree<cr>
	noremap <space>no :NERDTreeFocus<cr>
	noremap <space>nm :NERDTreeMirror<cr>
	noremap <space>nt :NERDTreeToggle<cr>

	" 启动 vim 时自动打开 NERDTree
	autocmd VimEnter * NERDTree
	autocmd VimEnter * wincmd p             " 光标回到编辑窗口

	" 每个标签页都自动打开 NERDTree（镜像共享）
	autocmd TabEnter * if !exists('t:NERDTreeBufName') | NERDTreeMirror | wincmd p | endif

	" 当只剩 NERDTree 窗口时自动关闭 vim
	autocmd BufEnter * if (winnr("$") == 1 && exists("b:NERDTree") && b:NERDTree.isTabTree()) | q | endif

	" 如果没有打开文件，自动打开 NERDTree
	autocmd VimEnter * if !argc() | NERDTree | endif

	" NERDTree 同步当前文件
	function! IsNERDTreeOpen()
	  return exists("t:NERDTreeBufName") && (bufwinnr(t:NERDTreeBufName) != -1)
	endfunction

	function! SyncTree()
	  " 安全检查：确保在有效的窗口和缓冲区中
	  if !bufexists('%') || winnr() == 0
	    return
	  endif
	  " 跳过非文件缓冲区（如 jdt://、term://、fugitive:// 等）
	  if &buftype != '' || !&modifiable
	    return
	  endif
	  " 跳过特殊路径（JDK源码、jar包内文件等）
	  if expand('%') =~# '^\(jdt\|zipfile\|tarfile\)://'
	    return
	  endif
	  " 跳过空缓冲区或未命名缓冲区
	  if expand('%') ==# '' || expand('%') =~# '^unnamed'
	    return
	  endif
	  if IsNERDTreeOpen() && !&diff
	    silent! NERDTreeFind
	    wincmd p
	  endif
	endfunction

	autocmd BufEnter * call SyncTree() " 高亮当前打开的文件

	" NERDTree Git 状态图标配置
	let g:NERDTreeGitStatusIndicatorMapCustom = {
		\ "Modified"  : "✹",
		\ "Staged"    : "✚",
		\ "Untracked" : "✭",
		\ "Renamed"   : "➜",
		\ "Unmerged"  : "═",
		\ "Deleted"   : "✖",
		\ "Dirty"     : "✗",
		\ "Clean"     : "✔︎",
		\ 'Ignored'   : '☒',
		\ "Unknown"   : "?"
		\ }

	" 不显示被忽略的文件
	let g:NERDTreeGitStatusShowIgnored = 0
endif


"----------------------------------------------------------------------
" LanguageTool 语法检查
"----------------------------------------------------------------------
if index(g:bundle_group, 'grammer') >= 0
	Plug 'rhysd/vim-grammarous'
	noremap <space>rg :GrammarousCheck --lang=en-US --no-move-to-first-error --no-preview<cr>
	map <space>rr <Plug>(grammarous-open-info-window)
	map <space>rv <Plug>(grammarous-move-to-info-window)
	map <space>rs <Plug>(grammarous-reset)
	map <space>rx <Plug>(grammarous-close-info-window)
	map <space>rm <Plug>(grammarous-remove-error)
	map <space>rd <Plug>(grammarous-disable-rule)
	map <space>rn <Plug>(grammarous-move-to-next-error)
	map <space>rp <Plug>(grammarous-move-to-previous-error)
endif


"----------------------------------------------------------------------
" ale：动态语法检查
"----------------------------------------------------------------------
if index(g:bundle_group, 'ale') >= 0
	Plug 'w0rp/ale'

	" 设定延迟和提示信息
	let g:ale_completion_delay = 500
	let g:ale_echo_delay = 20
	let g:ale_lint_delay = 500
	let g:ale_echo_msg_format = '[%linter%] %code: %%s'

	" 设定检测的时机：normal 模式文字改变，或者离开 insert模式
	" 禁用默认 INSERT 模式下改变文字也触发的设置，太频繁外，还会让补全窗闪烁
	let g:ale_lint_on_text_changed = 'normal'
	let g:ale_lint_on_insert_leave = 1

	" 在 linux/mac 下降低语法检查程序的进程优先级（不要卡到前台进程）
	if has('win32') == 0 && has('win64') == 0 && has('win32unix') == 0
		let g:ale_command_wrapper = 'nice -n5'
	endif

	" 允许 airline 集成
	let g:airline#extensions#ale#enabled = 1

	" 编辑不同文件类型需要的语法检查器
	let g:ale_linters = {
				\ 'c': ['gcc', 'cppcheck'], 
				\ 'cpp': ['gcc', 'cppcheck'], 
				\ 'python': ['flake8', 'pylint'], 
				\ 'lua': ['luac'], 
				\ 'go': ['go build', 'gofmt'],
				\ 'java': [],
				\ 'javascript': ['eslint'], 
				\ }


	" 获取 pylint, flake8 的配置文件，在 vim-init/tools/conf 下面
	function s:lintcfg(name)
		let conf = s:path('tools/conf/')
		let path1 = conf . a:name
		let path2 = expand('~/.vim/linter/'. a:name)
		if filereadable(path2)
			return path2
		endif
		return shellescape(filereadable(path2)? path2 : path1)
	endfunc

	" 设置 flake8/pylint 的参数
	let g:ale_python_flake8_options = '--conf='.s:lintcfg('flake8.conf')
	let g:ale_python_pylint_options = '--rcfile='.s:lintcfg('pylint.conf')
	let g:ale_python_pylint_options .= ' --disable=W'
	let g:ale_c_gcc_options = '-Wall -O2 -std=c99'
	let g:ale_cpp_gcc_options = '-Wall -O2 -std=c++14'
	let g:ale_c_cppcheck_options = ''
	let g:ale_cpp_cppcheck_options = ''

	let g:ale_linters.text = ['textlint', 'write-good', 'languagetool']

	" 如果没有 gcc 只有 clang 时（FreeBSD）
	if executable('gcc') == 0 && executable('clang')
		let g:ale_linters.c += ['clang']
		let g:ale_linters.cpp += ['clang']
	endif
endif


"----------------------------------------------------------------------
" LSP：coc.nvim 智能补全方案
"----------------------------------------------------------------------
" 检查 Vim 版本，coc.nvim 需要 9.0.0438+（Vim9 脚本语法要求）
if index(g:bundle_group, 'lsp') >= 0 && has('patch-9.0.0438')
	" coc.nvim 主插件
	Plug 'neoclide/coc.nvim', {'branch': 'release'}
	
	" 基本设置
	set hidden
	set nobackup
	set nowritebackup
	set updatetime=300
	set shortmess+=c
	
	" 自动安装扩展
	let g:coc_global_extensions = [
		\ 'coc-json',
		\ 'coc-tsserver',
		\ 'coc-java',
		\ 'coc-java-dev',
		\ 'coc-html',
		\ 'coc-css',
		\ 'coc-yaml',
		\ 'coc-vimlsp',
		\ ]
	
	" coc.nvim Java LSP 配置
	" java.jdt.ls.java.home / runtimes.path 优先使用 $JAVA_HOME 环境变量，
	" runtime 名称从 $JAVA_HOME/release 自动解析（如 JAVA_VERSION="21.0.4" -> JavaSE-21）。
	" 未设置 $JAVA_HOME 时跳过该项，让 coc-java 使用其自带的 JDK。
	" coc-java 自带 lombok.jar，自动添加 -javaagent，无需手动配置 vmargs
	let s:java_home = $JAVA_HOME
	if s:java_home !=# ''
		let s:java_version = '21'
		let s:java_release = s:java_home . '/release'
		if filereadable(s:java_release)
			let s:java_ver = matchstr(get(readfile(s:java_release), 0, ''),
						\ 'JAVA_VERSION="\zs[^"]*')
			let s:java_major = matchstr(s:java_ver, '^\d\+')
			if s:java_major ==# '1'
				" JDK 8 的版本号形如 1.8.0_xxx
				let s:java_major = '1.' . matchstr(s:java_ver, '^1\.\zs\d\+')
			endif
			if s:java_major !=# ''
				let s:java_version = s:java_major
			endif
		endif
		let g:coc_user_config = {
			\ 'java.jdt.ls.java.home': s:java_home,
			\ 'java.configuration.runtimes': [
			\   {
			\     'name': 'JavaSE-' . s:java_version,
			\     'path': s:java_home,
			\   },
			\ ],
			\ 'java.import.maven.enabled': v:true,
			\ 'java.import.maven.downloadSources': v:true,
			\ 'java.references.includeDecompiledSources': v:true,
			\ 'java.eclipse.downloadSources': v:true,
			\ 'suggest.noselect': v:false,
			\ 'suggest.enablePreselect': v:true,
			\ 'coc.preferences.jumpCommand': 'tabnew',
			\ }
	endif
	
	" ---- Tab 补全导航 ----
	" Tab/S-Tab 在补全菜单中上下导航
	" Enter 确认选中的补全项
	" Ctrl-Space 手动触发补全
	function! s:check_back_space() abort
		let col = col('.') - 1
		return !col || getline('.')[col - 1]  =~# '\s'
	endfunction
	
	function! s:show_doc()
		if (index(['vim','help'], &filetype) >= 0)
			execute 'h '.expand('<cword>')
		elseif (coc#rpc#ready())
			call CocActionAsync('doHover')
		else
			execute '!' . &keywordprg . " " . expand('<cword>')
		endif
	endfunction
	
	" Tab 补全导航
	inoremap <silent><expr> <TAB>
		\ coc#pum#visible() ? coc#pum#next(1) :
		\ <SID>check_back_space() ? "\<TAB>" :
		\ coc#refresh()
	inoremap <expr><S-TAB> coc#pum#visible() ? coc#pum#prev(1) : "\<C-h>"
	
	" Enter 确认补全
	inoremap <silent><expr> <CR> coc#pum#visible() ? coc#pum#confirm()
		\: "\<C-g>u\<CR>\<c-r>=coc#on_enter()\<CR>"
	
	" Ctrl-Space 触发补全
	inoremap <silent><expr> <c-space> coc#refresh()
	
	" ---- 跳转 ----
	" gd: 跳转到定义（新标签页，由 coc.preferences.jumpCommand 控制）
	" gy: 跳转到类型定义（新标签页）
	" gi: 跳转到实现（新标签页）
	" gr: 查看所有引用（当前窗口）
	nmap <silent> gd <Plug>(coc-definition)
	nmap <silent> gy <Plug>(coc-type-definition)
	nmap <silent> gi <Plug>(coc-implementation)
	nmap <silent> gr <Plug>(coc-references)
	
	" K: 显示文档/悬浮窗口
	nnoremap <silent> K :call <SID>show_doc()<CR>
	
	" ---- 重构与代码操作 ----
	" <leader>rn: 重命名符号
	" <leader>ca: 代码操作（光标处）
	xmap <leader>rn <Plug>(coc-rename)
	nmap <leader>ca <Plug>(coc-codeaction-cursor)
	xmap <leader>ca <Plug>(coc-codeaction-selected)
	
	" ---- 诊断导航 ----
	" [d / ]d: 上/下一个诊断错误
	nmap <silent> [d <Plug>(coc-diagnostic-prev)
	nmap <silent> ]d <Plug>(coc-diagnostic-next)
	
	" ---- 格式化 ----
	" <leader>f: 格式化选中区域
	nmap <leader>f <Plug>(coc-format-selected)
	xmap <leader>f <Plug>(coc-format-selected)
	
	" ---- 其他 ----
	" 折叠代码
	command! -nargs=0 Fold :call CocAction('fold')
	
	" 高亮光标下的符号
	autocmd CursorHold * silent call CocActionAsync('highlight')
endif


"----------------------------------------------------------------------
" echodoc：在底部显示函数参数
"----------------------------------------------------------------------
if index(g:bundle_group, 'echodoc') >= 0
	Plug 'Shougo/echodoc.vim'
	set noshowmode
	let g:echodoc#enable_at_startup = 1
endif


"----------------------------------------------------------------------
" LeaderF：CtrlP / FZF 的超级代替者，文件模糊匹配，tags/函数名 选择
"----------------------------------------------------------------------
if index(g:bundle_group, 'leaderf') >= 0
	" 如果 vim 支持 python 则启用  Leaderf
	if has('python') || has('python3')
		Plug 'Yggdroot/LeaderF'

		" CTRL+p 打开文件模糊匹配
		let g:Lf_ShortcutF = '<c-p>'

		" ALT+n 打开 buffer 模糊匹配
		let g:Lf_ShortcutB = '<m-n>'

		" CTRL+n 打开最近使用的文件 MRU，进行模糊匹配
		noremap <c-n> :LeaderfMru<cr>

		" ALT+p 打开函数列表，按 i 进入模糊匹配，ESC 退出
		noremap <m-p> :LeaderfFunction!<cr>

		" ALT+SHIFT+p 打开 tag 列表，i 进入模糊匹配，ESC退出
		noremap <m-P> :LeaderfBufTag!<cr>

		" ALT+n 打开 buffer 列表进行模糊匹配
		noremap <m-n> :LeaderfBuffer<cr>

		" ALT+m 全局 tags 模糊匹配
		noremap <m-m> :LeaderfTag<cr>

		" 最大历史文件保存 2048 个
		let g:Lf_MruMaxFiles = 2048

		" ui 定制
		let g:Lf_StlSeparator = { 'left': '', 'right': '', 'font': '' }

		" 如何识别项目目录，从当前文件目录向父目录递归知道碰到下面的文件/目录
		let g:Lf_RootMarkers = ['.project', '.root', '.svn', '.git']
		let g:Lf_WorkingDirectoryMode = 'Ac'
		let g:Lf_WindowHeight = 0.30
		let g:Lf_CacheDirectory = expand('~/.vim/cache')

		" 显示绝对路径
		let g:Lf_ShowRelativePath = 0

		" 隐藏帮助
		let g:Lf_HideHelp = 1

		" 模糊匹配忽略扩展名
		let g:Lf_WildIgnore = {
					\ 'dir': ['.svn','.git','.hg'],
					\ 'file': ['*.sw?','~$*','*.bak','*.exe','*.o','*.so','*.py[co]']
					\ }

		" MRU 文件忽略扩展名
		let g:Lf_MruFileExclude = ['*.so', '*.exe', '*.py[co]', '*.sw?', '~$*', '*.bak', '*.tmp', '*.dll']
		let g:Lf_StlColorscheme = 'powerline'

		" 禁用 function/buftag 的预览功能，可以手动用 p 预览
		let g:Lf_PreviewResult = {'Function':0, 'BufTag':0}

		" 使用 ESC 键可以直接退出 leaderf 的 normal 模式
		let g:Lf_NormalMap = {
				\ "File":   [["<ESC>", ':exec g:Lf_py "fileExplManager.quit()"<CR>']],
				\ "Buffer": [["<ESC>", ':exec g:Lf_py "bufExplManager.quit()"<cr>']],
				\ "Mru": [["<ESC>", ':exec g:Lf_py "mruExplManager.quit()"<cr>']],
				\ "Tag": [["<ESC>", ':exec g:Lf_py "tagExplManager.quit()"<cr>']],
				\ "BufTag": [["<ESC>", ':exec g:Lf_py "bufTagExplManager.quit()"<cr>']],
				\ "Function": [["<ESC>", ':exec g:Lf_py "functionExplManager.quit()"<cr>']],
				\ }

	else
		" 不支持 python ，使用 CtrlP 代替
		Plug 'ctrlpvim/ctrlp.vim'

		" 显示函数列表的扩展插件
		Plug 'tacahiroy/ctrlp-funky'

		" 忽略默认键位
		let g:ctrlp_map = ''

		" 模糊匹配忽略
		let g:ctrlp_custom_ignore = {
		  \ 'dir':  '\v[\/]\.(git|hg|svn)$',
		  \ 'file': '\v\.(exe|so|dll|mp3|wav|sdf|suo|mht)$',
		  \ 'link': 'some_bad_symbolic_links',
		  \ }

		" 项目标志
		let g:ctrlp_root_markers = ['.project', '.root', '.svn', '.git']
		let g:ctrlp_working_path = 0

		" CTRL+p 打开文件模糊匹配
		noremap <c-p> :CtrlP<cr>

		" CTRL+n 打开最近访问过的文件的匹配
		noremap <c-n> :CtrlPMRUFiles<cr>

		" ALT+p 显示当前文件的函数列表
		noremap <m-p> :CtrlPFunky<cr>

		" ALT+n 匹配 buffer
		noremap <m-n> :CtrlPBuffer<cr>
	endif
endif


"----------------------------------------------------------------------
" 结束插件安装
"----------------------------------------------------------------------
call plug#end()
