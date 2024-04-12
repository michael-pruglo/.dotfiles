vim.opt.number = true
vim.opt.hlsearch = false
vim.opt.incsearch = true
vim.opt.ignorecase = true
vim.opt.smartcase = true
vim.opt.wrap = false
vim.opt.expandtab = true
vim.opt.tabstop = 4
vim.opt.softtabstop = 4
vim.opt.shiftwidth = 0 -- 0 = same as tabstop; used for >> <<
vim.opt.smartindent = true
vim.opt.scrolloff = 7
vim.opt.foldmethod = "expr"
vim.opt.foldexpr = "nvim_treesitter#foldexpr()"
vim.opt.foldlevelstart = 99
vim.opt.showmode = false
vim.opt.undofile = true
vim.opt.signcolumn = "yes"
vim.opt.updatetime = 250
vim.opt.inccommand = "split"
vim.opt.cursorline = true
vim.opt.splitright = true
vim.opt.splitbelow = true

vim.g.mapleader = " "
vim.keymap.set("i", "<C-v>", "<C-r>+")
vim.keymap.set("i", "<C-h>", "<C-w>")  -- <C-Backspace> to delete prev word
vim.keymap.set("i", "<C-Del>", "<C-o>dw")
vim.keymap.set("x", "<Leader>p", "\"_dP")  -- Primeagen paste
vim.keymap.set("n", "<C-Tab>", ":bnext<CR>")
vim.keymap.set("n", "<C-S-Tab>", ":bprev<CR>")

-- Diagnostic keymaps
vim.keymap.set('n', '[d', vim.diagnostic.goto_prev, { desc = 'Go to previous [D]iagnostic message' })
vim.keymap.set('n', ']d', vim.diagnostic.goto_next, { desc = 'Go to next [D]iagnostic message' })
vim.keymap.set('n', '<leader>e', vim.diagnostic.open_float, { desc = 'Show diagnostic [E]rror messages' })
vim.keymap.set('n', '<leader>q', vim.diagnostic.setloclist, { desc = 'Open diagnostic [Q]uickfix list' })
