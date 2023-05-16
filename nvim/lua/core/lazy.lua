-----------------------------------------------------------
-- Plugin manager configuration file
-----------------------------------------------------------

-- Plugin manager: lazy.nvim
-- URL: https://github.com/folke/lazy.nvim

-- For information about installed plugins see the README:
-- neovim-lua/README.md
-- https://github.com/brainfucksec/neovim-lua#readme

-- Bootstrap lazy.nvim
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable", -- latest stable release
    lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)

-- Use a protected call so we don't error out on first use
local status_ok, lazy = pcall(require, 'lazy')
if not status_ok then
  return
end

-- Start setup
lazy.setup({
  spec = {
    -- Colorscheme:
    -- The colorscheme should be available when starting Neovim.
    {
      'navarasu/onedark.nvim',
      lazy = false, -- make sure we load this during startup if it is your main colorscheme
      priority = 1000, -- make sure to load this before all the other start plugins
    },

    -- other colorschemes:
    { 'tanvirtin/monokai.nvim', lazy = true },
    { 'https://github.com/rose-pine/neovim', name = 'rose-pine', lazy = true },

    -- Icons
    { 'kyazdani42/nvim-web-devicons', lazy = true },

    -- Dashboard (start screen)
    {
      'goolord/alpha-nvim',
      dependencies = { 'kyazdani42/nvim-web-devicons' },
    },

    -- Git labels
    {
      'lewis6991/gitsigns.nvim',
      lazy = true,
      dependencies = {
        'nvim-lua/plenary.nvim',
        'kyazdani42/nvim-web-devicons',
      },
      config = function()
        require('gitsigns').setup{}
      end
    },

    -- File explorer
    {
      'kyazdani42/nvim-tree.lua',
      dependencies = { 'kyazdani42/nvim-web-devicons' },
    },

    -- Statusline
    {
      'freddiehaddad/feline.nvim',
      dependencies = {
        'kyazdani42/nvim-web-devicons',
        'lewis6991/gitsigns.nvim',
      },
    },

    -- Treesitter
    { 'nvim-treesitter/nvim-treesitter', build = ':TSUpdate' },

    -- Indent line
    { 'lukas-reineke/indent-blankline.nvim' },

    -- Tag viewer
    { 'preservim/tagbar' },

    -- Autopair
    {
      'windwp/nvim-autopairs',
      event = 'InsertEnter',
      config = function()
        require('nvim-autopairs').setup{}
      end
    },

    -- LSP
    { 'neovim/nvim-lspconfig' },

    -- Autocomplete
    {
      'hrsh7th/nvim-cmp',
      -- load cmp on InsertEnter
      event = 'InsertEnter',
      -- these dependencies will only be loaded when cmp loads
      -- dependencies are always lazy-loaded unless specified otherwise
      dependencies = {
        'L3MON4D3/LuaSnip',
        'hrsh7th/cmp-nvim-lsp',
        'hrsh7th/cmp-path',
        'hrsh7th/cmp-buffer',
        'saadparwaiz1/cmp_luasnip',
      },
    },
    -- Elixir LS
    {
      "mhanberg/elixir.nvim",
      ft = { "elixir", "eex", "heex", "surface" },
      config = function()
        local elixir = require("elixir")

        elixir.setup {
          settings = elixir.settings {
            dialyzerEnabled = false,
            enableTestLenses = false,
          },
          log_level = vim.lsp.protocol.MessageType.Log,
          message_level = vim.lsp.protocol.MessageType.Log,
          on_attach = function(client, bufnr)
            -- whatever keybinds you want, see below for more suggestions
            vim.keymap.set("n", "<space>fp", ":ElixirFromPipe<cr>", { buffer = true, noremap = true })
            vim.keymap.set("n", "<space>tp", ":ElixirToPipe<cr>", { buffer = true, noremap = true })
            vim.keymap.set("v", "<space>em", ":ElixirExpandMacro<cr>", { buffer = true, noremap = true })
          end,
        }
      end,
      dependencies = {
        "nvim-lua/plenary.nvim",
      },
    },
    {
      "ray-x/go.nvim",
      dependencies = {  -- optional packages
        "ray-x/guihua.lua",
        "neovim/nvim-lspconfig",
        "nvim-treesitter/nvim-treesitter",
      },
      config = function()
        require("go").setup()
      end,
      event = {"CmdlineEnter"},
      ft = {"go", 'gomod'},
      build = ':lua require("go.install").update_all_sync()' -- if you need to install/update all binaries
    },
    {
      "mhinz/vim-mix-format",
      init = function()
        vim.g.mix_format_on_save = 1
        vim.g.mix_format_silent_errors = 1
      end,
    },
    -- source: https://www.reddit.com/r/rust/comments/yxyeic/to_neovim_users_what_kind_of_rust_specific/
    -- from https://github.com/drbrain/vimrc/blob/main/lua/plugins/rust.lua
    {
      "simrat39/rust-tools.nvim",

      event = "FileType rust",
    },
    {
      "rust-lang/rust.vim",

      event = "FileType rust",

      config = function()
        vim.g.rustfmt_autosave = 1
      end
    },
    {
      "saecki/crates.nvim",
      dependencies = {
        "plenary.nvim",
        "null-ls.nvim",
      },

      event = "BufRead Cargo.toml",

      keys = {
        { "<Leader>Ct", "<Cmd>lua require(\"crates\").toggle()<CR>", desc = "Toggle Crates" },
        { "<Leader>Cr", "<Cmd>lua require(\"crates\").reload()<CR>", desc = "Reload Crates" },

        { "<Leader>Cv", "<Cmd>lua require(\"crates\").show_versions_popup()<CR>", desc = "Show Crate Versions" },
        { "<Leader>Cf", "<Cmd>lua require(\"crates\").show_features_popup()<CR>", desc = "Show Crate Features" },
        { "<Leader>Cd", "<Cmd>lua require(\"crates\").show_dependencies_popup()<CR>", desc = "Show Crate Dependencies" },

        { "<Leader>Cu", "<Cmd>lua require(\"crates\").update_crate()<CR>", desc = "Update Crate" },
        { "<Leader>Cu", "<Cmd>lua require(\"crates\").update_crates()<CR>", mode = "v", desc = "Update Crates" },
        { "<Leader>Ca", "<Cmd>lua require(\"crates\").update_all_crates()<CR>", desc = "Update All Crates" },

        { "<Leader>CU", "<Cmd>lua require(\"crates\").upgrade_crate()<CR>", desc = "Upgrade Crate" },
        { "<Leader>CU", "<Cmd>lua require(\"crates\").upgrade_crates()<CR>", mode = "v", desc = "Upgrade Crates" },
        { "<Leader>CA", "<Cmd>lua require(\"crates\").upgrade_all_crates()<CR>", desc = "Upgrade All Crates" },

        { "<Leader>CH", "<Cmd>lua require(\"crates\").open_homepage()<CR>", desc = "Open Crate Homepage" },
        { "<Leader>CR", "<Cmd>lua require(\"crates\").open_repository()<CR>", desc = "Open Crate Repository" },
        { "<Leader>CD", "<Cmd>lua require(\"crates\").open_documentation()<CR>", desc = "Open Crate Documentation" },
        { "<Leader>CC", "<Cmd>lua require(\"crates\").open_crates_io()<CR>", desc = "Open crates.io" },
      },
      opts = {
        null_ls = {
          enabled = true,
          name = "crates.nvim",
        },
      }
    },
    {
      'Exafunction/codeium.vim',
      config = function ()
        -- Change '<C-g>' here to any keycode you like.
        vim.keymap.set('i', '<C-g>', function () return vim.fn['codeium#Accept']() end, { expr = true })
        vim.keymap.set('i', '<c-;>', function() return vim.fn['codeium#CycleCompletions'](1) end, { expr = true })
        vim.keymap.set('i', '<c-,>', function() return vim.fn['codeium#CycleCompletions'](-1) end, { expr = true })
        vim.keymap.set('i', '<c-x>', function() return vim.fn['codeium#Clear']() end, { expr = true })
      end
    },
    {
      "junegunn/fzf.vim",
      dependencies = {
        "junegunn/fzf"
      }
    },
  },
})
