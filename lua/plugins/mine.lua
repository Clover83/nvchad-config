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
  }
}


return plugins
