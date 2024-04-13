local lspconfig = require('lspconfig')

local capabilities = require('cmp_nvim_lsp').default_capabilities()

-- Language server autocomplete enable
lspconfig.rust_analyzer.setup({
  capabilities = capabilities
})

lspconfig.nil_ls.setup({
  capabilities = capabilities
})

-- Global mappings.
-- See `:help vim.diagnostic.*` for documentation on any of the below functions
vim.keymap.set('n', '<space>e', vim.diagnostic.setloclist)
vim.keymap.set('n', '<space>]', vim.diagnostic.goto_prev)
vim.keymap.set('n', '<space>[', vim.diagnostic.goto_next)

-- Use LspAttach autocommand to only map the following keys
-- after the language server attaches to the current buffer
vim.api.nvim_create_autocmd('LspAttach', {
  group = vim.api.nvim_create_augroup('UserLspConfig', {}),
  callback = function(ev)
    -- Buffer local mappings.
    -- See `:help vim.lsp.*` for documentation on any of the below functions
    local opts = { buffer = ev.buf }
    vim.keymap.set('n', 'gD', vim.lsp.buf.declaration, opts)
    vim.keymap.set('n', 'gd', vim.lsp.buf.definition, opts)
    vim.keymap.set('n', 'gr', vim.lsp.buf.references, opts)

    vim.keymap.set({ 'n', 'v' }, '<space>ca', vim.lsp.buf.code_action, opts)
    vim.keymap.set('n', '<space>g',  vim.lsp.buf.hover, opts)
    vim.keymap.set('n', '<space>t',  vim.lsp.buf.type_definition, opts)
    vim.keymap.set('n', '<space>n',  vim.lsp.buf.document_highlight, opts)
    vim.keymap.set('n', '<space>rn', vim.lsp.buf.rename, opts)
    vim.keymap.set('n', '<space>f', function()
      vim.lsp.buf.format { async = true }
    end, opts)
  end,
})
