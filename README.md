## fortran.nvim

A lua plugin for making it easy to work with [Fortran](https://fortran-lang.org/) and it's ecosystem of community maintained tools such as
- [fortls](https://github.com/fortran-lang/fortls) (Fortran Language Server)
- [fpm](https://github.com/fortran-lang/fpm) (Fortran Package Manager)
- [fprettify](https://github.com/fortran-lang/fprettify) (Fortran Code Formatter)
- [fypp](https://github.com/aradi/fypp) (Fortran Preprocessor)

### Features
- Sets up `fortls` for you without any further configuration (customizable as well)
- Integrates with `fpm` and provides a number of User Commands such as `FpmRun`, `FpmBuild` to run from within neovim instance
- Integrates with `fprettify` and provides a command `FpmFormat` to format the whole document according to your options provided
- optionally also sets up an autocmd to format the document on save
- Sets the `filetype` of `fypp` files as appropriately, enabling the use of syntax highlighting and language server on such files.

### Installation

### [lazy.nvim](https://github.com/folke/lazy.nvim)

```lua
return {
  "wassup05/fortran.nvim",
  lazy = true,
  -- load the plugin when `ft` is fortran
  ft = { "fortran" },
  opts = {
    -- all your configuration options go here
  }
}
```

### Configuration

```lua
-- default config
{
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
  },

  fpm_opts = {
    terminal = true,
    path = "fpm",
      args = {
      -- fpm args go here exactly as you would pass them to fpm
    },
  },

  formatter_opts = {
    path = "fprettify",
    format_on_save = true,
    args = {
      -- fpretiffy args go here exactly as you would pass them to fprettify
      },
  },
}
```

### TODO
- [ ] Customization of display of output `Fpm` subcommands (to a terminal, vertical splits etc)
- [ ] Adding more commands
- [ ] Handling arguments of given to the commands

There is a lot of scope for improvment, So bug reports and contributions are very much welcome
