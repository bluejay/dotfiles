local Plug = vim.fn['plug#']

vim.call('plug#begin')
	-- Install Vim theme
	Plug 'ayu-theme/ayu-vim'

	-- Nicer statusline
	Plug 'vim-airline/vim-airline'

	-- Camelcase motion
	Plug 'bkad/CamelCaseMotion'

	-- Git bindings
	Plug 'tpope/vim-fugitive'

	-- Show marks visually
	Plug 'kshenoy/vim-signature'

	-- Intelligently set rootdir when opening files
	Plug 'airblade/vim-rooter'

	-- Languages cludge
	Plug 'sheerun/vim-polyglot'

	-- NerdTree cludge
	Plug('scrooloose/nerdtree', {on = 'NERDTreeToggle'})

	-- FZF with vim
	Plug('junegunn/fzf.vim')
	Plug('junegunn/fzf', {dir='~/.fzf'})

vim.call('plug#end')

-- Use the system clipboard as the vim clipboard
vim.o.clipboard = "unnamed"

-- Select pasted text
vim.api.nvim_set_keymap('n', 'gp', '`[v`]', { noremap = true })

-- Recognize the filetype
vim.cmd('syntax on')
vim.cmd('filetype on')
vim.cmd('filetype plugin indent on')

-- Show additional context around top and bottom of buffer
vim.o.scrolloff=5

-- Set the vim theme
vim.g.ayucolor = "dark"
vim.opt.termguicolors = true
vim.cmd('colorscheme ayu')

-- Make Y to yank till end of line (yy is used to lank the curret line)
vim.api.nvim_set_keymap('n', 'Y', 'y$', { noremap = true })

-- Enable camelcase mappings
vim.call('camelcasemotion#CreateMotionMappings', ',')
-- use ,i to map between inner words in camelcase
vim.api.nvim_set_keymap('v', ',i', '<Esc>l,bv,e', {})
vim.api.nvim_set_keymap('o', ',i', ':normal v,i<CR>', {})

-- highlight the current line
vim.o.cursorline = true

-- Handle jumping between splits
vim.api.nvim_set_keymap('n', '<C-J>', '<C-W><C-J>', { silent = true })
vim.api.nvim_set_keymap('n', '<C-K>', '<C-W><C-K>', { silent = true })
vim.api.nvim_set_keymap('n', '<C-L>', '<C-W><C-L>', { silent = true })
vim.api.nvim_set_keymap('n', '<C-H>', '<C-W><C-H>', { silent = true })

-- Ignore case by default for search
vim.o.ignorecase = true
vim.o.smartcase = true

-- Show the current line number and other lines as relative
vim.cmd([[
augroup numbertoggle
  autocmd!
  autocmd BufEnter,FocusGained,InsertLeave * set relativenumber
  autocmd BufLeave,FocusLost,InsertEnter   * set norelativenumber
augroup END
]])

-- Show line numbers as relative while in insert mode
vim.wo.number = true
vim.wo.relativenumber = true

-- Show tabs
vim.wo.list = true
vim.opt.listchars = { 
	tab = '|\\ ',
	nbsp = '·',
	trail = '·',
	extends = '›',
	precedes = '‹',
}

-- Enable signcolumn so it doesn't jitter page when apps are using it
vim.wo.signcolumn = 'yes'

-- Open NERDTree with Ctrl-g
vim.api.nvim_set_keymap('n', '<C-g>', ':NERDTreeToggle<CR>', { silent = true })

-- Show hidden files in NERDTree
vim.g.NERDTreeShowHidden = 1


--remap <Ctrl-P> to fzf
vim.api.nvim_set_keymap('n', '<C-p>', ':FZF<CR>', { silent = true })
-- use gitignore in fzf
vim.env.FZF_DEFAULT_COMMAND = 'ag --hidden --ignore .git -f -g ""'
