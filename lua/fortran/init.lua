local M = {}

local server = require("fortran.server")
local cmd = require("fortran.commands")
local prefix = "fortan.nvim: "

M.server = true

M.defaults = {
  server_opts = {
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
    single_file_support = true,
  },

  fpm_opts = {
    terminal = true,
    path = "fpm",
    args = {},
  },

  formatter_opts = {
    path = "fprettify",
    format_on_save = true,
    args = {},
  },
}

M.setup = function(opts)
  M.handle_opts(opts)
  M.check_requirements(M._opts)
  cmd.setup_commands(M._opts)
  cmd.setup_format_autocmd(M._opts.formatter_opts)

  if M.server then
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

  if exists(opts.server_opts.path) == 0 then
    vim.notify(prefix .. "server " .. opts.server_opts.path .. " not found", warn)
    M.server = false
  elseif exists(opts.fpm_opts.path) == 0 then
    vim.notify(prefix .. "package manager " .. opts.fpm_opts.path .. " not found", warn)
  end
end

return M
