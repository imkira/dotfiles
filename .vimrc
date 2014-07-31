""""""""""""""""""""""""""""""""""""""
" VUNDLE
""""""""""""""""""""""""""""""""""""""

" use Vim settings
set nocompatible

" enable vundle
filetype off
set rtp+=~/.vim/bundle/vundle/
call vundle#rc()

" let vundle manage itself
Bundle 'gmarik/vundle'

Bundle 'altercation/vim-colors-solarized'
Bundle 'guns/xterm-color-table.vim'

Bundle 'SirVer/ultisnips'
Bundle 'ervandew/supertab'
Bundle 'kien/ctrlp.vim'
Bundle 'scrooloose/nerdtree'
Bundle 'scrooloose/nerdcommenter'
Bundle 'mileszs/ack.vim'
Bundle 'scrooloose/syntastic'
Bundle 'Lokaltog/vim-powerline'
Bundle 'tpope/vim-fugitive'
Bundle 'tpope/vim-repeat'
Bundle 'tpope/vim-surround'
Bundle 'tpope/vim-endwise'
Bundle 'vim-scripts/taglist.vim'
Bundle 'vim-scripts/Rename.git'
Bundle 'majutsushi/tagbar'
Bundle 'sjl/gundo.vim'
Bundle 'vim-scripts/FencView.vim'
Bundle 'vim-scripts/AutoFenc.vim'
Bundle 'tpope/vim-obsession'
Bundle 'derekwyatt/vim-fswitch'

Bundle 'tpope/vim-git'
Bundle 'vim-ruby/vim-ruby'
Bundle 'tpope/vim-bundler'
Bundle 'tpope/vim-rails'
Bundle 'tpope/vim-cucumber'
Bundle 'tpope/vim-haml'
Bundle 'othree/html5.vim'
Bundle 'pangloss/vim-javascript'
Bundle 'briancollins/vim-jst'
Bundle 'kchmck/vim-coffee-script'
Bundle 'itspriddle/vim-jquery'
Bundle 'tpope/vim-markdown'
Bundle 'timcharper/textile.vim'
Bundle 'vim-scripts/JSON.vim'
Bundle 'uarun/vim-protobuf'
Bundle 'fatih/vim-go'

""""""""""""""""""""""""""""""""""""""
" GENERAL
""""""""""""""""""""""""""""""""""""""

" load ftplugins
filetype plugin on

" load indent files
filetype indent on

" utf8
set encoding=utf-8

" allow backspacing over everything in insert mode
set backspace=indent,eol,start

" turn on the visual bell which is much quieter than the audio blink
set vb

" hide buffers instead of closing them
set hidden

" remove all gui crap and enable support for mouse
set mouse=a
set guioptions=a
set ttymouse=xterm2

" use fast terminal connection
set ttyfast

" starting a new line uses correct indentation
set smartindent

" use open windows for corresponding quickfix errors
set switchbuf=useopen

" line break for long lines
set wrap linebreak nolist

" keep this much number of commands in history
set history=1000

" backups
if isdirectory($HOME . '/.vim/backup') == 0
  :silent !mkdir -p ~/.vim/backup >/dev/null 2>&1
