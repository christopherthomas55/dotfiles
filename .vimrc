set nocompatible
filetype off
syntax enable

"Vundle stuff - required for those plugins
set rtp+=~/.vim/bundle/Vundle.vim
call vundle#begin()
Plugin 'VundleVim/Vundle.vim'
Plugin 'Valloric/YouCompleteMe'
Plugin 'scrooloose/nerdtree.git'
Plugin 'tpope/vim-surround'
Plugin 'vim-syntastic/syntastic'


" ----- Apearance
Plugin 'morhetz/gruvbox'
Plugin 'itchyny/lightline.vim'

" ----- Git plugins
Plugin 'Xuyuanp/nerdtree-git-plugin'
Plugin 'airblade/vim-gitgutter'
Plugin 'tpope/vim-fugitive'


" ----- Old -----
"Plugin 'python-mode/python-mode.git'
"Plugin 'vimwiki/vimwiki'
call vundle#end()


filetype plugin indent on

"Fave colors
colorscheme gruvbox
set t_Co=256
let g:gruvbox_termcolors = 256
let g:gruvbox_italic=1
set bg=dark
highlight link Operator GruvboxBlue

" Git gutter edits
set updatetime=100

" Syntastic options
set statusline+=%#warningmsg#
set statusline+=%{SyntasticStatuslineFlag()}
set statusline+=%*

let g:syntastic_mode_map = {'mode':'passive'}

let g:syntastic_python_checkers = ['pylint'] ", 'pycodestyle']
"let g:syntastic_cpp_checkers = ['clang_tidy', 'gcc']
let g:syntastic_always_populate_loc_list = 1
let g:syntastic_auto_loc_list = 0
let g:syntastic_check_on_open = 1
let g:syntastic_check_on_wq = 0
let g:syntastic_aggregate_errors = 1

" Allows syntastic to show when YCM isnt working
let g:ycm_show_diagnostics_ui = 0

" Allows use of virtualenv
let g:ycm_python_binary_path = 'python'

"Set  standards ( including number)
set autoindent
set backspace=indent,eol,start
set complete-=i
set smarttab
set nrformats-=octal
set number
set relativenumber
set encoding=utf-8

"Tabs are just spaces
set expandtab

"Trying out cursorline
set cursorline 

" No shift to commands and repeat ; for repeats
map ; :
noremap ;; ;

" Enable code folding
set foldmethod=indent
set foldlevel=99
nnoremap <space> za

" For speed
set lazyredraw

" Widths
set tabstop=4
set softtabstop=4
set shiftwidth=4
set textwidth=79

"Copied for c since I'm lazy
au BufNewFile,BufRead *.c, *.cpp
    \ set tabstop=4 |
    \ set softtabstop=4 |
    \ set shiftwidth=4 |
    \ set textwidth=79 |
    \ set fileformat=unix |
    \ set colorcolumn=+1  |
    \ syntax on

"language specific tabbing and width constraints
au BufNewFile,BufRead *.py
    \ set tabstop=4 |
    \ set softtabstop=4 |
    \ set shiftwidth=4 |
    \ set textwidth=79 |
    \ set fileformat=unix |
    \ set colorcolumn=100 |
    \ syntax on

au BufNewFile,BufRead *.js,*.html,*.css
    \ set tabstop=2 |
    \ set softtabstop=2 |
    \ set shiftwidth=2 


"Move vertically even in long lines
nnoremap j gj
nnoremap k gk

"Move through navigation panes easy
nnoremap <C-J> <C-W><C-J>
nnoremap <C-K> <C-W><C-K>
nnoremap <C-L> <C-W><C-L>
nnoremap <C-H> <C-W><C-H>

"Key Command to toggle NERDtree
nnoremap <C-n> :NERDTreeToggle <Enter>

"Navigate  location list
nnoremap ]l :lnext <Enter>
nnoremap [l :lprevious <Enter>

au BufRead,BufNewFile *.py,*.pyw,*.c,*.h match ErrorMsg /\s\+$/


"Apprently give virtualenv support to YouCompleteMe

"py << EOF
"import os
"import sys
"if 'VIRTUAL_ENV' in os.environ:
  "project_base_dir = os.environ['VIRTUAL_ENV']
  "activate_this = os.path.join(project_base_dir, 'bin/activate_this.py')
  "execfile(activate_this, dict(__file__=activate_this))
"EOF

set incsearch

set laststatus=2
set ruler
set wildmenu
set display+=lastline
set autoread
set sessionoptions-=options

" Allow color schemes to do bright colors without forcing bold.
if &t_Co == 8 && $TERM !~# '^linux\|^Eterm'
  set t_Co=256
endif

" To go up one screen
inoremap <C-U> <C-G>u<C-U>

set t_ut=
