vim.cmd [[packadd packer.nvim]]

require('packer').startup({
  function(use)
    use 'wbthomason/packer.nvim'
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
          'coc-highlight',
          'coc-lua',
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
          ensure_installed = { "lua", "rust" },
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
        vim.keymap.set('n', '<Tab>', ':GFiles --cached --others --exclude-standard<CR>',
          { noremap = true, silent = true })
        vim.keymap.set('n', '<S-Tab>', ':Buffers<CR>', { noremap = true, silent = true })
      end
    }
    use {
      'lambdalisue/suda.vim',
      config = function()
        vim.g.suda_smart_edit = 1
      end
    }
    use {
      'navarasu/onedark.nvim',
      config = function()
        vim.cmd [[syntax on]]
        vim.opt.background = 'light'
        require('onedark').setup({
          style = 'light'
        })
        require('onedark').load()
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
]])

local set = vim.opt

set.clipboard = 'unnamedplus'

set.mouse = 'a'

set.expandtab = true
set.tabstop = 2
set.shiftwidth = 0

vim.g.mapleader = ' '
vim.keymap.set('n', ';', ':', { noremap = true })
