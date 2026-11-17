return {
  "takagiy/herdr-core.nvim",
  lazy = false,
  init = function()
    if vim.fn.has("win32") == 1 and vim.fn.executable("hc") == 0 then
      local directory = vim.env.LOCALAPPDATA .. "/Programs/herdr-core"
      if vim.fn.executable(directory .. "/hc.exe") == 1 then
        vim.env.PATH = directory .. ";" .. vim.env.PATH
      end
    end
  end,
  config = function()
    local app = require("herdr-core").setup({
      auto_insert = false,
      sidebar_width = 32,
    })
    if not app.actions then return end
    vim.keymap.set("n", "<leader>ht", app.actions.new_tab)
    vim.keymap.set("n", "<leader>hv", app.actions.new_vertical)
    vim.keymap.set("n", "<leader>hs", app.actions.new_horizontal)
    vim.keymap.set("n", "<leader>hb", app.actions.toggle_sidebar)
    vim.keymap.set("n", "<leader>hf", app.actions.focus_sidebar)
  end,
}
