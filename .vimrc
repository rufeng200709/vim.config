"编辑器基础配置
"Basic Config { 
	set nocompatible        	" Must be first line
	set fileencodings=utf-8,gb18030
	set background=dark         " Assume a dark background
	syntax on                   " Syntax highlighting
	set number		    " 显示行号
	set mouse=a                 " Automatically enable mouse usage
	set mousehide               " Hide the mouse cursor while typing
	set history=1000            " Store a ton of history (default is 20)

	set cursorline		    " 为当前操作行添加下划线

    "set hlsearch        "high light the search word
    "set incsearch       "输入关键字时高亮显示

	" add tab space
	set ts=4	"tabstop 表示一个 tab 显示出来是多少个空格的长度，默认 8。
	set softtabstop=4	"softtabstop 表示在编辑模式的时候按退格键的时候退回缩进的长度，当使用 expandtab 时特别有用。
	set shiftwidth=4	"shiftwidth 表示每一级缩进的长度，一般设置成跟 softtabstop 一样。
	set expandtab	"当设置成 expandtab 时，缩进用空格来表示，noexpandtab 则是用制表符表示一个缩进。
	set autoindent	"autoindent 打开自动缩进, noautoindent 关闭自动缩进


	"自动调整子窗口边栏宽度
	nmap    w=  :resize +1<CR> "窗口下边栏上移1个单位
	nmap    w-  :resize -1<CR> "窗口下边栏下移1个单位
	nmap    w.  :vertical resize -1<CR> "窗口侧边栏左移1个单位
	nmap    w,  :vertical resize +1<CR> "窗口侧边栏左移1个单位

	"导航键定义 leader key define
	let mapleader = ','

	" Easier moving in tabs and windows
	" The lines conflict with the default digraph mapping of <C-K>
	" If you prefer that functionality, add the following to your
	" .vimrc.before.local file:
	"   let g:spf13_no_easyWindows = 1
	if !exists('g:spf13_no_easyWindows')
		map <C-J> <C-W>j<C-W>_
		map <C-K> <C-W>k<C-W>_
		map <C-L> <C-W>l<C-W>_
		map <C-H> <C-W>h<C-W>_
	endif
"}

"插件列表
"Plug lists {
	call plug#begin('~/.vim/plugged')

	Plug 'ludovicchabant/vim-gutentags'
	Plug 'skywind3000/gutentags_plus'
	"Plug 'jsfaint/gen_tags.vim' "代码索引，代码跳转
	Plug 'scrooloose/nerdtree'
	Plug 'skywind3000/asyncrun.vim'
	Plug 'w0rp/ale'
	Plug 'mhinz/vim-signify'

	"文本对象
	Plug 'kana/vim-textobj-user'
	Plug 'kana/vim-textobj-indent'
	Plug 'kana/vim-textobj-syntax'
	Plug 'kana/vim-textobj-function', { 'for':['c', 'cpp', 'vim', 'java'] }
	Plug 'sgur/vim-textobj-parameter'

	"代码补全
	"Plug 'Valloric/YouCompleteMe'

	"显示函数列表，查找文件
	Plug 'Yggdroot/LeaderF'

	if executable('gtags')
		Plug 'majutsushi/tagbar'
    	endif
	
	call plug#end()
"}

