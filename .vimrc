" ======================================================================
" Vundle initialization
"=======================================================================

" no vi-compatible
set nocompatible

" Setting up Vundle - the vim plugin bundler
let iCanHazVundle=1
let vundle_readme=expand('~/.vim/bundle/vundle/README.md')
if !filereadable(vundle_readme)
	echo "Installing Vundle..."
	echo ""
	silent !mkdir -p ~/.vim/bundle
	silent !git clone https://github.com/gmarik/vundle ~/.vim/bundle/vundle
	let iCanHazVundle=0
endif

filetype off

set rtp+=~/.vim/bundle/vundle/
call vundle#rc()

" let Vundle manage Vundle
Bundle 'gmarik/vundle'


" ======================================================================
" Active plugins
" You can disable or add new ones here:
"=======================================================================

" Better file browser
Bundle 'scrooloose/nerdtree'

" Code commenter
Bundle 'scrooloose/nerdcommenter'

" Class/module browser
Bundle 'majutsushi/tagbar'

" Code and files fuzzy finder
Bundle 'kien/ctrlp.vim'

" Extension to ctrlp, for fuzzy command finder
Bundle 'fisadev/vim-ctrlp-cmdpalette'

" Consoles as buffers
Bundle 'rosenfeld/conque-term'

" Autoclose
Bundle 'Townk/vim-autoclose'

" Surround
Bundle 'tpope/vim-surround'

" Better autocompletion
Bundle 'Shougo/neocomplcache.vim'

" Yank history navigation
Bundle 'YankRing.vim'

" Airline
Bundle 'bling/vim-airline'

" Show trailing whitespace
Bundle 'ShowTrailingWhitespace'

" Color Themes
Bundle 'flazz/vim-colorschemes'

" Syntax for Embperl files
Bundle 'Embperl_Syntax.zip'

" Mini buffers explorer
Bundle 'minibufexpl.vim'


" ======================================================================
" Install plugins the first time vim runs
"=======================================================================

if iCanHazVundle == 0
	echo "Installing Bundles, please ignore key map error messages"
	echo ""
	:BundleInstall
endif


" ======================================================================
" Vim settings and mappings
" You can edit them as you wish
"=======================================================================

" allow plugins by file type (required for plugins!)
filetype plugin on
filetype indent on

" setting leader key
let mapleader = ","

" tabs and spaces handling
set tabstop=4
set shiftwidth=4
set textwidth=100

" always show status bar
set ls=2

" incremental search
set incsearch

" highlighted search results
set hlsearch

" syntax highlight on
syntax on

" show line numbers
set nu

" show cursor line
set cursorline

" highlight matching braces
set showmatch

" use indentation of previous line
set autoindent

" use intelligent indentation for C
set smartindent
set hidden

" use 256 colors when possible
if &term =~? 'mlterm\|xterm\|xterm-256\|screen-256'
	let &t_Co = 256
	colorscheme Monokai
else
	colorscheme delek
endif

" when scrolling, keep cursor 3 lines away from screen border
set scrolloff=3

" autocompletion of files and commands behaves like shell
" (complete only the common part, list the options that match)
set wildmode=list:longest

" better backup, swap and undos storage
set directory=~/.vim/dirs/tmp " directory to place swap files in
set backup " make backup files
set backupdir=~/.vim/dirs/backups " where to put backup files
set undofile " persistent undos - undo after you re-open the file
set undodir=~/.vim/dirs/undos
set viminfo+=n~/.vim/dirs/viminfo

" create needed directories if they don't exist
if !isdirectory(&backupdir)
	call mkdir(&backupdir, "p")
endif
if !isdirectory(&directory)
	call mkdir(&directory, "p")
endif
if !isdirectory(&undodir)
	call mkdir(&undodir, "p")
endif

" toggle line number
map <F1> :set nonumber!<CR>
imap <F1><ESC> :set nonumber!<CR>i

" paste mode toggle
map <F2> :set invpaste<CR>
imap <F2> <C-O>:set invpaste<CR>
set pastetoggle=<F2>

" bind K to grep word under cursor
nnoremap K :grep! "\b<C-R><C-W>\b"<CR>:cw<CR>

" autocompletion of files and commands behaves like shell
" (complete only the common part, list the options that match)
set wildmode=list:longest

" next y previous buffer using shift+arrow
map <S-Left> :bnext<CR>
map <S-Right> :bprev<CR>

" this machine config
if filereadable(expand("~/.vimrc.local"))
	source ~/.vimrc.local
endif

" =====================================================================
" Plugins settings and mappings
" Edit them as you wish.
"=======================================================================

" The Silver Searcher --------------------

if executable('ag')
  " Use ag over grep
  set grepprg=ag\ --nogroup\ --nocolor

  " Use ag in CtrlP for listing files. Lightning fast and respects .gitignore
  let g:ctrlp_user_command = 'ag %s -l --nocolor -g ""'

  " ag is fast enough that CtrlP doesn't need to cache
  let g:ctrlp_use_caching = 0
endif

" bind \ (backward slash) to grep shortcut
command -nargs=+ -complete=file -bar Ag silent! grep! <args>|cwindow|redraw!

nnoremap \ :Ag<SPACE>

" Tagbar -----------------------------

" toggle tagbar display
map <F5> :TagbarToggle<CR>

" autofocus on tagbar open
let g:tagbar_autofocus = 1

" NERDTree -----------------------------

