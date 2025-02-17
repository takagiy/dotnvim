return {
  {
    "ibhagwan/fzf-lua",
    dependencies = {
      {
        "junegunn/fzf",
        build = function()
          vim.fn["fzf#install"]()
        end,
      },
    },
    opts = {
      winopts = {
        height = 0.9,
        width = 0.9,
      },
      git = {
        cmd = "git ls-files --cached --others --exclude-standard",
      },
    },
    keys = {
      {
        "<leader>ac",
        function()
          require("fzf-lua").lsp_code_actions()
        end,
      },
      {
        "e",
        function()
          require("fzf-lua").git_files()
        end,
      },
      {
        "t",
        function()
          require("fzf-lua").buffers()
        end,
      },
      {
        "r",
        function()
          require("fzf-lua").grep_project()
        end,
      },
    },
  },
}
