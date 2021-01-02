""""""""""""""""""""""""""""""""""""""
" Plugins
""""""""""""""""""""""""""""""""""""""

call plug#begin(stdpath('data') . '/plugged')

" Visual
Plug 'lifepillar/vim-solarized8'
Plug 'guns/xterm-color-table.vim'
Plug 'vim-airline/vim-airline'

" Vim/tmux Integration
Plug 'christoomey/vim-tmux-navigator'

" Session Management
Plug 'tpope/vim-obsession'
Plug 'dhruvasagar/vim-prosession'

" Alignment
Plug 'godlygeek/tabular'

" Autocomplete
Plug 'junegunn/fzf'
Plug 'junegunn/fzf.vim'

" File management
Plug 'tpope/vim-eunuch'

" Git
Plug 'tpope/vim-fugitive'
Plug 'airblade/vim-gitgutter'

" Language support
Plug 'dense-analysis/ale'
Plug 'neoclide/coc.nvim', {'branch': 'release'}
Plug 'josa42/coc-go', {'do': 'yarn install --frozen-lockfile'}
Plug 'neoclide/coc-python', {'do': 'yarn install --frozen-lockfile'}
Plug 'neoclide/coc-java', {'do': 'yarn install --frozen-lockfile'}
Plug 'neoclide/coc-tsserver', {'do': 'yarn install --frozen-lockfile'}
Plug 'sheerun/vim-polyglot'
Plug 'hashivim/vim-terraform'

call plug#end()

""""""""""""""""""""""""""""""""""""""
" vim
""""""""""""""""""""""""""""""""""""""

" Show line numbers.
set number

" Show gutter for 3 symbols.
set signcolumn=yes:3

" Time between updates (required to get quick feedback).
" The default is too high (4000 ms) but we should use a faster rate as
" suggested by airblade/vim-gitgutter and neoclide/coc.nvim.
set updatetime=100

" Highlight current column/row.
set cursorline

" Command height set to 2 lines for displaying longer messages as suggested by
" neoclide/coc.nvim
set cmdheight=2

" Max 79 chars per line.
set textwidth=79

" Wrap lines at breakat character boundaries.
set wrap linebreak nolist

" Indent to 2 spaces by default.
set tabstop=2
set shiftwidth=2

" TAB expands to spaces.
set expandtab

" Show TAB characters.
set list
set listchars=tab:▸\

" Groups of lines with same indent form a fold.
set foldmethod=indent

" Search is case insensitive when all characters are lowercase, and case
" sensitive when there is at least one uppercase character.
set ignorecase
set smartcase

" Hide buffers when they get abandoned.
set hidden

" Automatically save/restore file undo history.
set undofile

" Maximum number of changes that can be undone.
set undolevels=100000

" Always save the undo file irrespective of the number of lines.
set undoreload=-1

" Don't write a backup while writing a file as suggested by neoclide/coc.nvim.
" Some LSP servers have issues with backup files.
set nobackup
set nowritebackup

" Keep this much number of commands in history.
set history=10000

" Use system clipboard.
set clipboard=unnamed

" Enable mouse support for all modes.
set mouse=a

" Don't pass messages to |ins-completion-menu| as suggested by by
" neoclide/coc.nvim.
set shortmess+=c

""""""""""""""""""""""""""""""""""""""
" maps
""""""""""""""""""""""""""""""""""""""

" Define map leaders.
let g:mapleader=","
let mapleader=","
let maplocalleader="\\"

" Searching for nothing clears last search highlight.
nmap <silent> <leader>/ :nohlsearch<CR>

" Easier movement between windows.
map <C-Right> <C-w>l
map <C-l> <C-w>l
map <C-Left> <C-w>h
map <C-h> <C-w>h
map <C-Up> <C-w>k
map <C-k> <C-w>k
map <C-Down> <C-w>j
map <C-j> <C-w>j

" Map p in visual mode so that when pasting over something
" we don't loose the yanked text.
xnoremap p "_dP

" Easier movement between tabs.
map <D-A-Left> :tabprev<CR>
map <D-A-Right> :tabnext<CR>

" Move within wrapped lines.
nmap j gj
nmap k gk

""""""""""""""""""""""""""""""""""""""
" lifepillar/vim-solarized8
""""""""""""""""""""""""""""""""""""""

