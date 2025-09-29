local M = {}

M.start_server = function(opts)
  local capabilities = vim.lsp.protocol.make_client_capabilities()

  table.insert(opts.server_opts.args, 1, opts.server_opts.path)

  vim.lsp.config('fortls', {
    capabilities = capabilities,
    settings = opts.server_opts.settings,
    filetypes = opts.server_opts.filetypes,
    cmd = opts.server_opts.cmd,
  })
  vim.lsp.enable('fortls')
end

return M
