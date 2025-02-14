vim.cmd([[
  augroup terminal_config
    autocmd!
    autocmd TermOpen,TermEnter * startinsert | set buflisted
  augroup end
]])

local set = vim.opt

set.clipboard = "unnamedplus"

set.mouse = "a"

set.expandtab = true
set.tabstop = 2
set.shiftwidth = 0

set.hidden = true

set.shell = "zsh -l"

set.undofile = true

vim.g.netrw_liststyle = 3
vim.g.netrw_banner = 0

vim.g.mapleader = " "
vim.g.maplocalleader = " "
vim.keymap.set("n", "TT", "<Cmd>terminal<CR>", { noremap = true })
vim.keymap.set("t", "<Esc>", [[(&filetype == "fzf") ? "<Esc>" : "<C-\\><C-n>"]], { noremap = true, expr = true })
vim.keymap.set("n", ";", ":", { noremap = true })
vim.keymap.set("", "<PageUp>", "", { noremap = true })
vim.keymap.set("", "<PageDown>", "", { noremap = true })
