vim.opt.number = true
vim.opt.hlsearch = false
vim.opt.incsearch = true
vim.opt.ignorecase = true
vim.opt.smartcase = true
vim.opt.wrap = false
vim.opt.expandtab = true
vim.opt.tabstop = 4
vim.opt.softtabstop = 4
vim.opt.shiftwidth = 4
vim.opt.smartindent = true
vim.opt.scrolloff = 7
vim.opt.foldmethod = "indent"
vim.opt.foldlevelstart = 99

vim.g.mapleader = " "
vim.keymap.set("i", "<C-v>", "<C-r>+")
vim.keymap.set("i", "<C-h>", "<C-w>")  -- <C-Backspace> to delete prev word
vim.keymap.set("i", "<C-Del>", "<C-o>dw")
vim.keymap.set("x", "<Leader>p", "\"_dP")  -- Primeagen paste
