return {
  "romgrk/barbar.nvim",
  lazy = false,
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
  keys = {
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
  },
}
