" pathogen
execute pathogen#infect()
call pathogen#helptags()

let mapleader = ","

" nerdtree
set encoding=utf-8
let g:NERDTreeDirArrows=0
let g:nerdtree_tabs_open_on_console_startup=1
nmap <leader>n :NERDTree<cr>

" open nerd tree when vim opened for directory
autocmd StdinReadPre * let s:std_in=1
autocmd VimEnter * if argc() == 1 && isdirectory(argv()[0]) && !exists("s:std_in") | exe 'NERDTree' argv()[0] | wincmd p | ene | endif



" autocompletion with github.com/Shougo/neocomplete.vim

" Disable AutoComplPop.
let g:acp_enableAtStartup = 0
" Use neocomplete.
let g:neocomplete#enable_at_startup = 1
" Use smartcase.
let g:neocomplete#enable_smart_case = 1
" Set minimum syntax keyword length.
let g:neocomplete#sources#syntax#min_keyword_length = 3

" Plugin key-mappings.
inoremap <expr><C-g>     neocomplete#undo_completion()
inoremap <expr><C-l>     neocomplete#complete_common_string()

" Recommended key-mappings.
" <CR>: close popup and save indent.
inoremap <silent> <CR> <C-r>=<SID>my_cr_function()<CR>
function! s:my_cr_function()
    return neocomplete#close_popup() . "\<CR>"
endfunction
" <TAB>: completion.
inoremap <expr><TAB>  pumvisible() ? "\<C-n>" : "\<TAB>"
" <C-h>, <BS>: close popup and delete backword char.
inoremap <expr><C-h> neocomplete#smart_close_popup()."\<C-h>"
inoremap <expr><BS> neocomplete#smart_close_popup()."\<C-h>"
inoremap <expr><C-y>  neocomplete#close_popup()
inoremap <expr><C-e>  neocomplete#cancel_popup()


" Go related mappings
au FileType go nmap <Leader>i <Plug>(go-info)
au FileType go nmap <Leader>gd <Plug>(go-doc)
au FileType go nmap <Leader>r <Plug>(go-run)
au FileType go nmap <Leader>b <Plug>(go-build)
au FileType go nmap <Leader>t <Plug>(go-test)
au FileType go nmap gd <Plug>(go-def-tab)
au FileType go nmap <leader>c <Plug>(go-coverage)


" fine tuning go-vim

" cleanup go imports on save
let g:go_fmt_command = "goimports"
let g:go_metalinter_autosave = 1

" always run metalint on save


" Airline
set laststatus=2
let g:airline#extensions#tabline#enabled = 1
let g:airline_powerline_fonts = 1
" Powerline symbols for Airline
let g:airline_powerline_fonts = 1

" tabs
set shiftwidth=2
set tabstop=2
set softtabstop=0 noexpandtab
set smarttab


" minor stuff
syntax on
set hlsearch
filetype plugin indent on
