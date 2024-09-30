require "nvchad.mappings"

-- add yours here

local map = vim.keymap.set
local delete = vim.keymap.del

-- set up buffer navigation
delete('n', '<tab>')
delete('n', '<leader>fb')
delete('n', '<leader>x')
map('n', '<leader>fb', '<cmd>Telescope buffers sort_mru=true initial_mode=normal<CR>')

map('n', '<leader>tt', function ()
    require('base46').toggle_transparency()
end, { desc = "Toggle transparency "})

map("n", ";", ":", { desc = "CMD enter command mode" })
map("n", "<leader>ww", "<cmd>set wrap!<cr>",{ desc = "Toggle wrap" })
map("v", ".", ":normal .<cr>",{ desc = "Repeat over lines" , noremap = true})

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


-- leap (hop replacement)
local leap = require('leap')
map({'n', 'x', 'o'}, 's',  '<Plug>(leap-forward)')
map({'n', 'x', 'o'}, 'S',  '<Plug>(leap-backward)')
leap.opts.equivalence_classes = { ' \t\r\n', '([{', ')]}', '\'"`' }
require('leap.user').set_repeat_keys('<enter>', '<backspace>')
leap.opts.preview_filter = function () return false end
-- vim.api.nvim_set_hl(0, 'LeapBackdrop', { link = 'Comment' })

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

vim.keymap.set('', '<leader><leader>x', function()
  harp_u.nav_file(1)
end, { desc = 'Harpoon to file 1' })
vim.keymap.set('', '<leader><leader>c', function()
  harp_u.nav_file(2)
end, { desc = 'Harpoon to file 2' })
vim.keymap.set('', '<leader><leader>d', function()
  harp_u.nav_file(3)
end, { desc = 'Harpoon to file 3' })
vim.keymap.set('', '<leader><leader>r', function()
  harp_u.nav_file(4)
end, { desc = 'Harpoon to file 4' })

require('telescope').load_extension('harpoon')
map('', '<leader><leader>t', '<cmd>Telescope harpoon marks<cr>',
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

-- debugging with nvim-dap and nvim-dap-ui
-- Automatically run dapui when dap session is up
local dap, dapui = require("dap"), require("dapui")
map('n', '<leader>dd', function() dapui.toggle() end, {desc="Toggle debug mode"})

map('n', '<F5>', function() dap.continue() end, {desc="Debug continue"})
map('n', '<F10>', function() dap.step_over() end, {desc="Debug step over"})
map('n', '<F11>', function() dap.step_into() end, {desc="Debug step into"})
map('n', '<F12>', function() dap.step_out() end, {desc="Debug step out"})
map('n', '<Leader>db', function() dap.toggle_breakpoint() end, {desc="Toggle breakpoint"})
map('n', '<Leader>dl', function() dap.set_breakpoint(nil, nil, vim.fn.input('Log point message: ')) end, {desc="Set breakpoint with log"})
map('n', '<Leader>dr', function() dap.repl.open() end, {desc="Debug open repl"})
map('n', '<Leader>dl', function() dap.run_last() end, {desc="Debug run last"})
vim.keymap.set({'n', 'v'}, '<Leader>dh', function()
  require('dap.ui.widgets').hover()
end, {desc="Debug hover"})
vim.keymap.set({'n', 'v'}, '<Leader>dv', function()
  require('dap.ui.widgets').preview()
end, {desc="Debug preview"})


-- python dap
local dappy = require('dap-python')
map('x', '<leader>dps', function()
  dappy.debug_selection()
end, { desc="Debug python selection" })
map('n', '<leader>dpc', function()
  dappy.test_class()
end, { desc="Debug python class" })
map('n', '<leader>dpf', function()
  dappy.test_function()
end, { desc="Debug python function" })

-- pomo.nvim
map('n', '<leader>pp', '<cmd>TimerSession pomodoro<CR>')
map('n', '<leader>pr', '<cmd>TimerResume<CR>')
map('n', '<leader>pe', '<cmd>TimerPause<CR>')
map('n', '<leader>ps', '<cmd>TimerShow<CR>')
map('n', '<leader>ph', '<cmd>TimerHide<CR>')
map('n', '<leader>pE', '<cmd>TimerStop<CR>')

