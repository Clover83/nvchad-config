require "nvchad.options"

-- add yours here!

-- local o = vim.o
-- o.cursorlineopt ='both' -- to enable cursorline!

require'nvim-treesitter.configs'.setup {
  textobjects = {
    select = {
      enable = true,

      -- Automatically jump forward to textobj, similar to targets.vim
      lookahead = true,

      keymaps = {
        -- You can use the capture groups defined in textobjects.scm
        ["af"] = "@function.outer",
        ["if"] = "@function.inner",
        ["ac"] = "@class.outer",
        -- You can optionally set descriptions to the mappings (used in the desc parameter of
        -- nvim_buf_set_keymap) which plugins like which-key display
        ["ic"] = { query = "@class.inner", desc = "Select inner part of a class region" },
        -- You can also use captures from other query groups like `locals.scm`
        ["al"] = { query = "@scope", query_group = "locals", desc = "Select language scope" },
        ["ad"] = { query = "@conditional.outer", desc = "Around conditional"},
        ["id"] = { query = "@conditional.inner", desc = "Inside conditional"},
      },
      -- You can choose the select mode (default is charwise 'v')
      --
      -- Can also be a function which gets passed a table with the keys
      -- * query_string: eg '@function.inner'
      -- * method: eg 'v' or 'o'
      -- and should return the mode ('v', 'V', or '<c-v>') or a table
      -- mapping query_strings to modes.
      selection_modes = {
        ['@parameter.outer'] = 'v', -- charwise
        ['@function.outer'] = 'V', -- linewise
        ['@class.outer'] = 'V', -- blockwise
        ['@conditional.outer'] = 'v',
        ['@conditional.inner'] = 'v',
      },
      -- If you set this to `true` (default is `false`) then any textobject is
      -- extended to include preceding or succeeding whitespace. Succeeding
      -- whitespace has priority in order to act similarly to eg the built-in
      -- `ap`.
      --
      -- Can also be a function which gets passed a table with the keys
      -- * query_string: eg '@function.inner'
      -- * selection_mode: eg 'v'
      -- and should return true or false
      include_surrounding_whitespace = false,
    },

    swap = {
      enable = true,
      swap_next = {
        ["<leader>a"] = "@parameter.inner",
      },
      swap_previous = {
        ["<leader>A"] = "@parameter.inner",
      },
    },

    move = {
      enable = true,
      set_jumps = true, -- whether to set jumps in the jumplist
      goto_next_start = {
        ["]m"] = "@function.outer",
        ["]]"] = { query = "@class.outer", desc = "Next class start" },
        --
        -- You can use regex matching (i.e. lua pattern) and/or pass a list in a "query" key to group multiple queries.
        ["]o"] = "@loop.*",
        -- ["]o"] = { query = { "@loop.inner", "@loop.outer" } }
        --
        -- You can pass a query group to use query from `queries/<lang>/<query_group>.scm file in your runtime path.
        -- Below example nvim-treesitter's `locals.scm` and `folds.scm`. They also provide highlights.scm and indent.scm.
        ["]l"] = { query = "@scope", query_group = "locals", desc = "Next scope" },
        ["]z"] = { query = "@fold", query_group = "folds", desc = "Next fold" },
      },
      goto_next_end = {
        ["]M"] = "@function.outer",
        ["]["] = "@class.outer",
      },
      goto_previous_start = {
        ["[m"] = "@function.outer",
        ["[["] = "@class.outer",
      },
      goto_previous_end = {
        ["[M"] = "@function.outer",
        ["[]"] = "@class.outer",
      },
      -- Below will go to either the start or the end, whichever is closer.
      -- Use if you want more granular movements
      -- Make it even more gradual by adding multiple queries and regex.
      goto_next = {
        ["]d"] = "@conditional.outer",
      },
      goto_previous = {
        ["[d"] = "@conditional.outer",
      }
    },

    lsp_interop = {
      enable = true,
      border = 'none',
      floating_preview_opts = {},
      peek_definition_code = {
        ["<leader>df"] = "@function.outer",
        ["<leader>dF"] = "@class.outer",
      },
    },
  },
}

require'treesitter-context'.setup{
  enable = true, -- Enable this plugin (Can be enabled/disabled later via commands)
  max_lines = 0, -- How many lines the window should span. Values <= 0 mean no limit.
  min_window_height = 0, -- Minimum editor window height to enable context. Values <= 0 mean no limit.
  line_numbers = true,
  multiline_threshold = 2, -- Maximum number of lines to show for a single context
  trim_scope = 'outer', -- Which context lines to discard if `max_lines` is exceeded. Choices: 'inner', 'outer'
  mode = 'cursor',  -- Line used to calculate context. Choices: 'cursor', 'topline'
  -- Separator between context and content. Should be a single character string, like '-'.
  -- When separator is set, the context will only show up when there are at least 2 lines above cursorline.
  separator = nil,
  zindex = 20, -- The Z-index of the context window
  on_attach = nil, -- (fun(buf: integer): boolean) return false to disable attaching 
}

vim.api.nvim_create_autocmd({"BufReadPost", "BufNewFile"}, {
    pattern = "*",
    callback = function()
        vim.cmd('set syntax=mine')
    end
})

-- Debugging

local function split_arguments(input)
    local result = {}
    local current = ""
    local in_quotes = false

    for i = 1, #input do
        local char = input:sub(i, i)

        if char == '"' then
            in_quotes = not in_quotes -- toggle the in_quotes flag
        elseif char == ' ' and not in_quotes then
            if #current > 0 then
                table.insert(result, current)
                current = ""
            end
        else
            current = current .. char
        end
    end

    if #current > 0 then
        table.insert(result, current)
    end

    return result
end

local dapui = require("dapui")
dapui.setup()
local dap = require("dap")
dap.adapters.cppdbg = {
  id = 'cppdbg',
  type = 'executable',
  command = '/home/emilys/.vscode/extensions/ms-vscode.cpptools-1.21.6-linux-x64/debugAdapters/bin/OpenDebugAD7',
}

dap.adapters.python = {
    type = 'executable';
    command = "/usr/local/python-3.7.4-static/bin/python3";
    args = { '-m', 'debugpy.adapter' };
}

dap.configurations.cpp = {
  {
    name = "Launch file",
    type = "cppdbg",
    request = "launch",
    program = function()
      return vim.fn.input('Path to executable: ', vim.fn.getcwd() .. '/', 'file')
    end,
    cwd = '${workspaceFolder}',
    stopAtEntry = true,
    setupCommands = {
      {
         text = '-enable-pretty-printing',
         description =  'enable pretty printing',
         ignoreFailures = false
      },
    },
  },
  {
    name = "Launch file with args",
    type = "cppdbg",
    request = "launch",
    program = function()
      return vim.fn.input('Path to executable: ', vim.fn.getcwd() .. '/', 'file')
    end,
    cwd = '${workspaceFolder}',
    stopAtEntry = false,
    setupCommands = {
      {
         text = '-enable-pretty-printing',
         description =  'enable pretty printing',
         ignoreFailures = false
      },
    },
    args = function ()
      return split_arguments(vim.fn.input('Arguments: '))
    end
  },
  {
    name = 'Attach to gdbserver :1234',
    type = 'cppdbg',
    request = 'launch',
    MIMode = 'gdb',
    miDebuggerServerAddress = 'localhost:1234',
    miDebuggerPath = '/usr/bin/gdb',
    cwd = '${workspaceFolder}',
    program = function()
      return vim.fn.input('Path to executable: ', vim.fn.getcwd() .. '/', 'file')
    end,
    setupCommands = {
      {
         text = '-enable-pretty-printing',
         description =  'enable pretty printing',
         ignoreFailures = false
      },
    },
  },

}


dap.configurations.python = {
    {
      name = 'Python: Remote Attach',
      type = 'python',
      request = 'attach',
      connect = {
          host = 'localhost',
          port = 4444,
      },
      cwd = vim.fn.getcwd(),
      pathMappings = {
          {
              localRoot = function()
                  return vim.fn.input("Local code folder > ", vim.fn.getcwd(), "file")
              end,
              remoteRoot = function()
                  return vim.fn.input("Container code folder > ", "/", "file")
              end,
          },
      },
      justMyCode = true,
    },
    {
      name = "Launch file with args",
      type = "python",
      python = "/usr/local/python-3.7.4-static/bin/python3",
      request = "launch",
      cwd = '${workspaceFolder}',
      program = function()
        return vim.fn.input('Path to executable: ', vim.fn.getcwd() .. '/', 'file')
      end,
      stopAtEntry = true,
      args = function ()
        return split_arguments(vim.fn.input('Arguments: '))
      end
    },
}

require("telescope").setup({
  defaults = {
    mappings = {
      n = {
        ["d"] = require("telescope.actions").delete_buffer,
        ["q"] = require("telescope.actions").close,
      }
    }
  }
})

require("telescope").load_extension "pomodori"

vim.keymap.set("n", "<leader>pm", function()
  require("telescope").extensions.pomodori.timers()
end, { desc = "Manage Pomodori Timers"})

require("notify").setup({
  background_colour = "#1a1b26",
})

require("luasnip.loaders.from_vscode").lazy_load {
	paths = { vim.fn.stdpath("config") .. "/snippets" },
}
