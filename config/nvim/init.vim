" Colors & Themes
" au ColorScheme farout  hi Comment           ctermfg=242 guifg=#6b7089
" au ColorScheme nord    hi SignatureMarkText ctermfg =1 ctermbg=234
" au ColorScheme iceberg hi SignatureMarkText ctermfg =1 ctermbg=234

" Default settings for using CoC
source ~/.config/nvim/coc.vim

""" SANE DEFAULTS
set encoding=utf-8
syntax on
set nowrap
set noemoji
set history=9000
set number relativenumber
set splitbelow splitright
set nojoinspaces
set backspace=indent,eol,start
set textwidth=0
set scrolloff=8
set hidden
set formatoptions+=j
filetype plugin on
set linebreak
set foldlevel=2


""" REMAPS

"" MOVEMENT
" Move intuitively through wrapped lines
nnoremap j gj
nnoremap k gk

" Moves for editing from the beginning and until the end of the line
noremap L g_
noremap H ^

" Escaping from the terminal mode.
" Not the best solution for using Ranger.
tnoremap <Esc> <C-\><C-n>

" Be always at the center when navigating
nnoremap zo za
nnoremap n nzz
nnoremap G Gzz

" Navigating open buffers
nnoremap <C-h> <C-w>h
nnoremap <C-j> <C-w>j
nnoremap <C-k> <C-w>k
nnoremap <C-l> <C-w>l
nnoremap <C-p> <C-w>p

" Opening buffers
nnoremap <space><space> :vert sb<CR>


"" SEARCH

" Fuzzy-navigation
nnoremap sg :GFiles<CR>
nnoremap sf :Files<CR>
nnoremap sb :Buffers<CR>
nnoremap sc :Colors<CR>
nnoremap sh :History:<CR>
nnoremap sw yaw:Rg <C-R>"<CR>


"" LEADER

" Not remapped marks are still usable.
let mapleader = "m"


"" OTHER REMAPS

" re-undo
nnoremap U <C-r>
nnoremap Q :q<CR>

" Copying and pasting
noremap <space> "+

""" SETTING

" Do not highlight search results,
" because it is annoying for navigation.
set nohlsearch
set incsearch
set ignorecase
set nowrapscan


" Refresh syntax highlighting on each keystroke.
" Haskell andd CPP syntax breaks otherwise.
" set noshowmode
" au Syntax * syntax sync fromstart



" 1 tab == 2 spaces
" Do not use tabs, indent nicely.
" TODO: Mostly used for haskell, move to specific ftplugin
set autoindent expandtab
set shiftround
set shiftwidth=2
set smarttab
set softtabstop=0
set tabstop=2







""" PLUGINS

" EasyAlign
nmap ga <Plug>(EasyAlign)

" Show bufferline
let g:airline_section_x = ''
let g:airline_section_y = ''
let g:bufferline_echo = 0
let g:airline_theme='minimalist'

" IndentLine
" Disable for now
" let g:indentLine_leadingSpaceChar = '·'
" let g:indentLine_leadingSpaceEnabled = 1

" Colors for solarized theme
let g:solarized_termcolors=256

" Mark signatures
let g:SignatureIncludeMarks = 'abcdefghijklmnoprstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ'

" Easier navigation with f/t
let g:qs_highlight_on_keys = ['f', 'F', 't', 'T']
highlight QuickScopePrimary ctermfg=3 cterm=underline
highlight QuickScopeSecondary ctermfg=1 cterm=underline

" Ranger
" Disable netrw
let loaded_netrwPlugin = 1
let g:ranger_replace_netrw = 1


" Moving lines
let g:move_map_keys = 0
nnoremap <A-h> :SidewaysLeft<cr>
nnoremap <A-l> :SidewaysRight<cr>

" Running rustfmt on save
" TODO RUST SPECIFIC MOVE
let g:rustfmt_autosave = 1

nnoremap <leader>dr :GdbRun<CR>

nnoremap <leader>da :GdbBreakpointToggle<CR>
nnoremap <leader>dk :GdbBreakpointClearAll<CR>
nnoremap <leader>du :GdbUntil<CR>
nnoremap <leader>dc :GdbContinue<CR>
nnoremap <leader>dn :GdbNext<CR>
nnoremap <leader>ds :GdbStep<CR>
nnoremap <leader>df :GdbFinish<CR>

nnoremap <leader>dp :GdbFrameUp<CR>
nnoremap <leader>dw :GdbFrameDown<CR>

command! -nargs=0 Prettier :CocCommand prettier.formatFile


set background=dark
colorscheme gruvbox
" set termguicolors
