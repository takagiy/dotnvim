return {
  {
    "ibhagwan/fzf-lua",
    dependencies = {
      {
        "junegunn/fzf",
        -- Not fzf#install(): on Windows it runs install.ps1, whose version check calls `cmd`, which is MSYS2's script here.
        build = "./install --bin",
      },
    },
    opts = {
      winopts = {
        height = 0.9,
        width = 0.9,
      },
      git = {
        files = {
          cmd = "git ls-files --cached --others --exclude-standard",
        },
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
