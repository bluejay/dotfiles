-- ensure the packer plugin manager is installed
local ensure_packer = function()
  local fn = vim.fn
  local install_path = fn.stdpath("data") .. "/site/pack/packer/start/packer.nvim"
  if fn.empty(fn.glob(install_path)) > 0 then
    fn.system({ "git", "clone", "--depth", "1", "https://github.com/wbthomason/packer.nvim", install_path })
    vim.cmd([[packadd packer.nvim]])
    return true
  end
  return false
end

local packer_bootstrap = ensure_packer()

require("packer").startup(function(use)
	use("wbthomason/packer.nvim")

	-- Install Vim theme
	use({
		'ayu-theme/ayu-vim',
		config = function()
			vim.g.ayucolor = "dark"
			vim.opt.termguicolors = true
			vim.cmd('colorscheme ayu')
		end
	})

	-- Nicer statusline
	use('vim-airline/vim-airline')

	-- Camelcase motion
	use({
		'bkad/CamelCaseMotion',
		config = function()
			vim.call('camelcasemotion#CreateMotionMappings', ',')
			-- use ,i to map between inner words in camelcase
			vim.api.nvim_set_keymap('v', ',i', '<Esc>l,bv,e', {})
			vim.api.nvim_set_keymap('o', ',i', ':normal v,i<CR>', {})
		end
	})

	-- Git bindings
	use('tpope/vim-fugitive')

	-- Show marks visually
	use('kshenoy/vim-signature')

	-- Intelligently set rootdir when opening files
	use('airblade/vim-rooter')

	-- Languages cludge
	use('sheerun/vim-polyglot')

	-- NerdTree cludge
	use({
		'scrooloose/nerdtree',
		config = function()
			-- Show hidden files in NERDTree
			vim.g.NERDTreeShowHidden = 1
			-- Open NERDTree with Ctrl-g
			vim.api.nvim_set_keymap('n', '<C-g>', ':NERDTreeToggle<CR>', { silent = true })
		end
	})

	use {
    'junegunn/fzf.vim',
    requires = { 'junegunn/fzf', run = ':call fzf#install()' },
		config = function()
			--remap <Ctrl-P> to fzf
			vim.api.nvim_set_keymap('n', '<C-p>', ':FZF<CR>', { silent = true })
			-- use gitignore in fzf
			vim.env.FZF_DEFAULT_COMMAND = 'ag --hidden --ignore .git -f -g ""'
		end
	}

	if packer_bootstrap then
		require('packer').sync()
	end
end)

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

-- Make Y to yank till end of line (yy is used to lank the curret line)
vim.api.nvim_set_keymap('n', 'Y', 'y$', { noremap = true })

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
