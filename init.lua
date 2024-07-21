vim.cmd [[packadd packer.nvim]]

require('packer').startup({
  function(use)
    use 'wbthomason/packer.nvim'
    use {
      'jghauser/mkdir.nvim'
    }
    use 'github/copilot.vim'
    use {
      'neoclide/coc.nvim',
      branch = 'release',
      config = function()
        vim.g.coc_global_extensions = {
          'coc-rust-analyzer',
          'coc-toml',
          'coc-json',
          'coc-tsserver',
          'coc-prettier',
          'coc-biome',
          'coc-highlight',
          'coc-lua',
          'coc-stylua',
          'coc-java',
        }
        local function check_back_space()
          local col = vim.fn.col('.') - 1
          return col == 0 or vim.fn.getline('.'):sub(col, col):match('%s') ~= nil
        end
        local opts = { silent = true, noremap = true, expr = true, replace_keycodes = false }
        vim.keymap.set("i", "<Tab>",
          function()
            if vim.fn['coc#pum#visible']() == 1 then
              return vim.fn['coc#pum#next'](1)
            end
            if check_back_space() then
              return vim.fn['coc#refresh']()
            end
            return "<Tab>"
          end
          , opts)
        vim.keymap.set("i", "<CR>", function()
          if vim.fn['coc#pum#visible']() == 1 then
            return vim.fn['coc#pum#confirm']();
          end
          return "\r"
        end, opts)
        vim.g.mapleader = " "
        vim.keymap.set("n", "<leader>rn", "<Plug>(coc-rename)", { silent = true })
        vim.keymap.set("n", "<leader>ac", "<Plug>(coc-codeaction-cursor)", { silent = true })
        vim.keymap.set("n", "<leader>d", "<Plug>(coc-definition)", { silent = true })
      end
    }
    use {
      'nvim-treesitter/nvim-treesitter',
      run = function()
        local ts_update = require('nvim-treesitter.install').update({ with_sync = true })
        ts_update()
      end,
      config = function()
        require('nvim-treesitter.configs').setup({
          ensure_installed = {
            "lua",
            "rust",
            "diff",
            "gitcommit",
            "git_rebase",
            "json",
            "toml",
            "yaml",
            "typescript",
            "prisma",
          },
          auto_install = true,
          highlight = {
            enable = true,
          },
          indent = {
            enable = true
          }
        })
      end
    }
    use {
      'junegunn/fzf',
      run = function() vim.fn['fzf#install']() end
    }
    use {
      'junegunn/fzf.vim',
      requires = { 'junegunn/fzf' },
      config = function()
        vim.g.fzf_layout = {
          window = { width = 0.9, height = 0.9 }
        }
        local opts = { noremap = true, silent = true }
        vim.keymap.set('n', 'e', ':GFiles --cached --others --exclude-standard<CR>', opts)
        vim.keymap.set('n', '-', ':Buffers<CR>', opts)
        vim.keymap.set('n', '?', ':Lines!<CR>', opts)
      end
    }
    use {
      'lambdalisue/suda.vim',
      config = function()
        vim.g.suda_smart_edit = 1
      end
    }
    use { 'navarasu/onedark.nvim',
      config = function()
        vim.cmd [[syntax on]]
        vim.opt.background = 'light'
        require('onedark').setup({
          style = 'light'
        })
        require('onedark').load()
      end
    }
    use {
      'romgrk/barbar.nvim',
      config = function()
        require('barbar').setup({
          icons = {
            buffer_index = true,
            button = "x",
            filetype = {
              enabled = false
            },
          }
        })
        local opts = { noremap = true, silent = true }
        vim.keymap.set('n', 'qq', '<Cmd>BufferClose<CR>', opts)
        vim.keymap.set('n', '<Tab>', '<Cmd>BufferNext<CR>', opts)
        vim.keymap.set('n', '<S-Tab>', '<Cmd>BufferPrevious<CR>', opts)
        vim.keymap.set('n', '1', '<Cmd>BufferGoto 1<CR>', opts)
        vim.keymap.set('n', '2', '<Cmd>BufferGoto 2<CR>', opts)
        vim.keymap.set('n', '3', '<Cmd>BufferGoto 3<CR>', opts)
        vim.keymap.set('n', '4', '<Cmd>BufferGoto 4<CR>', opts)
        vim.keymap.set('n', '5', '<Cmd>BufferGoto 5<CR>', opts)
        vim.keymap.set('n', '6', '<Cmd>BufferGoto 6<CR>', opts)
        vim.keymap.set('n', '7', '<Cmd>BufferGoto 7<CR>', opts)
        vim.keymap.set('n', '8', '<Cmd>BufferGoto 8<CR>', opts)
        vim.keymap.set('n', '9', '<Cmd>BufferGoto 9<CR>', opts)
        vim.keymap.set('n', '0', '<Cmd>BufferLast<CR>', opts)
      end
    }
  end,
  config = {
    display = {
      open_fn = function()
        return require('packer.util').float({ border = 'single' })
      end
    }
  }
})

vim.cmd([[
  augroup packer_user_config
    autocmd!
    autocmd BufWritePost init.lua source <afile> | PackerCompile
  augroup end
  augroup terminal_config
    autocmd!
    autocmd TermOpen,BufEnter term://* startinsert | setlocal laststatus=0 cmdheight=0 noshowmode noruler
      \| autocmd BufLeave <buffer> setlocal laststatus=2 cmdheight=1 showmode ruler
  augroup end
]])

local set = vim.opt

set.clipboard = 'unnamedplus'

set.mouse = 'a'

set.expandtab = true
set.tabstop = 2
set.shiftwidth = 0

vim.g.mapleader = ' '
vim.keymap.set('n', ';', ':', { noremap = true })
vim.keymap.set('', '<PageUp>', '', { noremap = true })
vim.keymap.set('', '<PageDown>', '', { noremap = true })
vim.keymap.set('t', '<Esc>', '<C-\\><C-n>', { noremap = true })
