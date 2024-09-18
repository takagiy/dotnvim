local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
  local lazyrepo = "https://github.com/folke/lazy.nvim.git"
  local out = vim.fn.system({ "git", "clone", "--filter=blob:none", "--branch=stable", lazyrepo, lazypath })
  if vim.v.shell_error ~= 0 then
    vim.api.nvim_echo({
      { "Failed to clone lazy.nvim:\n", "ErrorMsg" },
      { out,                            "WarningMsg" },
      { "\nPress any key to exit..." },
    }, true, {})
    vim.fn.getchar()
    os.exit(1)
  end
end
vim.opt.rtp:prepend(lazypath)

vim.cmd [[
  augroup lazy_user_config
    autocmd!
    autocmd BufWritePost init.lua source <afile> | Lazy sync
  augroup end
]]

require("lazy").setup({
  spec = {
    { "github/copilot.vim" },
    { "jghauser/mkdir.nvim" },
    {
      "lambdalisue/suda.vim",
      config = function()
        vim.g.suda_smart_edit = 1
      end
    },
    {
      "junegunn/fzf.vim",
      dependencies = {
        {
          "junegunn/fzf",
          build = function()
            vim.fn["fzf#install"]()
          end
        },
      },
      config = function()
        vim.g.fzf_layout = {
          window = { width = 0.9, height = 0.9 }
        }
        local opts = { noremap = true, silent = true }
        vim.keymap.set("n", "e", ":GFiles --cached --others --exclude-standard<CR>", opts)
        vim.keymap.set("n", "r", ":Rg<CR>", opts)
        vim.keymap.set("n", "t", ":Buffers<CR>", opts)
        vim.keymap.set("n", "H", ":History<CR>", opts)
        vim.keymap.set("n", "?", ":Lines<CR>", opts)
      end
    },
    {
      "navarasu/onedark.nvim",
      opts = {
        style = "light",
      },
      config = function(plug, opts)
        vim.cmd [[syntax on]]
        vim.opt.background = "light"
        require("onedark").setup(opts)
        require("onedark").load()
      end
    },
    {
      "folke/persistence.nvim",
      opts = {
        options = {
          "blank",
          "buffers",
          "curdir",
          "folds",
          "globals",
          "help",
          "localoptions",
          "skiprtp",
          "resize",
          "sesdir",
          "tabpages",
          "terminal",
          "winpos",
          "winsize",
        },
        pre_save = function()
          vim.api.nvim_exec_autocmds("User",
            { pattern = "SessionSavePre" })
        end,
        branch = true,
      },
      config = function(plug, opts)
        require("persistence").setup(opts)
        require("persistence").load()
      end
    },
    {
      "romgrk/barbar.nvim",
      opts = {
        icons = {
          buffer_index = true,
          button = "x",
          filetype = {
            enabled = false
          },
        }
      },
      init = function() vim.g.barbar_auto_setup = false end,
      config = function(plug, opts)
        require("barbar").setup(opts)
        local keyset = vim.keymap.set
        local opts = { noremap = true, silent = true }
        keyset("n", "qq", "<Cmd>BufferClose<CR>", opts)
        keyset("n", "<Tab>", "<Cmd>BufferNext<CR>", opts)
        keyset("n", "<S-Tab>", "<Cmd>BufferPrevious<CR>", opts)
        keyset("n", "1", "<Cmd>BufferGoto 1<CR>", opts)
        keyset("n", "2", "<Cmd>BufferGoto 2<CR>", opts)
        keyset("n", "3", "<Cmd>BufferGoto 3<CR>", opts)
        keyset("n", "4", "<Cmd>BufferGoto 4<CR>", opts)
        keyset("n", "5", "<Cmd>BufferGoto 5<CR>", opts)
        keyset("n", "6", "<Cmd>BufferGoto 6<CR>", opts)
        keyset("n", "7", "<Cmd>BufferGoto 7<CR>", opts)
        keyset("n", "8", "<Cmd>BufferGoto 8<CR>", opts)
        keyset("n", "9", "<Cmd>BufferGoto 9<CR>", opts)
        keyset("n", "0", "<Cmd>BufferLast<CR>", opts)
      end
    },
    {
      "nvim-treesitter/nvim-treesitter",
      event = "VeryLazy",
      build = function()
        local ts_update = require("nvim-treesitter.install").update({ with_sync = true })
        ts_update()
      end,
      opts = {
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
          enable = true
        }
      },
    },
    {
      "neoclide/coc.nvim",
      branch = "release",
      config = function()
        vim.g.coc_global_extensions = {
          "coc-rust-analyzer",
          "coc-toml",
          "coc-json",
          "coc-tsserver",
          "coc-prettier",
          "coc-biome",
          "coc-highlight",
          "coc-lua",
          "coc-java",
        }
        -- https://raw.githubusercontent.com/neoclide/coc.nvim/master/doc/coc-example-config.lua

        -- Some servers have issues with backup files, see #649
        -- vim.opt.backup = false
        -- vim.opt.writebackup = false

        -- Having longer updatetime (default is 4000 ms = 4s) leads to noticeable
        -- delays and poor user experience
        vim.opt.updatetime = 300

        -- Always show the signcolumn, otherwise it would shift the text each time
        -- diagnostics appeared/became resolved
        -- vim.opt.signcolumn = "yes"

        vim.g.mapleader = " "
        local keyset = vim.keymap.set
        -- Autocomplete
        function _G.check_back_space()
          local col = vim.fn.col(".") - 1
          return col == 0 or vim.fn.getline("."):sub(col, col):match("%s") ~= nil
        end

        -- Use Tab for trigger completion with characters ahead and navigate
        -- NOTE: There's always a completion item selected by default, you may want to enable
        -- no select by setting `"suggest.noselect": true` in your configuration file
        -- NOTE: Use command ':verbose imap <tab>' to make sure Tab is not mapped by
        -- other plugins before putting this into your config
        local opts = { silent = true, noremap = true, expr = true, replace_keycodes = false }
        keyset("i", "<TAB>",
          'coc#pum#visible() ? coc#pum#next(1) : v:lua.check_back_space() ? "<TAB>" : coc#refresh()',
          opts)
        keyset("i", "<S-TAB>", [[coc#pum#visible() ? coc#pum#prev(1) : "\<C-h>"]], opts)

        -- Make <CR> to accept selected completion item or notify coc.nvim to format
        -- <C-g>u breaks current undo, please make your own choice
        keyset("i", "<cr>",
          [[coc#pum#visible() ? coc#pum#confirm() : "\<C-g>u\<CR>\<c-r>=coc#on_enter()\<CR>"]],
          opts)

        -- Use <c-j> to trigger snippets
        keyset("i", "<c-j>", "<Plug>(coc-snippets-expand-jump)")
        -- Use <c-space> to trigger completion
        keyset("i", "<c-space>", "coc#refresh()", { silent = true, expr = true })

        -- Use `[g` and `]g` to navigate diagnostics
        -- Use `:CocDiagnostics` to get all diagnostics of current buffer in location list
        keyset("n", "[g", "<Plug>(coc-diagnostic-prev)", { silent = true })
        keyset("n", "]g", "<Plug>(coc-diagnostic-next)", { silent = true })

        -- GoTo code navigation
        keyset("n", "gd", "<Plug>(coc-definition)", { silent = true })
        keyset("n", "gy", "<Plug>(coc-type-definition)", { silent = true })
        keyset("n", "gi", "<Plug>(coc-implementation)", { silent = true })
        keyset("n", "gr", "<Plug>(coc-references)", { silent = true })


        -- Use K to show documentation in preview window
        function _G.show_docs()
          local cw = vim.fn.expand("<cword>")
          if vim.fn.index({ "vim", "help" }, vim.bo.filetype) >= 0 then
            vim.api.nvim_command("h " .. cw)
          elseif vim.api.nvim_eval("coc#rpc#ready()") then
            vim.fn.CocActionAsync("doHover")
          else
            vim.api.nvim_command("!" .. vim.o.keywordprg .. " " .. cw)
          end
        end

        keyset("n", "K", "<CMD>lua _G.show_docs()<CR>", { silent = true })


        -- Highlight the symbol and its references on a CursorHold event(cursor is idle)
        vim.api.nvim_create_augroup("CocGroup", {})
        vim.api.nvim_create_autocmd("CursorHold", {
          group = "CocGroup",
          command = "silent call CocActionAsync('highlight')",
          desc = "Highlight symbol under cursor on CursorHold"
        })


        -- Symbol renaming
        keyset("n", "<leader>rn", "<Plug>(coc-rename)", { silent = true })


        -- Formatting selected code
        keyset("x", "<leader>f", "<Plug>(coc-format-selected)", { silent = true })
        keyset("n", "<leader>f", "<Plug>(coc-format-selected)", { silent = true })


        -- Setup formatexpr specified filetype(s)
        vim.api.nvim_create_autocmd("FileType", {
          group = "CocGroup",
          pattern = "typescript,json",
          command = "setl formatexpr=CocAction('formatSelected')",
          desc = "Setup formatexpr specified filetype(s)."
        })

        -- Update signature help on jump placeholder
        vim.api.nvim_create_autocmd("User", {
          group = "CocGroup",
          pattern = "CocJumpPlaceholder",
          command = "call CocActionAsync('showSignatureHelp')",
          desc = "Update signature help on jump placeholder"
        })

        -- Apply codeAction to the selected region
        -- Example: `<leader>aap` for current paragraph
        local opts = { silent = true, nowait = true }
        keyset("x", "<leader>a", "<Plug>(coc-codeaction-selected)", opts)
        keyset("n", "<leader>a", "<Plug>(coc-codeaction-selected)", opts)

        -- Remap keys for apply code actions at the cursor position.
        keyset("n", "<leader>ac", "<Plug>(coc-codeaction-cursor)", opts)
        -- Remap keys for apply source code actions for current file.
        keyset("n", "<leader>as", "<Plug>(coc-codeaction-source)", opts)
        -- Apply the most preferred quickfix action on the current line.
        keyset("n", "<leader>qf", "<Plug>(coc-fix-current)", opts)

        -- Remap keys for apply refactor code actions.
        keyset("n", "<leader>re", "<Plug>(coc-codeaction-refactor)", { silent = true })
        keyset("x", "<leader>r", "<Plug>(coc-codeaction-refactor-selected)", { silent = true })
        keyset("n", "<leader>r", "<Plug>(coc-codeaction-refactor-selected)", { silent = true })

        -- Run the Code Lens actions on the current line
        keyset("n", "<leader>cl", "<Plug>(coc-codelens-action)", opts)


        -- Map function and class text objects
        keyset("n", "<C-s>", "<Plug>(coc-range-select)", { silent = true })
        keyset("x", "<C-s>", "<Plug>(coc-range-select)", { silent = true })


        -- Add `:Format` command to format current buffer
        vim.api.nvim_create_user_command("Format", "call CocAction('format')", {})

        -- " Add `:Fold` command to fold current buffer
        vim.api.nvim_create_user_command("Fold", "call CocAction('fold', <f-args>)",
          { nargs = "?" })

        -- Add `:OR` command for organize imports of the current buffer
        vim.api.nvim_create_user_command("OR",
          "call CocActionAsync('runCommand', 'editor.action.organizeImport')", {})

        -- Add (Neo)Vim's native statusline support
        -- NOTE: Please see `:h coc-status` for integrations with external plugins that
        -- provide custom statusline: lightline.vim, vim-airline
        vim.opt.statusline = "%f%r %=%l/%L %{coc#status()}%{get(b:,'coc_current_function','')}"

        -- Mappings for CoCList
        -- code actions and coc stuff
        ---@diagnostic disable-next-line: redefined-local
        local opts = { silent = true, nowait = true }
        -- Show all diagnostics
        keyset("n", "<space>a", ":<C-u>CocList diagnostics<cr>", opts)
        -- Manage extensions
        keyset("n", "<space>e", ":<C-u>CocList extensions<cr>", opts)
        -- Show commands
        keyset("n", "<space>c", ":<C-u>CocList commands<cr>", opts)
        -- Find symbol of current document
        keyset("n", "<space>o", ":<C-u>CocList outline<cr>", opts)
        -- Search workspace symbols
        keyset("n", "<space>s", ":<C-u>CocList -I symbols<cr>", opts)
        -- Do default action for next item
        keyset("n", "<space>j", ":<C-u>CocNext<cr>", opts)
        -- Do default action for previous item
        keyset("n", "<space>k", ":<C-u>CocPrev<cr>", opts)
        -- Resume latest coc list
        keyset("n", "<space>p", ":<C-u>CocListResume<cr>", opts)

        -- Mouse button mappings
        function _G.jump_def_of_clicked()
          local mousepos = vim.fn.getmousepos()
          local window_type = vim.fn.win_gettype(mousepos.winid)
          if window_type == "" and mousepos.winrow ~= 0 then
            vim.cmd('call CocActionAsync("jumpDefinition")')
          end
        end

        local opts = { silent = true, noremap = true }
        vim.opt.mousemodel = "extend"
        keyset("n", "<RightMouse>", "<LeftMouse><CMD>lua _G.jump_def_of_clicked()<CR>", opts)
        keyset("n", "<LeftMouse>", "<LeftMouse><Cmd>lua _G.show_docs()<CR>", opts)
      end,
    }
  },
})

vim.cmd [[
  augroup terminal_config
    autocmd!
    autocmd TermOpen,TermEnter * startinsert | set buflisted
  augroup end
]]

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
vim.keymap.set("i", "jk", "<Esc>", { noremap = true })
vim.keymap.set("v", "jk", "<Esc>", { noremap = true })
vim.keymap.set("t", "jk", [[(&filetype == "fzf") ? "<Esc>" : "<C-\\><C-n>"]], { noremap = true, expr = true })
vim.keymap.set("t", "<Esc>", [[(&filetype == "fzf") ? "<Esc>" : "<C-\\><C-n>"]], { noremap = true, expr = true })
vim.keymap.set("n", ";", ":", { noremap = true })
vim.keymap.set("", "<PageUp>", "", { noremap = true })
vim.keymap.set("", "<PageDown>", "", { noremap = true })
