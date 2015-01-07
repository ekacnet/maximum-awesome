" vim: set ts=4 sw=4 ft=vim expandtab :
" If you're about to edit this file, please read the following.
" You most probably want to add your custom settings or undo the following settings in
" $HOME/.vimrc.local instead of editing this file, this will ease the sync
" with the upstream git repository.
"
" You should only edit this file when you want to share some great settings
" with others (aka upstream your changes)
"
" don't bother with vi compatibility
set nocompatible

" enable syntax highlighting
syntax enable

" configure Vundle
filetype on " without this vim emits a zero exit status, later, because of :ft off
filetype off

" Add $HOME/bundle/vundle to the runtime path of Vim
set rtp+=~/.vim/bundle/Vundle.vim
" Try to call vundle, should be nicer with older version of vim that didn't
" support new stuff
try
    call vundle#begin()
catch
endtry

" install Vundle bundles
if filereadable(expand("~/.vimrc.bundles"))
  source ~/.vimrc.bundles
  if filereadable(expand("~/.vimrc.bundles.local"))
    source ~/.vimrc.bundles.local
  endif
endif

call vundle#end()

" ensure ftdetect et al work by including this after the Vundle stuff
filetype plugin indent on

set autoindent
set autoread                                                 " reload files when changed on disk, i.e. via `git checkout`
set copyindent                                               " copy the previous indentation on
                                                             " autoindenting
