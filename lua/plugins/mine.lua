local plugins =
{
  {
    "ggandor/leap.nvim",
    lazy = false
  },

  {
    "ThePrimeagen/harpoon",
    lazy = true
  },

  {
    'chipsenkbeil/distant.nvim',
    lazy = false,
    branch = 'v0.3',
    config = function()
        require('distant'):setup()
    end
  },

  {
    "christoomey/vim-tmux-navigator",
    lazy = false
  },

  {
    "kylechui/nvim-surround",
    version = "*", -- Use for stability; omit to use `main` branch for the latest features
    event = "VeryLazy",
    config = function()
        require("nvim-surround").setup({
            -- Configuration here, or leave empty to use defaults
        })
    end
  },

  {
    "nvim-treesitter/nvim-treesitter-textobjects",
    lazy = false
  },

  {
    "nvim-treesitter/nvim-treesitter-context",
    lazy = true,
  },

  { "rcarriga/nvim-dap-ui", dependencies = {"mfussenegger/nvim-dap", "nvim-neotest/nvim-nio"} },
  { "mfussenegger/nvim-dap-python", dependencies = {"mfussenegger/nvim-dap"}},

  {
    'nvim-neorg/neorg',
    ft = 'norg', -- lazy load on filetype
    cmd = 'Neorg', -- lazy load on command, allows you to autocomplete :Neorg regardless of whether it's loaded yet
    --  (you could also just remove both lazy loading things)
    config = function()
      require('neorg').setup {
        load = {
          ['core.defaults'] = {},
          ['core.concealer'] = {},
          ['core.dirman'] = {
            config = {
              workspaces = {
                notes = "~/Documents/work/notes"
              }
            }
          },
        },
      }
    end
  },
}


return plugins
