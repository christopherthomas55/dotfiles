set nocompatible
filetype off
syntax enable

"Vundle stuff - required for those plugins
set rtp+=~/.vim/bundle/Vundle.vim
call vundle#begin()
Plugin 'VundleVim/Vundle.vim'
Plugin 'Valloric/YouCompleteMe'
Plugin 'scrooloose/nerdtree.git'
Plugin 'python-mode/python-mode.git'
Plugin 'Xuyuanp/nerdtree-git-plugin'
Plugin 'vimwiki/vimwiki'
Plugin 'morhetz/gruvbox'

call vundle#end()
filetype plugin indent on

"let g:gruvbox_termcolors = 16
set background=dark
let g:gruvbox_italic=1
colorscheme gruvbox

let g:vimwiki_folding='syntax'

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

" No shift to commands
map ; :
noremap ;; ;

" Enable code folding
set foldmethod=indent
set foldlevel=99
nnoremap <space> za

" For speed
set lazyredraw

"language specific tabbing and width constraints
au BufNewFile,BufRead *.py
    \set tabstop=4
    \set softtabstop=4
    \set shiftwidth=4
    \set textwidth=79
    \set fileformat=unix
    \set colorcolumn=+1 
    \let g:pymode = 1
    \let g:pymode_syntax = 1

highlight colorcolumn ctermbg=blue guibg=blue

au BufNewFile,BufRead *.js, *.html, *.css
    \set tabstop=2
    \set softtabstop=2
    \set shiftwidth=2


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

au BufRead,BufNewFile *.py,*.pyw,*.c,*.h match ErrorMsg /\s\+$/


"Apprently give virtualenv support to YouCompleteMe

py << EOF
import os
import sys
if 'VIRTUAL_ENV' in os.environ:
  project_base_dir = os.environ['VIRTUAL_ENV']
  activate_this = os.path.join(project_base_dir, 'bin/activate_this.py')
  execfile(activate_this, dict(__file__=activate_this))
EOF

set incsearch

set laststatus=2
set ruler
set wildmenu
set display+=lastline
set autoread
set sessionoptions-=options

" Allow color schemes to do bright colors without forcing bold.
if &t_Co == 8 && $TERM !~# '^linux\|^Eterm'
  set t_Co=16
endif

inoremap <C-U> <C-G>u<C-U>