set background=dark
let g:solarized_termcolors=256
let g:solarized_termtrans=1
if has('gui_running')
  set termguicolors
end
colorscheme solarized8_high

""""""""""""""""""""""""""""""""""""""
" vim-airline/vim-airline
""""""""""""""""""""""""""""""""""""""

" Automatically displays all buffers when there's only one tab open.
let g:airline#extensions#tabline#enabled = 1

" Integrate with powerline fonts.
let g:airline_powerline_fonts = 1

""""""""""""""""""""""""""""""""""""""
" dhruvasagar/vim-prosession
""""""""""""""""""""""""""""""""""""""

" Set session directory.
let g:prosession_dir=stdpath('data') . '/session'

""""""""""""""""""""""""""""""""""""""
" junegunn/fzf.vim
""""""""""""""""""""""""""""""""""""""

" Open fzf with ctrl-p
noremap <C-p> :FZF<CR>

" Open rg with ctrl-t
noremap <C-t> :Rg<CR>

""""""""""""""""""""""""""""""""""""""
" airblade/vim-gitgutter
""""""""""""""""""""""""""""""""""""""

" Maximum number of changes after which gitgutter will suppress the signs.
let g:gitgutter_max_signs = 5000

""""""""""""""""""""""""""""""""""""""
" dense-analysis/ale
""""""""""""""""""""""""""""""""""""""

" Configure gutter symbol for error.
let g:ale_sign_error = 'E'

" Configure gutter symbol for warning.
let g:ale_sign_warning = 'W'

" Configure gutter symbol for info.
let g:ale_sign_info = 'I'

" Configure message string format.
let g:ale_echo_msg_format = '[%linter%] [%severity%:%code%] %s'

" Tools
" https://github.com/dense-analysis/ale/blob/master/supported-tools.md

" Configure the following linters.
let g:ale_linters = {
\    'go'         : ['gofmt', 'golangci-lint'],
\    'kotlin'     : ['kotlinc', 'ktlint', 'languageserver'],
\    'javascript' : ['eslint'],
\    'markdown'   : ['mdl'],
\    'python'     : ['pylint', 'flake8', 'pyls'],
\    'sh'         : ['shell', 'shellcheck'],
\    'yaml'       : ['yamllint'],
\    'zsh'        : ['shell', 'shellcheck']
\}

" Run fixers on save.
let g:ale_fix_on_save = 1

" Configure the following fixers.
let g:ale_fixers = {
\    '*'          : ['remove_trailing_lines', 'trim_whitespace'],
\    'go'         : ['gofmt', 'goimports', 'remove_trailing_lines', 'trim_whitespace'],
\    'javascript' : ['remove_trailing_lines', 'trim_whitespace', 'eslint'],
\    'markdown'   : ['remove_trailing_lines', 'trim_whitespace', 'prettier'],
\    'python'     : ['remove_trailing_lines', 'trim_whitespace', 'pylint', 'autopep8', 'isort'],
\    'json'       : ['remove_trailing_lines', 'trim_whitespace', 'prettier'],
\    'sh'         : ['remove_trailing_lines', 'trim_whitespace', 'shfmt'],
\    'yaml'       : ['remove_trailing_lines', 'trim_whitespace', 'prettier'],
\    'zsh'        : ['remove_trailing_lines', 'trim_whitespace', 'shfmt']
\}

""""""""""""""""""""""""""""""""""""""
" neoclide/coc.nvim
""""""""""""""""""""""""""""""""""""""

" Use tab for trigger completion with characters ahead and navigate.
" NOTE: Use command ':verbose imap <tab>' to make sure tab is not mapped by
" other plugin before putting this into your config.
inoremap <silent><expr> <TAB>
      \ pumvisible() ? "\<C-n>" :
      \ <SID>check_back_space() ? "\<TAB>" :
      \ coc#refresh()
inoremap <expr><S-TAB> pumvisible() ? "\<C-p>" : "\<C-h>"

function! s:check_back_space() abort
  let col = col('.') - 1
  return !col || getline('.')[col - 1]  =~# '\s'
endfunction

" Use <c-space> to trigger completion.
inoremap <silent><expr> <c-space> coc#refresh()

