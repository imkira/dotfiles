""""""""""""""""""""""""""""""""""""""
" Plugins
""""""""""""""""""""""""""""""""""""""

call plug#begin('~/.vim/plugged')

Plug 'altercation/vim-colors-solarized'
Plug 'guns/xterm-color-table.vim'

Plug 'Valloric/YouCompleteMe'
Plug 'SirVer/ultisnips'
Plug 'honza/vim-snippets'
Plug 'kien/ctrlp.vim'
Plug 'scrooloose/nerdtree'
Plug 'scrooloose/nerdcommenter'
Plug 'mileszs/ack.vim'
Plug 'rking/ag.vim'
Plug 'scrooloose/syntastic'
Plug 'Lokaltog/vim-powerline', {'branch': 'develop'}
Plug 'tpope/vim-fugitive'
Plug 'tpope/vim-repeat'
Plug 'tpope/vim-surround'
Plug 'tpope/vim-endwise'
Plug 'vim-scripts/taglist.vim'
Plug 'vim-scripts/Rename'
Plug 'majutsushi/tagbar'
Plug 'sjl/gundo.vim'
Plug 'vim-scripts/FencView.vim'
Plug 'vim-scripts/AutoFenc.vim'
Plug 'tpope/vim-obsession'
Plug 'derekwyatt/vim-fswitch'
Plug 'godlygeek/tabular'

Plug 'tpope/vim-git'
Plug 'vim-ruby/vim-ruby'
Plug 'tpope/vim-bundler'
Plug 'tpope/vim-rails'
Plug 'tpope/vim-cucumber'
Plug 'tpope/vim-haml'
Plug 'othree/html5.vim'
Plug 'pangloss/vim-javascript'
Plug 'briancollins/vim-jst'
Plug 'kchmck/vim-coffee-script'
Plug 'itspriddle/vim-jquery'
Plug 'tpope/vim-markdown'
Plug 'timcharper/textile.vim'
Plug 'elzr/vim-json'
Plug 'uarun/vim-protobuf'
Plug 'fatih/vim-go'
Plug 'vim-scripts/vim-terraform'

call plug#end()

""""""""""""""""""""""""""""""""""""""
" GENERAL
""""""""""""""""""""""""""""""""""""""

" vi-improved
set nocompatible

" required
filetype off

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
set undodir=~/.vim/undo
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

" expand folds when opening files
au BufRead * normal zR

" highlight current column/row
set cul

" disable scratch window
set completeopt-=preview

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

" define leaders
let mapleader=","
let g:mapleader=","
let maplocalleader="\\"

" easier movement between windows
map <C-Right> <C-w>l
map <C-l> <C-w>l
map <C-Left> <C-w>h
map <C-h> <C-w>h
map <C-Up> <C-w>k
map <C-k> <C-w>k
map <C-Down> <C-w>j
map <C-j> <C-w>j

" easier movement between tabs
map <D-A-Left> :tabprev<CR>
map <D-A-Right> :tabnext<CR>

" move within wrapped lines
nmap j gj
nmap k gk

" clear last hlsearch
nmap <silent> <Leader>/ :nohlsearch<CR>

" pretty print json
map <silent> <leader>jt <Esc>:%!jshon<CR>
vmap <silent> <leader>jt :!jshon<CR>

" reformat all file and center on the cursor
map <Leader>f mZgg=G`Zzz

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
" syntastic
""""""""""""""""""""""""""""""""""""""

" disable checkers for go
let g:syntastic_go_checkers = []

""""""""""""""""""""""""""""""""""""""
" YouCompleteMe
""""""""""""""""""""""""""""""""""""""

let g:ycm_use_ultisnips_completer = 1
let g:ycm_collect_identifiers_from_comments_and_strings = 1
let g:ycm_complete_in_comments = 1
let g:ycm_autoclose_preview_window_after_completion = 1
let g:ycm_min_num_of_chars_for_completion = 1

""""""""""""""""""""""""""""""""""""""
" UltiSnips
""""""""""""""""""""""""""""""""""""""

function! g:UltiSnips_Complete()
  call UltiSnips#ExpandSnippet()
  if g:ulti_expand_res == 0
    if pumvisible()
      return "\<C-n>"
    else
      call UltiSnips#JumpForwards()
      if g:ulti_jump_forwards_res == 0
        return "\<TAB>"
      endif
    endif
  endif
  return ""
endfunction

function! g:UltiSnips_Reverse()
  call UltiSnips#JumpBackwards()
  if g:ulti_jump_backwards_res == 0
    return "\<C-P>"
  endif

  return ""
endfunction


if !exists("g:UltiSnipsJumpForwardTrigger")
  let g:UltiSnipsJumpForwardTrigger = "<tab>"
endif

if !exists("g:UltiSnipsJumpBackwardTrigger")
  let g:UltiSnipsJumpBackwardTrigger="<s-tab>"
endif

au InsertEnter * exec "inoremap <silent> " . g:UltiSnipsExpandTrigger . " <C-R>=g:UltiSnips_Complete()<cr>"
au InsertEnter * exec "inoremap <silent> " . g:UltiSnipsJumpBackwardTrigger . " <C-R>=g:UltiSnips_Reverse()<cr>"

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

let g:go_bin_path = $GOPATH . '/bin'
let g:go_fmt_command = 'goimports'

""""""""""""""""""""""""""""""""""""""
" vim-json
""""""""""""""""""""""""""""""""""""""

let g:vim_json_syntax_conceal = 0

""""""""""""""""""""""""""""""""""""""
" vim diff
""""""""""""""""""""""""""""""""""""""
au FilterWritePre * if &diff | colorscheme diff | endif