set backspace=2                                              " Fix broken backspace in some setups
set backupcopy=yes                                           " see :help crontab
set clipboard=unnamed                                        " yank and paste with the system clipboard
set directory-=.                                             " don't store swapfiles in the current directory
set encoding=utf-8
set expandtab                                                " expand tabs to spaces
set ignorecase                                               " case-insensitive search
set incsearch                                                " search as you type
set laststatus=2                                             " always show statusline
set list                                                     " show trailing whitespace
set listchars=tab:▸\ ,trail:▫
set number                                                   " show line numbers
set ruler                                                    " show where you are
set scrolloff=3                                              " show context above/below cursorline
set shiftwidth=2                                             " normal mode indentation commands use 2 spaces
set showcmd
set smartcase                                                " case-sensitive search if any caps
set softtabstop=2                                            " insert mode tab and backspace use 2 spaces
set tabstop=8                                                " actual tabs occupy 8 characters
set wildignore=log/**,node_modules/**,target/**,tmp/**,*.rbc
set wildmenu                                                 " show a navigable menu for tab completion
set wildmode=longest,list,full
set shiftround                                               " use multiple of shiftwidth when
                                                             " indenting with '<' and '>'
set showmatch                                                " set show matching parenthesis
set smartcase                                                " ignore case if search pattern is
                                                             " all lowercase, case-sensitive otherwise
set smarttab                                                 " insert tabs on the start of a line
                                                             " according to shiftwidth, not tabstop
set incsearch                                                " show search matches as you type

" Enable basic mouse behavior such as resizing buffers.
set mouse=a
if exists('$TMUX')  " Support resizing in tmux
  set ttymouse=xterm2
endif
set nobackup
set pastetoggle=<F2>                                         " Allow to switch in paste mode


" change the mapleader from \ to ,
let mapleader = ','

" keyboard shortcuts
noremap <C-h> <C-w>h
noremap <C-j> <C-w>j
noremap <C-k> <C-w>k
noremap <C-l> <C-w>l

noremap <leader>l :Align
nnoremap <leader>a :Ag<space>
nnoremap <leader>b :CtrlPBuffer<CR>
nnoremap <leader>d :NERDTreeToggle<CR>
nnoremap <leader>f :NERDTreeFind<CR>
nnoremap <leader>t :CtrlP<CR>
nnoremap <leader>T :CtrlPClearCache<CR>:CtrlP<CR>
nnoremap <leader>] :TagbarToggle<CR>
nnoremap <leader><space> :call whitespace#strip_trailing()<CR>
nnoremap <leader>g :GitGutterToggle<CR>
noremap <silent> <leader>V :source ~/.vimrc<CR>:filetype detect<CR>:exe ":echo 'vimrc reloaded'"<CR>

"allow to switch back and forth to wrap/nowrap mode
:nmap \w :setlocal wrap!<CR>:setlocal wrap?<CR>

" Allow to save files that are RO by doing a sudo root
cmap w!! w !sudo tee % >/dev/null

"In insert mode C-F points to C-X C-O, for omnifunc
inoremap <C-F> <C-X><C-O>

" in case you forgot to sudo
cnoremap w!! %!sudo tee > /dev/null %
":e# or :b# goes to the last edited buffer, we remap it to a more convinient shortcut
nmap <C-e> :e#<CR>
" Quickly edit/reload the vimrc file
nmap <silent> <leader>ev :e $MYVIMRC<CR>
nmap <silent> <leader>sv :so $MYVIMRC<CR>

"allow to unhilight search
:nmap \q :nohlsearch<CR>


" plugin settings
let g:ctrlp_match_window = 'order:ttb,max:20'
let g:NERDSpaceDelims=1
let g:gitgutter_enabled = 0

" Use The Silver Searcher https://github.com/ggreer/the_silver_searcher
if executable('ag')
  " Use Ag over Grep
  set grepprg=ag\ --nogroup\ --nocolor

  " Use ag in CtrlP for listing files. Lightning fast and respects .gitignore
  let g:ctrlp_user_command = 'ag %s -l --nocolor -g ""'
endif

if has("autocmd")
  " expandtab for python
  autocmd filetype python set expandtab

  " if the mark " is set then go to this mark g'" but we need to escape it
  " It's basically to allow to go back to the last position in the file when
  " the file has been read
  autocmd BufReadPost *
    \ if line("'\"") > 0 && line("'\"") <= line("$") |
    \   exe "normal g`\"" |
    \ endif
  " fdoc is yaml
  autocmd BufRead,BufNewFile *.fdoc set filetype=yaml
  " md is markdown
  autocmd BufRead,BufNewFile *.md set filetype=markdown
  autocmd BufRead,BufNewFile *.md set spell

  " extra rails.vim help
  autocmd User Rails silent! Rnavcommand decorator      app/decorators            -glob=**/* -suffix=_decorator.rb
  autocmd User Rails silent! Rnavcommand observer       app/observers             -glob=**/* -suffix=_observer.rb
  autocmd User Rails silent! Rnavcommand feature        features                  -glob=**/* -suffix=.feature
  autocmd User Rails silent! Rnavcommand job            app/jobs                  -glob=**/* -suffix=_job.rb
  autocmd User Rails silent! Rnavcommand mediator       app/mediators             -glob=**/* -suffix=_mediator.rb
  autocmd User Rails silent! Rnavcommand stepdefinition features/step_definitions -glob=**/* -suffix=_steps.rb

  " automatically rebalance windows on vim resize
  autocmd VimResized * :wincmd =

  "match everything more the 80c long to the errormsg buffer
  autocmd BufWinEnter !*.pdf,!git-rebase-todo match ErrorMsg /\%>80v.\+/

  " Allow pdf to be opened in Vim
  autocmd BufReadPre *.pdf set ro nowrap
  autocmd BufReadPre *.pdf set noruler
  autocmd BufRead *.pdf silent %!pdftotext "%" -nopgbrk -layout -q -eol unix -
  autocmd BufReadPost *.pdf exec "%s/[^[:alnum:][:punct:][:space:]]//g"

  "No more than 80c long red thing for pdf
  if exists('+colorcolumn')
      autocmd BufReadPre *.pdf set colorcolumn=0
  endif

  " Wireshark's conformance files
  autocmd BufReadPost *.cnf set syntax=c
end

" Fix Cursor in TMUX
if exists('$TMUX')
  let &t_SI = "\<Esc>Ptmux;\<Esc>\<Esc>]50;CursorShape=1\x7\<Esc>\\"
  let &t_EI = "\<Esc>Ptmux;\<Esc>\<Esc>]50;CursorShape=0\x7\<Esc>\\"
else
  let &t_SI = "\<Esc>]50;CursorShape=1\x7"
  let &t_EI = "\<Esc>]50;CursorShape=0\x7"
endif

" Don't copy the contents of an overwritten selection.
vnoremap p "_dP

" Go crazy!
if filereadable(expand("~/.vimrc.local"))
  " In your .vimrc.local, you might like:
  "
  " set autowrite
  " set nocursorline
  " set nowritebackup
  " set whichwrap+=<,>,h,l,[,] " Wrap arrow keys between lines
  "
  " autocmd! bufwritepost .vimrc source ~/.vimrc
  " noremap! jj <ESC>
  source ~/.vimrc.local
endif