endif
set backupdir-=.
set backupdir+=.
set backupdir-=~/
set backupdir^=~/.vim/backup/
set backupdir^=./.vim-backup/
set backup
set backupskip+=/private/tmp/*

function! s:RemoveOldBackups(maxbackups)
  let l:pattern = '[0-9]{4}_[0-9]{2}_[0-9]{2}_[0-9]{2}~$'
  let l:dir = substitute(expand('%:p:h'), '/', '%', 'g')
  let l:suffix = l:dir . '%'
  let l:basename = expand('%:t')
  let l:escaped_path = substitute(l:basename . l:suffix, '[\.\^\$\*\+\?\(\)\[\{\\]', '\\\0', 'g')
  let l:find_regex = '^(.\/)?' . l:escaped_path . l:pattern
  let l:backupdirs = split(&backupdir,'\s*,\s*')
  for l:backupdir in l:backupdirs
    if l:backupdir[0] == '.'
      let l:backupdir = expand('%:p:h') . '/' . l:backupdir
    endif
    if !empty(l:backupdir) && isdirectory(l:backupdir)
      call system('cd ' . shellescape(l:backupdir) .
        \ ' && find -E . -maxdepth 1 -regex ' .
        \ shellescape(l:find_regex) .
        \ ' 2>/dev/null | sort -ru | tail +'
        \ . (a:maxbackups + 1) . ' | xargs rm -f')
    endif
  endfor
endfunction

function! s:SetBackupExtension()
  let l:time = strftime("%Y_%m_%d_%H")
  let l:dir = substitute(expand('%:p:h'), '/', '%', 'g')
  let l:suffix = l:dir . '%'
  let &backupext = l:suffix . l:time . '~'
endfunction

autocmd BufWritePre * call s:SetBackupExtension()
autocmd BufWritePost * call s:RemoveOldBackups(12)

" undo
if isdirectory($HOME . '/.vim/undo') == 0
  :silent !mkdir -p ~/.vim/undo >/dev/null 2>&1
endif
set undodir=./.vim-undo
set undodir+=~/.vim/undo
set undofile
set undolevels=10000
set undoreload=10000

" swap
if isdirectory($HOME . '/.vim/swap') == 0
  :silent !mkdir -p ~/.vim/swap >/dev/null 2>&1
endif
set directory=./.vim-swap
set directory+=~/.vim/swap
set directory+=~/tmp
set directory+=.

" viminfo
set viminfo+=n~/.vim/viminfo

" sessions
set sessionoptions=blank,buffers,folds,curdir,tabpages

if isdirectory($HOME . '/.vim/sessions') == 0
  :silent !mkdir -p ~/.vim/sessions >/dev/null 2>&1
endif

function! FindProjectSessionName()
  let l:path = finddir('.git', getcwd() . ';')
  if empty(l:path)
    let l:path = 'default'
  else
    let l:path = fnamemodify(l:path, ':p:h:h:t') . fnamemodify(l:path, ':p:h')
  endif
  return substitute(l:path, '/', '%', 'g')
endfunction

function! RestoreSession(name)
  let l:dir = $HOME . '/.vim/sessions/'
  let l:session = dir . a:name
  let l:escaped_session = dir . escape(a:name, '%')
  let g:has_session = filereadable(l:session)
  if g:has_session
    execute 'source ' . l:escaped_session
  end
  execute 'Obsess ' . l:escaped_session
endfunction

autocmd VimEnter * nested if !argc() | :call RestoreSession(FindProjectSessionName()) | endif

" show list rather than just completing
set wildmenu
set wildmode=list:longest,full

" ignore certain patterns while completing paths
set wildignore=*.bak,*.swp,*.o,*.class,*.meta

""""""""""""""""""""""""""""""""""""""
" VISUAL HELPERS
""""""""""""""""""""""""""""""""""""""

" enable syntax highlighting
syntax on

if has('cmdline_info')
  " show cursor position (always)
  set ruler
  " nice ruler format
  set rulerformat=%30(%=\:b%n%y%m%r%w\ %l,%c%V\ %P%) "
  " display incomplete commands
  set showcmd
endif

if has('statusline')
  set laststatus=2
  " Broken down into easily includeable segments
  set statusline=%<%f\    " Filename
  set statusline+=%w%h%m%r " Options
  set statusline+=%{fugitive#statusline()} "  Git Hotness
  set statusline+=\ [%{&ff}/%Y]            " filetype
  set statusline+=\ [%{getcwd()}]          " current dir
  set statusline+=%=%-14.(%l,%c%V%)\ %p%%  " Right aligned file nav info
endif

" show line numbers
set number

" show line break for wrapped lines
set showbreak==>

" automatically show matching brackets. works like it does in bbedit.
set showmatch

" make sure extra white space color is always set
autocmd ColorScheme * highlight ExtraWhitespace ctermbg=red guibg=red
highlight ExtraWhitespace ctermbg=red guibg=red

" highlight tabs that are not at the start of a line, spaces before a tab,
" and trailing whitespace, except when typing at the end of a line.
match ExtraWhitespace /[^\t]\zs\t\+\| \+\ze\t\|\s\+$/
autocmd BufWinEnter * match ExtraWhitespace /[^\t]\zs\t\+\| \+\ze\t\|\s\+$/
autocmd InsertEnter * match ExtraWhitespace /[^\t]\zs\t\+\| \+\ze\t\|\s\+\%#\@<!$/
autocmd InsertLeave * match ExtraWhitespace /[^\t]\zs\t\+\| \+\ze\t\|\s\+$/
autocmd BufWinLeave * call clearmatches()

""""""""""""""""""""""""""""""""""""""
" SEARCHING
""""""""""""""""""""""""""""""""""""""

" highlight all matches on search
set hlsearch

" highlight while typing
set incsearch

" ignore case when searching
set ignorecase

" continue search at top/bottom of buffer
set wrapscan

""""""""""""""""""""""""""""""""""""""
" VISUAL ASPECT
""""""""""""""""""""""""""""""""""""""
set textwidth=79

" use 256 colors
set t_Co=256

" use solarized
set background=dark
let g:solarized_termcolors=256
let g:solarized_termtrans=1
colorscheme solarized

" default window size on GUI mode
if has('gui_running')
  set gfn=Monaco:h12

  if has('gui_macvim')
    set transparency=02
    set antialias
    set fu
  end

  set lines=9999
  set columns=9999
end

" code folding
set foldmethod=indent

" highlight current column/row
set cul

""""""""""""""""""""""""""""""""""""""
" SPACES/TABS/INDENTATION
""""""""""""""""""""""""""""""""""""""

" indent to 2 spaces
set tabstop=2
set shiftwidth=2

" and make tabs spaces
set expandtab

" use same indentation of current line when starting a new line
set autoindent

""""""""""""""""""""""""""""""""""""""
" KEY MAPPING
""""""""""""""""""""""""""""""""""""""

" define global map leader
let mapleader=","
let g:mapleader=","

" easier movement between windows
noremap <C-Right> <C-w>l
noremap <C-l> <C-w>l
noremap <C-Left> <C-w>h
noremap <C-h> <C-w>h
noremap <C-Up> <C-w>k
noremap <C-k> <C-w>k
noremap <C-Down> <C-w>j
noremap <C-j> <C-w>j

" easier movement between tabs
noremap <D-A-Left> :tabprev<CR>
noremap <D-A-Right> :tabnext<CR>

" move within wrapped lines
nnoremap j gj
nnoremap k gk

" clear last hlsearch
nmap <silent> <Leader>/ :nohlsearch<CR>

" pretty print json
noremap <silent> <leader>jt <Esc>:%!jshon<CR>
vnoremap <silent> <leader>jt :!jshon<CR>

" reformat all file and center on the cursor
noremap <Leader>f mZgg=G`Zzz

""""""""""""""""""""""""""""""""""""""
" SuperTab
""""""""""""""""""""""""""""""""""""""

let g:SuperTabDefaultCompletionType = "context"
let g:supertabbContextDefaultCompletionType = "<c-x><c-o>"

""""""""""""""""""""""""""""""""""""""
" Ctrlp
""""""""""""""""""""""""""""""""""""""

let g:ctrlp_max_files=0
let g:ctrlp_use_caching = 0
let g:ctrlp_working_path_mode = 2
let g:ctrlp_dotfiles = 1
let g:ctrlp_custom_ignore = '\.git$\|\.hg$\|\.svn|\.meta$'
let g:ctrlp_clear_cache_on_exit = 1
let g:ctrlp_root_markers = ['.git', '.hg', '.svn']

""""""""""""""""""""""""""""""""""""""
" Powerline
""""""""""""""""""""""""""""""""""""""

let g:Powerline_symbols = 'unicode'

""""""""""""""""""""""""""""""""""""""
" Gundo
""""""""""""""""""""""""""""""""""""""

nnoremap <F4> :GundoToggle<CR>

""""""""""""""""""""""""""""""""""""""
" NERDTree
""""""""""""""""""""""""""""""""""""""

" open NERDTree when vim starts up if no files were specified
autocmd vimenter * if !argc() && !g:has_session | NERDTree | endif

" toggle NERDTree window
noremap <F2> :NERDTreeToggle<CR>

""""""""""""""""""""""""""""""""""""""
" NERDCommenter
""""""""""""""""""""""""""""""""""""""

" toggle comment
map <Leader># <plug>NERDCommenterToggle

""""""""""""""""""""""""""""""""""""""
" ctags
""""""""""""""""""""""""""""""""""""""

let g:ctags_statusline=1

""""""""""""""""""""""""""""""""""""""
" TagBar
""""""""""""""""""""""""""""""""""""""

let g:tagbar_ctags_bin = '/usr/local/bin/ctags'
let g:tagbar_width = 40
let g:tagbar_autoclose = 0
let g:tagbar_autofocus = 0
let g:tagbar_sort = 0
let g:tagbar_compact = 1
let g:tagbar_expand = 1
let g:tagbar_singleclick = 1
let g:tagbar_foldlevel = 5
let g:tagbar_autoshowtag = 1

noremap <F3> :TagbarToggle<CR>

""""""""""""""""""""""""""""""""""""""
" FSwitch
""""""""""""""""""""""""""""""""""""""

nmap <silent> <Leader>h :FSHere<CR>

""""""""""""""""""""""""""""""""""""""
" vim-go
""""""""""""""""""""""""""""""""""""""

au FileType go nmap <Leader>i <Plug>(go-info)
au FileType go nmap <Leader>gd <Plug>(go-doc)
au FileType go nmap <Leader>gv <Plug>(go-doc-vertical)
au FileType go nmap <Leader>gb <Plug>(go-doc-browser)
au FileType go nmap <leader>r <Plug>(go-run)
au FileType go nmap <leader>b <Plug>(go-build)
au FileType go nmap <leader>t <Plug>(go-test)
au FileType go nmap gd <Plug>(go-def)
au FileType go nmap <Leader>ds <Plug>(go-def-split)
au FileType go nmap <Leader>dv <Plug>(go-def-vertical)
au FileType go nmap <Leader>dt <Plug>(go-def-tab)
