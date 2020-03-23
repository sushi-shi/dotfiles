" sane defaults 
set history=9000
set nocp
set number 		
set relativenumber
set splitbelow splitright

" 1 tab == 2 spaces
" do not use tabs, indent nicely
set autoindent
set expandtab
set shiftround
set shiftwidth=2
set smarttab
set softtabstop=0
set tabstop=2

" Switching between buffers
set hidden

" Current position always on
set ruler
set backspace=2

" Magic for regular expressions
set magic

set scrolloff=5
set nojoinspaces

" try to keep each line short
set textwidth=1160
set colorcolumn=+1

" syntax and plugins
syntax on
filetype plugin on

" browsing files
set path+=**
set wildmenu
set wildignore+=*.o,*.obj,*.hi,*.md

" maps

" bad habbits
inoremap <up> <nop>
inoremap <right> <nop>
inoremap <left> <nop>
inoremap <down> <nop>
noremap ZZ <nop>
noremap Q <nop>

" searching
set nohlsearch
set incsearch
set ignorecase

" G hurts my eyes without it
nnoremap G Gzz
inoremap <c-z> <esc>zta

" navigating current line 
noremap L g_
noremap H ^

" tags 
" go definition
nnoremap gd <c-]>
" go back
nnoremap gb :pop<cr>

" m stands for Meta :)
let mapleader = "m"

" marks
nnoremap gm m

" insert a new line 
nnoremap <leader>O O<esc>j
nnoremap <leader>o o<esc>k
nnoremap <leader>gO O<esc>
nnoremap <leader>go o<esc>

" navigating buffers
nnoremap <leader>f :bnext<cr>
nnoremap <leader>b :bprevious<cr>
nnoremap <leader>d :bdelete<cr>
nnoremap <C-h> <C-w>h
nnoremap <C-j> <C-w>j
nnoremap <C-k> <C-w>k
nnoremap <C-l> <C-w>l

inoremap <C-h> <C-w>h
inoremap <C-j> <C-w>j
inoremap <C-k> <C-w>k
inoremap <C-l> <C-w>l

" leaving vim
nnoremap <leader>q :qa<cr>

" save and put the cursor were it was before
nnoremap <leader>w mq:wa<cr>`q

" Haskell abbreviations
iabbrev iq import qualified
iabbrev hh <-
iabbrev ll ->
iabbrev kk =

" copying and pasting
noremap Y "+y
noremap P "+p
noremap D "+d
