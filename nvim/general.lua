-- Use the system clipboard as the vim clipboard
vim.o.clipboard = "unnamed"

-- Select pasted text
vim.api.nvim_set_keymap('n', 'gp', '`[v`]', { noremap = true })

-- Recognize the filetype
vim.cmd('syntax on')
vim.cmd('filetype on')
vim.cmd('filetype plugin indent on')

-- Show additional context around top and bottom of buffer
vim.o.scrolloff=10

-- Make Y to yank till end of line (yy is used to lank the curret line)
vim.api.nvim_set_keymap('n', 'Y', 'y$', { noremap = true })

-- highlight the current line
vim.o.cursorline = true

-- Remove "~" from buffer gutter
vim.opt.fillchars = { eob = " " }

-- Ignore case by default for search
vim.o.ignorecase = true
vim.o.smartcase = true

-- Tabstop fallbacks for when treesitter fails
--
---- Set tabstop to 2 spaces width
vim.opt.tabstop = 2

-- Set shiftwidth to 2 spaces width
vim.opt.shiftwidth = 2

-- On pressing tab, insert 2 spaces
vim.opt.expandtab = true

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

-- Enable signcolumn so it doesn't jitter page when apps are using it
vim.wo.signcolumn = 'yes'

-- Automatically close vim if quickfix is the only open window
vim.cmd[[
	aug QFClose
	  au!
	  au WinEnter * if winnr('$') == 1 && &buftype == "quickfix"|q|endif
	aug END
]]

-- Replicate the functionality of vim-rooter
local root_names = { '.git', 'Makefile', '.envrc' }
local root_cache = {}

local set_root = function()
  local path = vim.api.nvim_buf_get_name(0)
  if path == '' then return end
  path = vim.fs.dirname(path)
  local root = root_cache[path]
  if root == nil then
    local root_file = vim.fs.find(root_names, { path = path, upward = true })[1]
    if root_file == nil then return end
    root = vim.fs.dirname(root_file)
    root_cache[path] = root
  end
  vim.fn.chdir(root)
end

local root_augroup = vim.api.nvim_create_augroup('MyAutoRoot', {})
vim.api.nvim_create_autocmd('BufEnter', { group = root_augroup, callback = set_root })
