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

vim.g.netrw_liststyle = 3
vim.g.netrw_banner = 0

vim.g.mapleader = " "
vim.keymap.set("n", "TT", "<Cmd>terminal<CR>", { noremap = true })
vim.keymap.set("t", "<Esc>", [[(&filetype == "fzf") ? "<Esc>" : "<C-\\><C-n>"]], { noremap = true, expr = true })
vim.keymap.set("n", ";", ":", { noremap = true })
vim.keymap.set("", "<PageUp>", "", { noremap = true })
vim.keymap.set("", "<PageDown>", "", { noremap = true })

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

vim.cmd([[
  augroup lazy_user_config
    autocmd!
    autocmd BufWritePost init.lua source <afile> | Lazy sync
  augroup end
]])

require("lazy").setup({
  spec = {
    {
      "github/copilot.vim",
      config = function()
        vim.g.copilot_filetypes = { gitcommit = true }
      end,
    },
    { "jghauser/mkdir.nvim" },
    {
      "lambdalisue/suda.vim",
      init = function()
        vim.g.suda_smart_edit = 1
      end,
    },
    {
      "junegunn/fzf.vim",
      dependencies = {
        {
          "junegunn/fzf",
          build = function()
            vim.fn["fzf#install"]()
          end,
        },
      },
      init = function()
        vim.g.fzf_layout = {
          window = { width = 0.9, height = 0.9 },
        }
      end,
      keys = {
        { "e", ":GFiles --cached --others --exclude-standard<CR>" },
        { "r", ":Rg<CR>" },
        { "t", ":Buffers<CR>" },
        { "H", ":History<CR>" },
        { "?", ":Lines<CR>" },
      },
    },
    {
      "navarasu/onedark.nvim",
      dependencies = {
        "folke/snacks.nvim",
      },
      opts = {
        style = "light",
      },
      config = function(plug, opts)
        vim.cmd([[syntax on]])
        vim.opt.background = "light"
        require("onedark").setup(opts)
        require("onedark").load()
        vim.cmd([[hi link SnacksIndentChunk Comment]])
        vim.cmd([[hi link SnacksIndentScope Comment]])
      end,
    },
    {
      "folke/snacks.nvim",
      lazy = false,
      --@type snacks.Config
      opts = {
        rename = { enabled = true },
        input = { enabled = true },
        animate = { enabled = true },
        scroll = {
          enabled = true,
          animate = {
            easing = "inOutQuad",
          },
          animate_repeat = {
            easing = "inOutQuad",
          },
        },
        indent = {
          enabled = true,
          indent = {
            only_scope = true,
            char = " ",
          },
          scope = {
            char = "┊",
          },
          chunk = {
            enabled = true,
            char = {
              vertical = "┊",
              horizontal = "┈",
              arrow = "┈",
            },
          },
          animate = {
            style = "up_down",
            duration = {
              step = 5,
              total = 200,
            },
          },
        },
        notifier = {
          enabled = true,
          timeout = 3000,
          top_down = false,
          margin = { bottom = 1 },
        },
        styles = {
          input = {
            relative = "cursor",
          },
          notification = {
            wo = {
              wrap = true,
              conceallevel = 0,
            },
          },
        },
      },
      keys = {
        {
          "<leader>cn",
          function()
            Snacks.rename.rename_file()
          end,
        },
      },
    },
    {
      "olimorris/persisted.nvim",
      opts = {
        use_git_branch = true,
        autoload = true,
      },
    },
    {
      "romgrk/barbar.nvim",
      opts = {
        icons = {
          buffer_index = true,
          button = "x",
          filetype = {
            enabled = false,
          },
        },
      },
      init = function()
        vim.g.barbar_auto_setup = false
      end,
      config = function(plug, opts)
        require("barbar").setup(opts)
        local keys = {
          { "qq", "<Cmd>BufferClose<CR>" },
          { "<Tab>", "<Cmd>BufferNext<CR>" },
          { "<S-Tab>", "<Cmd>BufferPrevious<CR>" },
          { "1", "<Cmd>BufferGoto 1<CR>" },
          { "2", "<Cmd>BufferGoto 2<CR>" },
          { "3", "<Cmd>BufferGoto 3<CR>" },
          { "4", "<Cmd>BufferGoto 4<CR>" },
          { "5", "<Cmd>BufferGoto 5<CR>" },
          { "6", "<Cmd>BufferGoto 6<CR>" },
          { "7", "<Cmd>BufferGoto 7<CR>" },
          { "8", "<Cmd>BufferGoto 8<CR>" },
          { "9", "<Cmd>BufferGoto 9<CR>" },
          { "0", "<Cmd>BufferLast<CR>" },
        }
        for _, key in pairs(keys) do
          vim.keymap.set("n", key[1], key[2], { noremap = true, silent = true })
        end
      end,
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
            enable = true,
          },
        })
      end,
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
        "creativenull/efmls-configs-nvim",
      },
      config = function()
        local lspconfig = require("lspconfig")
        require("mason-lspconfig").setup({
          ensure_installed = {
            "lua_ls",
            "biome",
            "ts_ls",
          },
          handlers = {
            function(server_name)
              lspconfig[server_name].setup({
                capabilities = require("cmp_nvim_lsp").default_capabilities(),
              })
            end,
          },
        })

        vim.o.updatetime = 250
        vim.api.nvim_create_autocmd("CursorHold", {
          group = vim.api.nvim_create_augroup("float_diagnostic", { clear = true }),
          callback = function()
            vim.diagnostic.open_float(nil, { focus = false })
          end,
        })

        function _G.jump_definition_of_clicked()
          local mousepos = vim.fn.getmousepos()
          local window_type = vim.fn.win_gettype(mousepos.winid)
          if window_type ~= "" or vim.bo.buftype ~= "" then
            return
          end
          vim.lsp.buf.definition()
        end

        function _G.hover_definition_of_clicked()
          local mousepos = vim.fn.getmousepos()
          local window_type = vim.fn.win_gettype(mousepos.winid)
          if window_type ~= "" or vim.bo.buftype ~= "" then
            return
          end
          vim.lsp.buf.hover()
        end

        vim.opt.mouse = "a"
        vim.opt.mousemodel = "extend"
        vim.keymap.set(
          "n",
          "<RightMouse>",
          "<LeftMouse><Cmd>lua _G.jump_definition_of_clicked()<CR>",
          { noremap = true, silent = true }
        )
        vim.keymap.set(
          "n",
          "<LeftMouse>",
          "<LeftMouse><Cmd>lua _G.hover_definition_of_clicked()<CR>",
          { noremap = true, silent = true }
        )

        vim.g.mapleader = " "
        vim.keymap.set("n", "<leader>rn", "<Cmd>lua vim.lsp.buf.rename()<CR>", { noremap = true, silent = true })
      end,
    },
    {
      "nvimtools/none-ls.nvim",
      dependencies = {
        "nvim-lua/plenary.nvim",
      },
      config = function()
        local null_ls = require("null-ls")
        null_ls.setup({
          sources = {
            null_ls.builtins.formatting.stylua,
          },
        })
      end,
    },
    {
      dir = "~/Codes/nvim/lsp-actiononsave.nvim",
      dependencies = {
        "neovim/nvim-lspconfig",
      },
      opts = {
        verbose = true,
        servers = {
          ["null-ls"] = function(ft)
            local actions_for = {
              lua = { "format" },
            }
            return actions_for[ft] or {}
          end,
          biome = {
            "format",
            "codeAction/source.organizeImports",
            "codeAction/source.fixAll",
          },
        },
      },
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
            ["<C-b>"] = cmp.mapping.scroll_docs(-4),
            ["<C-f>"] = cmp.mapping.scroll_docs(4),
            ["<C-Space>"] = cmp.mapping.complete(),
            ["<C-e>"] = cmp.mapping.abort(),
            ["<CR>"] = cmp.mapping.confirm({ select = true }),
          }),
          sources = cmp.config.sources({
            { name = "nvim_lsp" },
            { name = "buffer" },
            { name = "path" },
          }),
        })
      end,
    },
  },
})
