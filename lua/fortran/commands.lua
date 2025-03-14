local M = {}
local create_uc = vim.api.nvim_create_user_command

local function create_cmd_string(path, subcommand)
  local subcommand_opts_string = ""

  for _, v in ipairs(M._fpm_args) do
    subcommand_opts_string = subcommand_opts_string .. " " .. v .. " "
  end

  if subcommand == "help" or subcommand == "clean" or subcommand == "new" then
    subcommand_opts_string = ""
  end

  if subcommand == "format" then
    path = M._formatter_name
    subcommand = "%"
    for _, v in ipairs(M._format_args) do
      subcommand_opts_string = subcommand_opts_string .. " " .. v .. " "
    end
  end

  return "!" .. path .. " " .. subcommand .. subcommand_opts_string
end

local function create_cmd(name, opts)
  -- capitalize first letter
  local cmd_name = string.upper(string.sub(name, 1, 1)) .. string.sub(name, 2)
  create_uc("Fpm" .. cmd_name, function(info)
    local cmd_string = create_cmd_string(M._fpm_name, name) .. " " .. info.args
    local output = vim.fn.execute(cmd_string, "silent!")
    if name ~= "format" then
      print(output)
    end
  end, opts)
end

M._setup_args = function(opts)
  M._fpm_args = opts.fpm_opts.args
  M._fpm_name = opts.fpm_opts.path
  M._format_args = opts.formatter_opts.args
  M._formatter_name = opts.formatter_opts.path
end

M.setup_format_autocmd = function(opts)
  if not opts.format_on_save then
    return
  end

  local args = {
    opts.path,
    "placeholder",
  }

  for i, v in ipairs(opts.args) do
    args[i + 2] = v
  end

  vim.api.nvim_create_autocmd({ "BufWritePre" }, {
    pattern = { "*.f90", "*.f95" },
    group = vim.api.nvim_create_augroup("fortran-save", { clear = true }),

    callback = function(event)
      local bufid = event.buf
      local bufname = vim.api.nvim_buf_get_name(bufid)
      args[2] = bufname
      vim.system(args, {
        -- timeout = 20,
        text = true,
      }, function(out)
        if out.code ~= 0 then
          print("formatting failed", out.stdout)
        else
          vim.schedule(function()
            vim.cmd("e")
          end)
        end
      end)
    end,
  })
end

M.setup_commands = function(opts)
  M._setup_args(opts)

  create_cmd("run", { nargs = "*" })
  create_cmd("build", { nargs = "*" })
  create_cmd("test", { nargs = "*" })
  create_cmd("help", { nargs = "*" })
  -- clean prompts the user, need to handle that
  -- create_cmd("clean", { nargs = "*" })
  create_cmd("new", { nargs = "*" })
  create_cmd("format", { nargs = "*" })
end

return M
