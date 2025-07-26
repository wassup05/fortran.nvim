local M = {}
local api = vim.api
local create_uc = vim.api.nvim_create_user_command

local function create_cmd_string(path, subcommand)
  local subcommand_opts_string = ""

  for _, v in ipairs(M._opts.fpm_opts.args) do
    subcommand_opts_string = subcommand_opts_string .. " " .. v .. " "
  end

  if subcommand == "help" or subcommand == "clean" or subcommand == "new" then
    subcommand_opts_string = ""
  end

  if subcommand == "format" then
    local formatter_path = M._opts.formatter_opts.path
    subcommand_opts_string = formatter_path .. " %"
    for _, v in ipairs(M._opts.formatter_opts.args) do
      subcommand_opts_string = subcommand_opts_string .. " " .. v .. " "
    end
  end

  if M._opts.fpm_opts.terminal and subcommand ~= "format" then
    return path .. " " .. subcommand .. subcommand_opts_string
  end

  return "!" .. subcommand_opts_string
end

local function create_cmd(name, opts)
  -- capitalize first letter
  local cmd_name = string.upper(string.sub(name, 1, 1)) .. string.sub(name, 2)
  create_uc("Fpm" .. cmd_name, function(info)
    local cmd_string = create_cmd_string(M._opts.fpm_opts.path, name) .. " " .. info.args
    if M._opts.fpm_opts.terminal and name ~= "format" then
      api.nvim_command("terminal ".. cmd_string)
      return
    end
    local output = vim.fn.execute(cmd_string, "silent!")
    if name ~= "format" then
      print(output)
    end
  end, opts)
end

M.setup_format_autocmd = function(opts)
  local args = {
    opts.path,
    "placeholder",
  }

  vim.list_extend(args, opts.args)

  vim.api.nvim_create_autocmd({ "BufWritePre" }, {
    pattern = { "*.f90", "*.f95" },
    group = vim.api.nvim_create_augroup("fortran-save-format", { clear = true }),

    callback = function(event)
      local bufid = event.buf
      local bufname = vim.api.nvim_buf_get_name(bufid)
      args[2] = bufname
      vim.system(args, {
        -- timeout = 20,
        text = true,
      }, function(out)
        if out.code ~= 0 then
          print("Formatting Failed", out.stdout)
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
  M._opts = opts

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
