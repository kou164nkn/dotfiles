set number
set title
set ambiwidth=double
set tabstop=2
set expandtab
set shiftwidth=2
set softtabstop=0
set smartindent
set whichwrap=b,s,[,],<,>
set backspace=indent,eol,start
syntax on
colorscheme desert
inoremap <silent> jj <ESC>

if has("autocmd")
  filetype plugin on
  filetype indent on

  autocmd FileType go setlocal shiftwidth=8 tabstop=8 softtabstop=8 noet
endif
