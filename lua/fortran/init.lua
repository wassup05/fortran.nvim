local M = {}

local server = require("fortran.server")
local cmd = require("fortran.commands")
local prefix = "fortan.nvim: "

M.defaults = {
  server_opts = {
    enabled = true,
    path = "fortls",
    args = {
      "--notify_init",
      "--lowercase_intrinsics",
      "--hover_signature",
      "--hover_language=fortran",
      "--use_signature_help",
      "--enable_code_actions",
    },
    filetypes = { "fortran" },
    settings = {},
  },

  fpm_opts = {
    enabled = true,
    path = "fpm",
    args = {},
    terminal = true,
  },

  formatter_opts = {
    enabled = true,
    path = "fprettify",
    format_on_save = true,
    args = {},
  },
}

M.setup = function(opts)
  M.handle_opts(opts)
  M.check_requirements(M._opts)
  cmd.setup_commands(M._opts)

  if M._opts.formatter_opts.format_on_save then
    cmd.setup_format_autocmd(M._opts.formatter_opts)
  end

  if M._opts.server_opts.enabled then
    server.start_server(M._opts)
  end
end

M.handle_opts = function(opts)
  M.user_opts = opts
  M._opts = vim.tbl_deep_extend("force", M.defaults, opts)
end

M.check_requirements = function(opts)
  local exists = vim.fn.executable
  local warn = vim.log.levels.WARN

  if opts.server_opts.enabled and (exists(opts.server_opts.path) == 0) then
    vim.notify(prefix .. "Server " .. opts.server_opts.path .. " not found", warn)
    opts.server_opts.enabled = false
  end

  if opts.fpm_opts.enabled and (exists(opts.fpm_opts.path) == 0) then
    vim.notify(prefix .. "Package Manager " .. opts.fpm_opts.path .. " not found", warn)
    opts.fpm_opts.enabled = false
  end

  if opts.formatter_opts.enabled and (exists(opts.formatter_opts.path) == 0) then
    vim.notify(prefix .. "Formatter " .. opts.fpm_opts.path .. " not found", warn)
    opts.formatter_opts.enabled = false
  end
end

return M
