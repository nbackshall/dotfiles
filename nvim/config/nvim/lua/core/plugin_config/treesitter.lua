require('nvim-treesitter.configs').setup {
  ensure_installed = { 
    "bash",
    "c_sharp",
    "dockerfile",
    "lua",
    "markdown",
    "python",
    "vim",
    "yaml",
  },
  sync_install = false,
  auto_install = true,
  highlight = {
    enable = true,
  },
}
