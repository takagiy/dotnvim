return {
  {
    "navarasu/onedark.nvim",
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
    "catgoose/nvim-colorizer.lua",
    event = "BufReadPre",
    opts = {
      user_default_options = {
        css = true,
        tailwind = true,
      },
    },
  },
}
