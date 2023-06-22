set number
set autoindent
set expandtab
set relativenumber
set cursorline
set showmatch
set hlsearch
set incsearch
set ignorecase
set showcmd
set showmode

set mouse=a
set encoding=utf-8
set t_Co=256
set tabstop=2
set softtabstop=2
set shiftwidth=4
set scrolloff=5

syntax on
filetype indent on

" key mapping
let mapleader=' '

inoremap jj <esc>
nnoremap J 5j
nnoremap K 5k

nnoremap <leader>wq :wq<CR>
nnoremap <leader>q :q<CR>
nnoremap <Backspace> :nohl<CR>