" Use <cr> to confirm completion, `<C-g>u` means break undo chain at current
" position. Coc only does snippet and additional edit on confirm.
if exists('*complete_info')
  inoremap <expr> <cr> complete_info()["selected"] != "-1" ? "\<C-y>" : "\<C-g>u\<CR>"
else
  imap <expr> <cr> pumvisible() ? "\<C-y>" : "\<C-g>u\<CR>"
endif

" Use `[g` and `]g` to navigate diagnostics
nmap <silent> [g <Plug>(coc-diagnostic-prev)
nmap <silent> ]g <Plug>(coc-diagnostic-next)

" GoTo code navigation.
nmap <silent> gd <Plug>(coc-definition)
nmap <silent> gy <Plug>(coc-type-definition)
nmap <silent> gi <Plug>(coc-implementation)
nmap <silent> gr <Plug>(coc-references)

" Use K to show documentation in preview window.
nnoremap <silent> K :call <SID>show_documentation()<CR>

function! s:show_documentation()
  if (index(['vim','help'], &filetype) >= 0)
    execute 'h '.expand('<cword>')
  else
    call CocAction('doHover')
  endif
endfunction

" Highlight the symbol and its references when holding the cursor.
autocmd CursorHold * silent call CocActionAsync('highlight')

" Symbol renaming.
nmap <leader>rn <Plug>(coc-rename)

" Formatting selected code.
xmap <leader>f  <Plug>(coc-format-selected)
nmap <leader>f  <Plug>(coc-format-selected)

augroup mygroup
  autocmd!
  " Setup formatexpr specified filetype(s).
  autocmd FileType typescript,json setl formatexpr=CocAction('formatSelected')
  " Update signature help on jump placeholder.
  autocmd User CocJumpPlaceholder call CocActionAsync('showSignatureHelp')
augroup end

" Applying codeAction to the selected region.
" Example: `<leader>aap` for current paragraph
xmap <leader>a  <Plug>(coc-codeaction-selected)
nmap <leader>a  <Plug>(coc-codeaction-selected)

" Remap keys for applying codeAction to the current line.
nmap <leader>ac  <Plug>(coc-codeaction)
" Apply AutoFix to problem on the current line.
nmap <leader>qf  <Plug>(coc-fix-current)

" Introduce function text object
" NOTE: Requires 'textDocument.documentSymbol' support from the language server.
xmap if <Plug>(coc-funcobj-i)
xmap af <Plug>(coc-funcobj-a)
omap if <Plug>(coc-funcobj-i)
omap af <Plug>(coc-funcobj-a)

" Add `:Format` command to format current buffer.
command! -nargs=0 Format :call CocAction('format')

" Add `:Fold` command to fold current buffer.
command! -nargs=? Fold :call     CocAction('fold', <f-args>)

" Add `:OR` command for organize imports of the current buffer.
command! -nargs=0 OR   :call     CocAction('runCommand', 'editor.action.organizeImport')

" Add (Neo)Vim's native statusline support.
" NOTE: Please see `:h coc-status` for integrations with external plugins that
" provide custom statusline: lightline.vim, vim-airline.
set statusline^=%{coc#status()}%{get(b:,'coc_current_function','')}

" Mappings using CoCList:
" Show all diagnostics.
nnoremap <silent> <space>a  :<C-u>CocList diagnostics<cr>
" Manage extensions.
nnoremap <silent> <space>e  :<C-u>CocList extensions<cr>
" Show commands.
nnoremap <silent> <space>c  :<C-u>CocList commands<cr>
" Find symbol of current document.
nnoremap <silent> <space>o  :<C-u>CocList outline<cr>
" Search workspace symbols.
nnoremap <silent> <space>s  :<C-u>CocList -I symbols<cr>
" Do default action for next item.
nnoremap <silent> <space>j  :<C-u>CocNext<CR>
" Do default action for previous item.
nnoremap <silent> <space>k  :<C-u>CocPrev<CR>
" Resume latest coc list.
nnoremap <silent> <space>p  :<C-u>CocListResume<CR>

""""""""""""""""""""""""""""""""""""""
" hashivim/vim-terraform
""""""""""""""""""""""""""""""""""""""

" Allow vim-terraform to align settings automatically with Tabularize.
let g:terraform_align=1

" Allow vim-terraform to automatically format *.tf and *.tfvars files with
" terraform fmt. You can also do this manually with the :TerraformFmt command.
let g:terraform_fmt_on_save=1