"插件配置
"plug Config {
	"gen_tags.vim {
		if isdirectory(expand("~/.vim/plugged/gen_tags.vim"))

			set csprg=gtags-cscope
			set csto=0
			set cst
			set nocsverb

			" add any database in current directory
			"if filereadable("cscope.out")
			"  cs add cscope.out
			" else add database pointed to by environment
			"elseif $CSCOPE_DB != ""
			"  cs add $CSCOPE_DB
			"endif

			if filereadable("GTAGS")
			cs add GTAGS
			elseif $GTAGS_DB != ""
			cs add $GTAGS_DB
			endif

			set csverb
			
			nmap <leader>cs :cs find s <C-R>=expand("<cword>")<CR><CR>
			nmap <leader>sg :cs find g <C-R>=expand("<cword>")<CR><CR>
			nmap <leader>cc :cs find c <C-R>=expand("<cword>")<CR><CR>
			nmap <leader>st :cs find t <C-R>=expand("<cword>")<CR><CR>
			nmap <leader>se :cs find e <C-R>=expand("<cword>")<CR><CR>
			nmap <leader>sf :cs find f <C-R>=expand("<cfile>")<CR><CR>
			nmap <leader>si :cs find i <C-R>=expand("<cfile>")<CR><CR>
			nmap <leader>sd :cs find d <C-R>=expand("<cword>")<CR><CR>
		endif
	"}

	"vim-gutentags {
		if isdirectory(expand("~/.vim/plugged/vim-gutentags"))
		
			let $GTAGSLABEL = 'native-pygments'
			"let $GTAGSCONF = '/usr/local/share/gtags/gtags.conf'

			" gutentags 搜索工程目录的标志，当前文件路径向上递归直到碰到这些文件/目录名
			let g:gutentags_project_root = ['.root', '.svn', '.git', '.hg', '.project']

			" 所生成的数据文件的名称
			let g:gutentags_ctags_tagfile = '.tags'

			" 同时开启 ctags 和 gtags 支持：
			let g:gutentags_modules = []
			if executable('ctags')
				let g:gutentags_modules += ['ctags']
			endif
			if executable('gtags-cscope') && executable('gtags')
				let g:gutentags_modules += ['gtags_cscope']
			endif

			" 将自动生成的 ctags/gtags 文件全部放入 ~/.cache/tags 目录中，避免污染工程目录
			let g:gutentags_cache_dir = expand('~/.cache/tags')

			" 配置 ctags 的参数，老的 Exuberant-ctags 不能有 --extra=+q，注意
			let g:gutentags_ctags_extra_args = ['--fields=+niazS', '--extra=+q']
			let g:gutentags_ctags_extra_args += ['--c++-kinds=+px']
			let g:gutentags_ctags_extra_args += ['--c-kinds=+px']

			" 如果使用 universal ctags 需要增加下面一行，老的 Exuberant-ctags 不能加下一行
			let g:gutentags_ctags_extra_args += ['--output-format=e-ctags']

			" 禁用 gutentags 自动加载 gtags 数据库的行为
			let g:gutentags_auto_add_gtags_cscope = 1

			" change focus to quickfix window after search (optional).
			let g:gutentags_plus_switch = 1

			let g:gutentags_plus_nomap = 1
			noremap <silent> <leader>gs :GscopeFind s <C-R><C-W><cr>
			noremap <silent> <leader>gg :GscopeFind g <C-R><C-W><cr>
			noremap <silent> <leader>gc :GscopeFind c <C-R><C-W><cr>
			noremap <silent> <leader>gt :GscopeFind t <C-R><C-W><cr>
			noremap <silent> <leader>ge :GscopeFind e <C-R><C-W><cr>
			noremap <silent> <leader>gf :GscopeFind f <C-R>=expand("<cfile>")<cr><cr>
			noremap <silent> <leader>gi :GscopeFind i <C-R>=expand("<cfile>")<cr><cr>
			noremap <silent> <leader>gd :GscopeFind d <C-R><C-W><cr>
			noremap <silent> <leader>ga :GscopeFind a <C-R><C-W><cr>
			noremap <silent> <leader>gz :GscopeFind z <C-R><C-W><cr>

			" 调试模式开关
			"let g:gutentags_define_advanced_commands = 1
		endif
	"}

	"NerdTree {
		if isdirectory(expand("~/.vim/plugged/nerdtree"))
			"map <C-e> :NERDTreeMirror<CR>
			map <leader>e :NERDTreeMirror<CR>
			map <leader>e :NERDTreeToggle<CR>
			"map <leader>e :NERDTreeFind<CR>
			"nmap <leader>nt :NERDTreeFind<CR>
				
			let NERDTreeShowBookmarks=1
			let NERDTreeIgnore=['\.py[cd]$', '\~$', '\.swo$', '\.swp$', '^\.git$', '^\.hg$', '^\.svn$', '\.bzr$']
			let NERDTreeChDirMode=0
			let NERDTreeQuitOnOpen=0
			let NERDTreeMouseMode=2
			let NERDTreeShowHidden=1
			let NERDTreeKeepTreeInNewTab=1
			let g:nerdtree_tabs_open_on_gui_startup=0
		endif
    "}
	
	"TagBar {
        if isdirectory(expand("~/.vim/plugged/tagbar/"))
            nnoremap <silent> <leader>tt :TagbarToggle<CR>
        endif
    "}
	
	"asyncrun.vim{
		if isdirectory(expand("~/.vim/plugged/asyncrun.vim/"))
			" 自动打开 quickfix window ，高度为 6
			let g:asyncrun_open = 6

			" 任务结束时候响铃提醒
			let g:asyncrun_bell = 1

			" 设置 F10 打开/关闭 Quickfix 窗口
			nnoremap <F10> :call asyncrun#quickfix_toggle(6)<cr>
		endif

	"}

	"ale {
		if isdirectory(expand("~/.vim/plugged/ale/"))
			let g:ale_linters_explicit = 1
			let g:ale_completion_delay = 500
			let g:ale_echo_delay = 20
			let g:ale_lint_delay = 500
			let g:ale_echo_msg_format = '[%linter%] %code: %%s'
			let g:ale_lint_on_text_changed = 'normal'
			let g:ale_lint_on_insert_leave = 1
			let g:airline#extensions#ale#enabled = 1

			let g:ale_c_gcc_options = '-Wall -O2 -std=c99'
			let g:ale_cpp_gcc_options = '-Wall -O2 -std=c++14'
			let g:ale_c_cppcheck_options = ''
			let g:ale_cpp_cppcheck_options = ''
		endif
	"}

	"YouCompleteMe {
		if isdirectory(expand("~/.vim/plugged/YouCompleteMe/"))
			let g:ycm_add_preview_to_completeopt = 0
			let g:ycm_show_diagnostics_ui = 0
			let g:ycm_server_log_level = 'info'
			let g:ycm_min_num_identifier_candidate_chars = 2
			let g:ycm_collect_identifiers_from_comments_and_strings = 1
			let g:ycm_complete_in_strings=1
			let g:ycm_key_invoke_completion = '<c-z>'
			let g:ycm_global_ycm_extra_conf='~/.vim/plugged/YouCompleteMe/third_party/ycmd/cpp/ycm/.ycm_extra_conf.py'
			set completeopt=menu,menuone

			noremap <c-z> <NOP>

			let g:ycm_semantic_triggers =  {
					\ 'c,cpp,python,java,go,erlang,perl': ['re!\w{2}'],
					\ 'cs,lua,javascript': ['re!\w{2}'],
					\ }
		endif
	"}

	"LeaderF {
		if isdirectory(expand("~/.vim/plugged/LeaderF/"))
			"let g:Lf_ShortcutF = '<c-p>'
			"let g:Lf_ShortcutB = '<m-n>'
			"noremap <c-n> :LeaderfMru<cr>
			"noremap <leader>p :LeaderfFunction!<cr>
			"noremap <m-n> :LeaderfBuffer<cr>
			"noremap <m-m> :LeaderfTag<cr>
			
			"文件搜索
			nnoremap <silent> <Leader>f :Leaderf file<CR>
			
			"历史打开过的文件	
			nnoremap <silent> <Leader>m :Leaderf mru<CR>
			
			"Buffer
			nnoremap <silent> <Leader>b :Leaderf buffer<CR>	
			
			"函数搜索（仅当前文件里）
			nnoremap <silent> <Leader>F :Leaderf function<CR>
			
			"模糊搜索，很强大的功能，迅速秒搜	
			nnoremap <silent> <Leader>rg :Leaderf rg<CR> 
			
			let g:Lf_StlSeparator = { 'left': '', 'right': '', 'font': '' }

			let g:Lf_RootMarkers = ['.project', '.root', '.svn', '.git']
			let g:Lf_WorkingDirectoryMode = 'Ac'
			let g:Lf_WindowHeight = 0.30
			let g:Lf_CacheDirectory = expand('~/.vim/cache')
			let g:Lf_ShowRelativePath = 0
			let g:Lf_HideHelp = 1
			let g:Lf_StlColorscheme = 'powerline'
			let g:Lf_PreviewResult = {'Function':0, 'BufTag':0}
		endif
	"}
"}
