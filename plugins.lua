local plugins = {
  {
    "williamboman/mason.nvim",
    opts = {
      ensure_installed = {
        -- LSP
        "rust_analyzer", -- Rust coding
        'jdtls',         -- Java coding
        'volar',         -- Vuejs coding
        'astro',         -- Github page dev
        'ltex',          -- Spelling correction
      },
    },
  },
  {

    "neovim/nvim-lspconfig",
    config = function()
      require "plugins.configs.lspconfig"
      require "custom.configs.lspconfig"
    end,
  },
  {
    'echasnovski/mini.surround', -- Easy surround
    lazy = false,
    config = function()
      require("mini.surround").setup({})
    end
  },
  {
    'theprimeagen/harpoon', -- Small file manager/switcher
  },
  {
    'nvim-treesitter/nvim-treesitter',
    opts = {
      -- Automatically install missing parsers when entering buffer
      -- Recommendation: set to false if you don't have `tree-sitter` CLI installed locally
      ensure_installed = { "javascript", "typescript", "html", "scss", "css" },
      auto_install = true,

      highlight = {
        enable = true,

        -- Setting this to true will run `:h syntax` and tree-sitter at the same time.
        -- Set this to `true` if you depend on 'syntax' being enabled (like for indentation).
        -- Using this option may slow down your editor, and you may see some duplicate highlights.
        -- Instead of true it can also be a list of languages
        additional_vim_regex_highlighting = false,
      },
    },
  },
  {
    'nvim-telescope/telescope.nvim',
    opts = {
      defaults = {
        layout_strategy = "vertical",
        layout_config = {
          height = 0.95,
          vertical = {
            preview_cutoff = 0,
          },
        },
      },
      pickers = {
        find_files = {
          find_command = { "fd", "-I" },
        }
      }
    }
  },
  {
    "lukas-reineke/indent-blankline.nvim",
    opts = {
      show_current_context = true,
      char = '┊',
    }
  },
}

return plugins