" toggle nerdtree display
map <F4> :NERDTreeToggle<CR>

" open nerdtree with the current file selected
nmap ,t :NERDTreeFind<CR>

let g:NERDTreeWinSize=60
let g:NERDTreeQuitOnOpen=1
let g:NERDTreeShowBookmarks=1
let NERDTreeIgnore=['\.vim$', '\~$', '.o$', 'tags$', '\.pyc$', '\.pyo$']

" CtrlP ------------------------------

" file finder mapping
let g:ctrlp_map = ',e'

" tags (symbols) in current file finder mapping
nmap ,b :CtrlPBuffer<CR>

" tags (symbols) in current file finder mapping
nmap ,g :CtrlPBufTag<CR>

" tags (symbols) in all files finder mapping
nmap ,G :CtrlPBufTagAll<CR>

" general code finder in all files mapping
nmap ,f :CtrlPLine<CR>

" recent files finder mapping
nmap ,m :CtrlPMRUFiles<CR>

" commands finder mapping
nmap ,o :CtrlPCmdPalette<CR>

" to be able to call CtrlP with default search text
function! CtrlPWithSearchText(search_text, ctrlp_command_end)
	execute ':CtrlP' . a:ctrlp_command_end
	call feedkeys(a:search_text)
endfunction

" same as previous mappings, but calling with current word as default text
nmap ,wg :call CtrlPWithSearchText(expand('<cword>'), 'BufTag')<CR>
nmap ,wG :call CtrlPWithSearchText(expand('<cword>'), 'BufTagAll')<CR>
nmap ,wf :call CtrlPWithSearchText(expand('<cword>'), 'Line')<CR>
nmap ,we :call CtrlPWithSearchText(expand('<cword>'), '')<CR>
nmap ,pe :call CtrlPWithSearchText(expand('<cfile>'), '')<CR>
nmap ,wm :call CtrlPWithSearchText(expand('<cword>'), 'MRUFiles')<CR>
nmap ,wc :call CtrlPWithSearchText(expand('<cword>'), 'CmdPalette')<CR>

" don't change working directory
let g:ctrlp_working_path_mode = 0

" ignore these files and folders on file finder
let g:ctrlp_custom_ignore = {
\ 'dir': '\v[\/](\.git|\.hg|\.svn)$',
\ 'file': '\.pyc$\|\.pyo$',
\ }

" Autoclose ------------------------------

" Fix to let ESC work as espected with Autoclose plugin
let g:AutoClosePumvisible = {"ENTER": "\<C-Y>", "ESC": "\<ESC>"}

" NeoComplCache ------------------------------

" enable at startup
let g:neocomplcache_enable_at_startup = 1

" enable all types of completion
let g:neocomplcache_enable_ignore_case = 1
let g:neocomplcache_enable_smart_case = 1
let g:neocomplcache_enable_auto_select = 1
let g:neocomplcache_enable_fuzzy_completion = 1
let g:neocomplcache_enable_camel_case_completion = 1
let g:neocomplcache_enable_underbar_completion = 1

" minimun to start completion
let g:neocomplcache_fuzzy_completion_start_length = 3
let g:neocomplcache_auto_completion_start_length = 3
let g:neocomplcache_auto_completion_start_length = 3
let g:neocomplcache_manual_completion_start_length = 1
let g:neocomplcache_min_keyword_length = 3
let g:neocomplcache_min_syntax_length = 3

" complete with workds from any opened file
let g:neocomplcache_same_filetype_lists = {}
let g:neocomplcache_same_filetype_lists._ = '_'

inoremap <expr><C-g>     neocomplcache#undo_completion()
inoremap <expr><C-l>     neocomplcache#complete_common_string()

" YankRing ------------------------------

" store yankring history file there too
let g:yankring_history_dir = '~/.vim/dirs/'

" select yank from buffer
nnoremap <silent> <F3> :YRShow<CR>
imap <silent> <F3> :YRShow<CR>

" Airline ------------------------------

let g:airline_powerline_fonts = 0
let g:airline_theme = 'bubblegum'
let g:airline#extensions#whitespace#enabled = 0

" Minibuffexplorer ------------------------------

let g:miniBufExplMapWindowNavArrows = 1

" Perl syntax check ---------------------------------------------------

map <leader>scp :call Perl_SyntaxCheck()<CR>
function! Perl_SyntaxCheck ()

	exe ":cclose"
	let l:currentbuffer = bufname("%")
	let l:fullname = expand("%:p")
	silent exe ":update"

	exe ':set makeprg=perl\ -c\ -I/epl/src/devel/perl\ -I/epl/src/perl/perl\ -I/epl/src/admin/perl\ -I/epl/src/devel/perl\ -I/epl/src/admin/tests/admin'
	exe ':setlocal errorformat=
		\%-G%.%#had\ compilation\ errors.,
		\%-G%.%#syntax\ OK,
		\%m\ at\ %f\ line\ %l.,
			\%+A%.%#\ at\ %f\ line\ %l\\,%.%#,
		\%+C%.%#'
	let l:fullname = fnameescape( l:fullname )
	silent exe ':make '.l:fullname

	exe ":botright cwindow"
	exe ':setlocal errorformat='
	exe "set makeprg=make"

	redraw!
	if l:currentbuffer == bufname("%")
		echohl Search
		echomsg l:currentbuffer." : Syntax is OK"
		echohl None
		return 0
	else
		setlocal wrap
		setlocal linebreak
	endif

endfunction
