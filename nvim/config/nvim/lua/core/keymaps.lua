vim.g.mapleader = ','
vim.g.maplocalleader = ','

vim.opt.backspace = '2'
vim.opt.showcmd = true
vim.opt.laststatus = 2
vim.opt.autowrite = true
vim.opt.cursorline = true
vim.opt.cursorcolumn = true
vim.opt.autoread = true

vim.opt.tabstop = 2
vim.opt.shiftwidth = 2
vim.opt.shiftround = true
vim.opt.expandtab = true

vim.opt.number = true

vim.keymap.set('n', '<leader>h', ':nohlsearch<CR>')
vim.keymap.set({ 'n', 'v' }, '<C-c>', '"*y')

-- Set key to match delimiter from '%' to 'm'
-- This is useful for matching brackets, quotes, etc.
vim.keymap.set('n', 'm', '%')
