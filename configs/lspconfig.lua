local on_attach = require("plugins.configs.lspconfig").on_attach
local capabilities = require("plugins.configs.lspconfig").capabilities

local lspconfig = require("lspconfig")
local util = require("lspconfig/util")

local local_on_attach = (function(client, bufnr)
  on_attach(client, bufnr)

  client.server_capabilities.documentFormattingProvider = true
  client.server_capabilities.documentRangeFormattingProvider = true
  -- Set the completion shortcut + go back
  local opts = { buffer = bufnr }

  vim.keymap.set("n", "gd", function() vim.lsp.buf.definition() end, opts)
  vim.keymap.set("n", "K", function() vim.lsp.buf.hover() end, opts)
  vim.keymap.set("n", "gn", function() vim.diagnostic.goto_next() end, opts)
  vim.keymap.set("n", "gp", function() vim.diagnostic.goto_prev() end, opts)
  vim.keymap.set("n", "<leader>ca", function() vim.lsp.buf.code_action() end, opts)
  vim.keymap.set("n", "<leader>rr", function() vim.lsp.buf.references() end, opts)
  vim.keymap.set("n", "<leader>rn", function() vim.lsp.buf.rename() end, opts)
  vim.keymap.set("n", "<leader>cf", function() vim.lsp.buf.format() end, { buffer = bufnr })
  vim.keymap.set("n", "<leader>coi", function() require('jdtls').organize_imports() end, opts)
end)

lspconfig.rust_analyzer.setup({
  on_attach = local_on_attach,
  capabilities = capabilities,
  filetypes = { "rust" },
  root_dir = util.root_pattern("Cargo.toml")
})
lspconfig.lua_ls.setup({ on_attach = local_on_attach, capabilities = capabilities })
lspconfig.volar.setup({ on_attach = local_on_attach, capabilities = capabilities })
lspconfig.astro.setup({ on_attach = local_on_attach, capabilities = capabilities })
lspconfig.ltex.setup({ on_attach = local_on_attach, capabilities = capabilities })
