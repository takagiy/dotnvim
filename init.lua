local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
  local lazyrepo = "https://github.com/folke/lazy.nvim.git"
  local out = vim.fn.system({ "git", "clone", "--filter=blob:none", "--branch=stable", lazyrepo, lazypath })
  if vim.v.shell_error ~= 0 then
    vim.api.nvim_echo({
      { "Failed to clone lazy.nvim:\n", "ErrorMsg" },
      { out,                            "WarningMsg" },
      { "\nPress any key to exit..." },
    }, true, {})
    vim.fn.getchar()
    os.exit(1)
  end
end
vim.opt.rtp:prepend(lazypath)

vim.cmd [[
  augroup lazy_user_config
    autocmd!
    autocmd BufWritePost init.lua source <afile> | Lazy sync
  augroup end
]]

require("lazy").setup({
  spec = {
    {
      "github/copilot.vim",
      config = function()
        vim.g.copilot_filetypes = { gitcommit = true }
      end
    },
    { "jghauser/mkdir.nvim" },
    {
      "lambdalisue/suda.vim",
      init = function()
        vim.g.suda_smart_edit = 1
      end
    },
    {
      "junegunn/fzf.vim",
      dependencies = {
        {
          "junegunn/fzf",
          build = function()
            vim.fn["fzf#install"]()
          end
        },
      },
      config = function()
        vim.g.fzf_layout = {
          window = { width = 0.9, height = 0.9 }
        }
        local opts = { noremap = true, silent = true }
        vim.keymap.set("n", "e", ":GFiles --cached --others --exclude-standard<CR>", opts)
        vim.keymap.set("n", "r", ":Rg<CR>", opts)
        vim.keymap.set("n", "t", ":Buffers<CR>", opts)
        vim.keymap.set("n", "H", ":History<CR>", opts)
        vim.keymap.set("n", "?", ":Lines<CR>", opts)
      end
    },
    {
      "navarasu/onedark.nvim",
      opts = {
        style = "light",
      },
      config = function(plug, opts)
        vim.cmd [[syntax on]]
        vim.opt.background = "light"
        require("onedark").setup(opts)
        require("onedark").load()
      end
    },
    {
      "folke/persistence.nvim",
      opts = {
        options = {
          "blank",
          "buffers",
          "curdir",
          "folds",
          "globals",
          "help",
          "localoptions",
          "skiprtp",
          "resize",
          "sesdir",
          "tabpages",
          "terminal",
          "winpos",
          "winsize",
        },
        pre_save = function()
          vim.api.nvim_exec_autocmds("User",
            { pattern = "SessionSavePre" })
        end,
        branch = true,
      },
      config = function(plug, opts)
        require("persistence").setup(opts)
        require("persistence").load()
      end
    },
    {
      "romgrk/barbar.nvim",
      opts = {
        icons = {
          buffer_index = true,
          button = "x",
          filetype = {
            enabled = false
          },
        }
      },
      init = function() vim.g.barbar_auto_setup = false end,
      config = function(plug, opts)
        require("barbar").setup(opts)
        local keyset = vim.keymap.set
        local opts = { noremap = true, silent = true }
        keyset("n", "qq", "<Cmd>BufferClose<CR>", opts)
        keyset("n", "<Tab>", "<Cmd>BufferNext<CR>", opts)
        keyset("n", "<S-Tab>", "<Cmd>BufferPrevious<CR>", opts)
        keyset("n", "1", "<Cmd>BufferGoto 1<CR>", opts)
        keyset("n", "2", "<Cmd>BufferGoto 2<CR>", opts)
        keyset("n", "3", "<Cmd>BufferGoto 3<CR>", opts)
        keyset("n", "4", "<Cmd>BufferGoto 4<CR>", opts)
        keyset("n", "5", "<Cmd>BufferGoto 5<CR>", opts)
        keyset("n", "6", "<Cmd>BufferGoto 6<CR>", opts)
        keyset("n", "7", "<Cmd>BufferGoto 7<CR>", opts)
        keyset("n", "8", "<Cmd>BufferGoto 8<CR>", opts)
        keyset("n", "9", "<Cmd>BufferGoto 9<CR>", opts)
        keyset("n", "0", "<Cmd>BufferLast<CR>", opts)
      end
    },
    {
      "nvim-treesitter/nvim-treesitter",
      event = "VeryLazy",
      build = ":TSUpdate",
      config = function()
        require("nvim-treesitter.configs").setup({
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
    },
    {
      "williamboman/mason.nvim",
      build = ":MasonUpdate",
      opts = {},
    },
    {
      "williamboman/mason-lspconfig.nvim",
      dependencies = {
        "williamboman/mason.nvim",
        "neovim/nvim-lspconfig",
        "hrsh7th/cmp-nvim-lsp",
      },
      config = function()
        local lspconfig = require("lspconfig")
        require("mason-lspconfig").setup_handlers({
          function(server_name)
            lspconfig[server_name].setup({
              capabilities = require("cmp_nvim_lsp").default_capabilities(),
            })
          end
        })
        vim.api.nvim_create_autocmd("LspAttach", {
          callback = function(ev)
            local client = vim.lsp.get_client_by_id(ev.data.client_id)
            if client == nil then
              return
            end
            if client.supports_method("textDocument/formatting") then
              vim.api.nvim_create_autocmd({ "BufWritePre" }, {
                buffer = ev.bufnr,
                callback = function()
                  vim.lsp.buf.format({ async = false })
                end,
              })
            end
          end,
        })
        function _G.jump_definition_of_clicked()
          local mousepos = vim.fn.getmousepos()
          local window_type = vim.fn.win_gettype(mousepos.winid)
          if window_type ~= '' or vim.bo.buftype ~= '' then
            return
          end
          vim.lsp.buf.definition()
        end

        vim.opt.mouse = "a"
        vim.opt.mousemodel = "extend"
        vim.keymap.set("n", "<RightMouse>",
          "<LeftMouse><Cmd>lua _G.jump_definition_of_clicked()<CR>",
          { noremap = true, silent = true })
      end
    },
    {
      "hrsh7th/nvim-cmp",
      dependencies = {
        "hrsh7th/cmp-nvim-lsp",
        "hrsh7th/cmp-buffer",
        "hrsh7th/cmp-path",
      },
      config = function()
        local cmp = require("cmp")
        cmp.setup({
          mapping = cmp.mapping.preset.insert({
            ['<C-b>'] = cmp.mapping.scroll_docs(-4),
            ['<C-f>'] = cmp.mapping.scroll_docs(4),
            ['<C-Space>'] = cmp.mapping.complete(),
            ['<C-e>'] = cmp.mapping.abort(),
            ['<CR>'] = cmp.mapping.confirm({ select = true }),
          }),
          sources = cmp.config.sources({
            { name = "nvim_lsp" },
            { name = "buffer" },
            { name = "path" },
          }),
        })
      end
    }
  },
})

vim.cmd [[
  augroup terminal_config
    autocmd!
    autocmd TermOpen,TermEnter * startinsert | set buflisted
  augroup end
]]

local set = vim.opt

set.clipboard = "unnamedplus"

set.mouse = "a"

set.expandtab = true
set.tabstop = 2
set.shiftwidth = 0

set.hidden = true

set.shell = "zsh -l"

vim.g.netrw_liststyle = 3
vim.g.netrw_banner = 0

vim.g.mapleader = " "
vim.keymap.set("n", "TT", "<Cmd>terminal<CR>", { noremap = true })
vim.keymap.set("t", "<Esc>", [[(&filetype == "fzf") ? "<Esc>" : "<C-\\><C-n>"]], { noremap = true, expr = true })
vim.keymap.set("n", ";", ":", { noremap = true })
vim.keymap.set("", "<PageUp>", "", { noremap = true })
vim.keymap.set("", "<PageDown>", "", { noremap = true })
