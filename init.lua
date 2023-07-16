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

	-- LSP Config
	use 'williamboman/mason.nvim'    
	use 'williamboman/mason-lspconfig.nvim'

	use 'neovim/nvim-lspconfig' 
	use 'simrat39/rust-tools.nvim'

	-- Completion framework:
	use 'hrsh7th/nvim-cmp' 

	-- LSP completion source:
	use 'hrsh7th/cmp-nvim-lsp'

	-- Useful completion sources:
	use 'hrsh7th/cmp-nvim-lua'
	use 'hrsh7th/cmp-nvim-lsp-signature-help'
	use 'hrsh7th/cmp-vsnip'                             
	use 'hrsh7th/cmp-path'                              
	use 'hrsh7th/cmp-buffer'                            
	use 'hrsh7th/vim-vsnip'  

	if packer_bootstrap then
		require('packer').sync()
	end
end)


-- LSP Config

-- Mason Setup
require("mason").setup()
require("mason-lspconfig").setup()

-- Rust setup
local rt = require("rust-tools")

rt.setup({
  server = {
    on_attach = function(_, bufnr)
      -- Hover actions
      vim.keymap.set("n", "<C-space>", rt.hover_actions.hover_actions, { buffer = bufnr })
      -- Code action groups
      vim.keymap.set("n", "<Leader>a", rt.code_action_group.code_action_group, { buffer = bufnr })
    end,
  },
})

-- Autoformat rust code
vim.g.rustfmt_autosave = 1

-- LSP Diagnostics Options Setup 
vim.diagnostic.config({
    virtual_text = false,
    signs = true,
    update_in_insert = true,
    underline = true,
    severity_sort = false,
    float = {
        border = 'rounded',
        source = 'always',
        header = '',
        prefix = '',
    },
})

vim.cmd([[
set signcolumn=yes
autocmd CursorHold * lua vim.diagnostic.open_float(nil, { focusable = false })
]])

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

-- Opts
vim.opt.completeopt = {'menuone', 'noselect', 'noinsert'}
vim.opt.shortmess = vim.opt.shortmess + { c = true}
vim.api.nvim_set_option('updatetime', 300) 

-- Fixed column for diagnostics to appear
-- Show autodiagnostic popup on cursor hover_range
-- Goto previous / next diagnostic warning / error 
-- Show inlay_hints more frequently 
vim.cmd([[
	autocmd CursorHold * lua vim.diagnostic.open_float(nil, { focusable = false })
]])

-- Completion Plugin Setup
local cmp = require'cmp'
cmp.setup({
  -- Enable LSP snippets
  snippet = {
    expand = function(args)
        vim.fn["vsnip#anonymous"](args.body)
    end,
  },
  mapping = {
    ['<C-p>'] = cmp.mapping.select_prev_item(),
    ['<C-n>'] = cmp.mapping.select_next_item(),
    -- Add tab support
    ['<S-Tab>'] = cmp.mapping.select_prev_item(),
    ['<Tab>'] = cmp.mapping.select_next_item(),
    ['<C-S-f>'] = cmp.mapping.scroll_docs(-4),
    ['<C-f>'] = cmp.mapping.scroll_docs(4),
    ['<C-Space>'] = cmp.mapping.complete(),
    ['<C-e>'] = cmp.mapping.close(),
    ['<CR>'] = cmp.mapping.confirm({
      behavior = cmp.ConfirmBehavior.Insert,
      select = true,
    })
  },
  -- Installed sources:
  sources = {
    { name = 'path' },                              -- file paths
    { name = 'nvim_lsp', keyword_length = 3 },      -- from language server
    { name = 'nvim_lsp_signature_help'},            -- display function signatures with current parameter emphasized
    { name = 'nvim_lua', keyword_length = 2},       -- complete neovim's Lua runtime API such vim.lsp.*
    { name = 'buffer', keyword_length = 2 },        -- source current buffer
    { name = 'vsnip', keyword_length = 2 },         -- nvim-cmp source for vim-vsnip 
    { name = 'calc'},                               -- source for math calculation
  },
  window = {
      completion = cmp.config.window.bordered(),
      documentation = cmp.config.window.bordered(),
  },
  formatting = {
      fields = {'menu', 'abbr', 'kind'},
      format = function(entry, item)
          local menu_icon ={
              nvim_lsp = 'λ',
              vsnip = '⋗',
              buffer = 'Ω',
              path = '🖫',
          }
          item.menu = menu_icon[entry.source.name]
          return item
      end,
  },
})
