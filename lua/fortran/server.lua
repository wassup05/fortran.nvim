local M = {}

M.start_server = function(opts)
  local lsp = require("lspconfig")
  local capabilities = vim.lsp.protocol.make_client_capabilities()

  table.insert(opts.server_opts.args, 1, opts.server_opts.path)

  lsp.fortls.setup({
    capabilities = capabilities,
    settings = opts.server_opts.settings,
    filetypes = opts.server_opts.filetypes,
    cmd = opts.server_opts.cmd,
  })
end

return M
