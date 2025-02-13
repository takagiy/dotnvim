return {
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
}
