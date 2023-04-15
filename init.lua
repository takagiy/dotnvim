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
      'sonph/onehalf',
      rtp = 'vim',
      config = function()
        vim.cmd [[syntax on]]
        vim.opt.background = 'light'
        vim.cmd [[colorscheme onehalflight]]
        vim.cmd [[hi! SpecialComment ctermfg=247 guifg=#a0a1a7]]
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

set.termguicolors = true

set.clipboard = 'unnamedplus'

set.mouse = 'a'

set.expandtab = true
set.tabstop = 2
set.shiftwidth = 0

vim.g.mapleader = ' '
vim.keymap.set('n', ';', ':', { noremap = true })
