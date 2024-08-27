local plugins = 
{
  {
    "hadronized/hop.nvim",
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
}
}


return plugins
