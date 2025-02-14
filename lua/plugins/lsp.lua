return {
  {
    "williamboman/mason.nvim",
    build = ":MasonUpdate",
    opts = {},
  },
  { "williamboman/mason.nvim" },
  { "neovim/nvim-lspconfig" },
  {
    "williamboman/mason-lspconfig.nvim",
    lazy = false,
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
    end,
    keys = {
      { "<RightMouse>", "<LeftMouse><Cmd>lua _G.jump_definition_of_clicked()<CR>" },
      { "<LeftMouse>", "<LeftMouse><Cmd>lua _G.hover_definition_of_clicked()<CR>" },
      { "<leader>rn", "<Cmd>lua vim.lsp.buf.rename()<CR>" },
    },
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
    "ray-x/lsp_signature.nvim",
    event = "LspAttach",
    opts = {},
  },
}
