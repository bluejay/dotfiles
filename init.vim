call plug#begin()

" Vim user interface
Plug 'ayu-theme/ayu-vim'

" Nicer statusline
Plug 'vim-airline/vim-airline'

" Camelcase motion
Plug 'bkad/CamelCaseMotion'

" Git bindings
Plug 'tpope/vim-fugitive'

" Show marks visually
Plug 'kshenoy/vim-signature'

"" FZF with Vim
Plug 'junegunn/fzf', { 'dir': '~/.fzf', 'do': './install --all' }
Plug 'junegunn/fzf.vim'
" Note: Using the following in .zshrc
" export FZF_DEFAULT_COMMAND='ag --hidden --ignore .git -g ""'

"" NerdTree cludge -- Long term want to try to get this out of my flow
Plug 'scrooloose/nerdtree', { 'on':  'NERDTreeToggle' }

" Languages cludge
Plug 'sheerun/vim-polyglot'

call plug#end()

"" Set the vim Themes
let ayucolor="dark"
colorscheme ayu
set termguicolors

"" Normal mode mappings

" Add mappings for fzf and ag
map <silent> <C-p> :FZF<CR>
map <silent> <C-b> :FZF<CR>

" Make Y yank till end of line (I use yy to yank current line anyway)
nnoremap Y y$

" Map gp to select the text I just pasted
nnoremap <expr> gp '`[' . strpart(getregtype(), 0, 1) . '`]' 

" Enable the camelcase mappings!
call camelcasemotion#CreateMotionMappings(',')
" Takes care of inner words on camelcase
vmap ,i <Esc>l,bv,e
omap ,i :normal v,i<CR>

"" General behavior
"highlight current line
set cursorline

" show tabs with width 2
set tabstop=2
set softtabstop=2
set shiftwidth=2

" Display a mark for tab characters
set list
set listchars=tab:\|\ ,extends:›,precedes:‹,nbsp:·,trail:·

" Show additional context around top and bottom of buffer (start scrolling 5
" lines before bottom
set scrolloff=5

" Use pboard for vim clipboard
set clipboard=unnamed

" Recognize the filetype
syntax on
filetype on
filetype plugin indent on

"" Handle Jumping between splits
nnoremap <C-J> <C-W><C-J>
nnoremap <C-K> <C-W><C-K>
nnoremap <C-L> <C-W><C-L>
nnoremap <C-H> <C-W><C-H>

"" enable nerd tree toggle
map <silent> <C-g> :NERDTreeToggle<CR>

" Show relative line numbers, except current line which is absolute
augroup numbertoggle
  autocmd!
  autocmd BufEnter,FocusGained,InsertLeave * set relativenumber
  autocmd BufLeave,FocusLost,InsertEnter   * set norelativenumber
augroup END

" Show line numbers in insert mode
set number relativenumber

" Use smartcase for search and replace
set ignorecase
set smartcase

" show opening operator when closing
set showmatch

" Set 80 characters limit when writing markdown
au BufRead,BufNewFile *.md setlocal textwidth=80
au BufRead,BufNewFile *.markdown setlocal textwidth=80

"" Language Cludge: Rust

" Enable auto rustfmt -- language
let g:rustfmt_autosave = 1
