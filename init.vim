"" Handle Plugins
call plug#begin()

Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'

Plug 'junegunn/fzf', { 'dir': '~/.fzf', 'do': './install --all' }
Plug 'junegunn/fzf.vim'

Plug 'purescript-contrib/purescript-vim'
Plug 'gabrielelana/vim-markdown'

Plug 'pangloss/vim-javascript'
Plug 'Shougo/deoplete.nvim', { 'do': ':UpdateRemotePlugins' }
Plug 'mxw/vim-jsx'
Plug 'jparise/vim-graphql'
Plug 'neovimhaskell/haskell-vim'

Plug 'leafgarland/typescript-vim'
"Plug 'Quramy/tsuquyomi'

Plug 'idris-hackers/idris-vim'

" Git bindings
Plug 'tpope/vim-fugitive'

" Case sensitive text replace!
Plug 'tpope/vim-abolish'

Plug 'tweekmonster/braceless.vim' " text objects and more for Python and other indented code

" Auto-complete my brackets
Plug 'rstacruz/vim-closer'

Plug 'scrooloose/nerdtree', { 'on':  'NERDTreeToggle' }

Plug 'ayu-theme/ayu-vim'

Plug 'Yggdroot/indentLine'

" Show marks visually
Plug 'kshenoy/vim-signature'

" Camelcase motion
Plug 'bkad/CamelCaseMotion'

" Spell checker
Plug 'vim-scripts/ingo-library'
Plug 'inkarkat/vim-spellcheck'

call plug#end()

"" Make the typing gooder
filetype plugin indent on

autocmd BufNewFile,BufRead *.tsx,*.jsx set filetype=typescript.tsx

" show existing tab with 2 spaces width
set tabstop=4

" when indenting with '>', used 2 spaces width
set shiftwidth=4

set expandtab

" Speed up airline a little bit
let g:airline_highlighting_cache = 1

"" Visual Preferences

" Turn off spell checking in markdown, it's distracting
let g:markdown_enable_spell_checking = 0

" Show line number
:set number relativenumber

map <silent> <C-b> :FZF<CR>

" vim theme
let ayucolor="mirage"
colorscheme ayu
set termguicolors     " enable true colors support"

:augroup numbertoggle
:  autocmd!
:  autocmd BufEnter,FocusGained,InsertLeave * set relativenumber
:  autocmd BufLeave,FocusLost,InsertEnter   * set norelativenumber
:augroup END

" Enable the camelcase mappings!
call camelcasemotion#CreateMotionMappings(',')
" Takes care of inner words on camelcase
vmap ,i <Esc>l,bv,e
omap ,i :normal v,i<CR>

"" Handle Jumping between splits
nnoremap <C-J> <C-W><C-J>
nnoremap <C-K> <C-W><C-K>
nnoremap <C-L> <C-W><C-L>
nnoremap <C-H> <C-W><C-H>

"" Set up NERDTree

autocmd StdinReadPre * let s:std_in=1
autocmd VimEnter * if argc() == 0 && !exists("s:std_in") | NERDTree | endif

" Close if only Nerd tree is running
autocmd bufenter * if (winnr("$") == 1 && exists("b:NERDTree") && b:NERDTree.isTabTree()) | q | endif

" Set .prisma files to use graphql syntax highlighting
au BufRead,BufNewFile *.prisma setfiletype graphql

" Use pboard for vim clipboard
set clipboard=unnamed

" Show additional context around top and bottom of buffer (start scrolling 5
" lines before bottom
set scrolloff=5

" Map gp to select the text I just pasted
nnoremap <expr> gp '`[' . strpart(getregtype(), 0, 1) . '`]'

" Make Y yank till end of line (I use yy to yank current line anyway)
nnoremap Y y$

" Open NERDTree with Ctrl-N!
map <silent> <C-n> :NERDTreeToggle<CR>

" Use nicer NERDTree Arrows
let g:NERDTreeDirArrowExpandable = '▸'
let g:NERDTreeDirArrowCollapsible = '▾'

"" Limit spell checking to only comments
" set spell
