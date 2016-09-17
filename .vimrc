syntax on
colorscheme darkblue

execute pathogen#infect()
filetype plugin indent on


autocmd StdinReadPre * let s:std_in=1
autocmd VimEnter * if argc() == 0 && !exists("s:std_in") | NERDTree | endif
map <C-n> :NERDTreeToggle<CR>
autocmd bufenter * if (winnr("$") == 1 && exists("b:NERDTree") && b:NERDTree.isTabTree()) | q | endif

set backspace=indent,eol,start
set ruler

map Q :qa<CR>
map W :w<CR>
