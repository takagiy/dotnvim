return {
  "nvim-lualine/lualine.nvim",
  opts = {
    options = {
      globalstatus = false,
      section_separators = "",
      component_separators = "",
      disabled_filetypes = { statusline = { "herdr-core" } },
    },
    sections = {
      lualine_a = { "mode" },
      lualine_b = { "branch" },
      lualine_c = { { "filename", path = 1, symbols = { readonly = "", modified = " +" } } },
      lualine_x = { "filetype" },
      lualine_y = { "progress" },
      lualine_z = { "location" },
    },
  },
}
