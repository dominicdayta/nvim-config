-- set tab size to 4 spaces
vim.opt.tabstop = 4
vim.opt.shiftwidth = 4

-- convert tabs to spaces
vim.opt.expandtab = true

-- line numbers
vim.opt.number = true
vim.opt.relativenumber = true

-- Bootstrap lazy.nvim
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
  local lazyrepo = "https://github.com/folke/lazy.nvim.git"
  local out = vim.fn.system({ "git", "clone", "--filter=blob:none", "--branch=stable", lazyrepo, lazypath })
  if vim.v.shell_error ~= 0 then
    vim.api.nvim_echo({
      { "Failed to clone lazy.nvim:\n", "ErrorMsg" },
      { out, "WarningMsg" },
      { "\nPress any key to exit..." },
    }, true, {})
    vim.fn.getchar()
    os.exit(1)
  end
end
vim.opt.rtp:prepend(lazypath)

-- Remap space as leader key before loading plugins
vim.g.mapleader = " "
vim.g.maplocalleader = " "

-- Tell lazy.nvim to load everything inside the lua/plugins directory
require("lazy").setup({
  spec = {
    { import = "plugins" },
  },
})

-- Force Neovim to use OSC 52 for clipboard operations
vim.g.clipboard = {
  name = 'OSC 52',
  copy = {
    ['+'] = require('vim.ui.clipboard.osc52').copy('+'),
    ['*'] = require('vim.ui.clipboard.osc52').copy('*'),
  },
  paste = {
    ['+'] = require('vim.ui.clipboard.osc52').paste('+'),
    ['*'] = require('vim.ui.clipboard.osc52').paste('*'),
  },
}

-- Automatically sync the unnamed register with the system clipboard
-- This makes a standard 'y' act like a system copy
vim.opt.clipboard = 'unnamed'
