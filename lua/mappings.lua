require "nvchad.mappings"

-- add yours here

local map = vim.keymap.set

map("n", ";", ":", { desc = "CMD enter command mode" })

-- map({ "n", "i", "v" }, "<C-s>", "<cmd> w <cr>")
-- mine
map('n', '<leader>st', function ()
  local active_clients = vim.lsp.get_clients()
  if next(active_clients) == nil then
    vim.cmd('LspStart')
    print('LSP Started')
  else
    vim.cmd('LspStop')
    print('LSP Stopped')
  end
end, { desc="Toggle LSP" })

-- hop (easymotions)
local hop = require('hop')
hop.setup()

map('', '<leader><leader>s', function()
	hop.hint_char1()
end, {remap=true, desc="hop char1"})

map('', '<leader><leader>w', function()
	hop.hint_words()
end, {remap=true, desc="hop words"})

-- harpoon
local harp_m = require('harpoon.mark')
local harp_u = require('harpoon.ui')

map('n', '<leader><leader>a', function()
  harp_m.add_file()
end, {desc="harpoon add mark"})

map('n', '<leader><leader>m', function()
  harp_u.toggle_quick_menu()
end, {desc="harpoon show marks"})

map('', '<leader><leader>n', function()
  harp_u.nav_next()
end, {desc='harpoon next mark'})

map('', '<leader><leader>p', function()
  harp_u.nav_prev()
end, {desc='harpoon next mark'})

require('telescope').load_extension('harpoon')
map('', '<leader>fp', '<cmd>Telescope harpoon marks<cr>',
  {desc='Telescope harpoon marks'})

map('', '<leader>sf', '<cmd>Telescope lsp_document_symbols symbols=method,function<cr>',
  {desc='Telescope list methods/functions'})

-- tmux navigator

map('', '<C-Left>', '<cmd>TmuxNavigateLeft<cr>', {remap=true, desc="Tmux window left"})
map('', '<C-Up>', '<cmd>TmuxNavigateUp<cr>', {remap=true, desc="Tmux window up"})
map('', '<C-Down>', '<cmd>TmuxNavigateDown<cr>', {remap=true, desc="Tmux window down"})
map('', '<C-Right>', '<cmd>TmuxNavigateRight<cr>', {remap=true, desc="Tmux window right"})

-- treesitter textobjects (more in options.lua)
local ts_repeat_move = require "nvim-treesitter.textobjects.repeatable_move"

-- Repeat movement with ; and ,
-- ensure ; goes forward and , goes backward regardless of the last direction
-- map({ "n", "x", "o" }, ";", ts_repeat_move.repeat_last_move_next)
-- map({ "n", "x", "o" }, ",", ts_repeat_move.repeat_last_move_previous)

-- vim way: ; goes to the direction you were moving.
map({ "n", "x", "o" }, ";", ts_repeat_move.repeat_last_move_opposite)
map({ "n", "x", "o" }, ",", ts_repeat_move.repeat_last_move)

-- Optionally, make builtin f, F, t, T also repeatable with ; and ,
map({ "n", "x", "o" }, "f", ts_repeat_move.builtin_f_expr, { expr = true })
map({ "n", "x", "o" }, "F", ts_repeat_move.builtin_F_expr, { expr = true })
map({ "n", "x", "o" }, "t", ts_repeat_move.builtin_t_expr, { expr = true })
map({ "n", "x", "o" }, "T", ts_repeat_move.builtin_T_expr, { expr = true })


-- treesitter context (breadcrumbs)
map('n', '<leader>sc', '<cmd>TSContextToggle<cr>', {desc='Enable breadcrumbs'})
