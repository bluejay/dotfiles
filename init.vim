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

" Add LSP support
Plug 'neoclide/coc.nvim', {'branch': 'release'}

" Integrate haskell ormolu formatter support
Plug 'sdiehl/vim-ormolu'

" Plug 'alx741/vim-stylishask'

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

" Open splits on the right
set splitright

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

" Remap leader to space
nnoremap <SPACE> <Nop>
let mapleader=" "

"" Language Cludge: Rust

" Enable auto rustfmt -- language
let g:rustfmt_autosave = 1

" Haskell language cludge
let g:haskell_enable_quantification = 1   " to enable highlighting of `forall`
let g:haskell_enable_recursivedo = 1      " to enable highlighting of `mdo` and `rec`
let g:haskell_enable_arrowsyntax = 1      " to enable highlighting of `proc`
let g:haskell_enable_pattern_synonyms = 1 " to enable highlighting of `pattern`
let g:haskell_enable_typeroles = 1        " to enable highlighting of type roles
let g:haskell_enable_static_pointers = 1  " to enable highlighting of `static`
let g:haskell_backpack = 1                " to enable highlighting of backpack keywords

"" GoTo code navigation.
nmap <silent> gd <Plug>(coc-definition)
nmap <silent> gy <Plug>(coc-type-definition)
nmap <silent> gi <Plug>(coc-implementation)
nmap <silent> gr <Plug>(coc-references)
