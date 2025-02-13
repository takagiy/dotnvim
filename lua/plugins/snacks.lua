return {
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
}
