" pathogen
execute pathogen#infect()
call pathogen#helptags()

let mapleader = ""

" nerdtree
set encoding=utf-8
let g:NERDTreeDirArrows=0
let g:nerdtree_tabs_open_on_console_startup=1
nmap <leader>n :NERDTree<cr>

syntax on
filetype plugin indent on
set paste
