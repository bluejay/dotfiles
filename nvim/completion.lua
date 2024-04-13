-- Cmp does code completion
local cmp = require("cmp")

-- Cmp requires a snippet plugin for some reason
local luasnip = require("luasnip")

local openComplete = cmp.mapping(function(fallback)
  if cmp.visible() then
    cmp.confirm({
      behavior = cmp.ConfirmBehavior.Insert,
      select = true,
    })
  else
    cmp.complete()
  end
end)

cmp.setup({
  -- cmp requires a snippet library
  snippet = {
    expand = function(args)
      require('luasnip').lsp_expand(args.body)
    end,
  },

  mapping = {
    ["<Esc>"]   = cmp.mapping.abort(),
    ["<CR>"]    = cmp.mapping.confirm({
                    behavior = cmp.ConfirmBehavior.Insert,
                    select = true,
                  }),
    ["<C-Space>"]    = openComplete,
    ["<Tab>"]   = cmp.mapping.select_next_item(),
    ["<S-Tab>"] = cmp.mapping.select_prev_item(),
    ["<Down>"]  = cmp.mapping.select_next_item(),
    ["<Up>"]    = cmp.mapping.select_prev_item(),
  },

  sources = cmp.config.sources({
      { name = 'nvim_lsp', keyword_length = 3 },
      { name = 'luasnip' },
      { name = 'nvim_lsp_signature_help'},
    })
})
