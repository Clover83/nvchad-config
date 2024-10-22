require "nvchad.mappings"

-- add yours here

local map = vim.keymap.set
local delete = vim.keymap.del

-- set up buffer navigation
delete('n', '<tab>')
delete('n', '<leader>fb')
delete('n', '<leader>x')
map('n', '<leader>fb', '<cmd>Telescope buffers sort_mru=true<CR>')

map('n', '<leader>tt', function ()
    require('base46').toggle_transparency()
end, { desc = "Toggle transparency "})

map("n", ";", ":", { desc = "CMD enter command mode" })
map("n", "<leader>ww", "<cmd>set wrap!<cr>",{ desc = "Toggle wrap" })
map("v", ".", ":normal .<cr>",{ desc = "Repeat over lines" , noremap = true})
map("n", "<leader>fn", ":cn<cr>",{ desc = "Quickfix next" , noremap = true})
map("n", "<leader>fp", ":cp<cr>",{ desc = "Quickfix previous" , noremap = true})

map('n', '<leader>st', function (global)
	local vars, bufnr, cmd
	if global then
		vars = vim.g
		bufnr = nil
	else
		vars = vim.b
		bufnr = 0
	end
	vars.diagnostics_disabled = not vars.diagnostics_disabled
	if vars.diagnostics_disabled then
		cmd = 'disable'
		vim.api.nvim_echo({ { 'Disabled diagnostics' } }, false, {})
	else
		cmd = 'enable'
		vim.api.nvim_echo({ { 'Enabled diagnostics' } }, false, {})
	end
	vim.schedule(function() vim.diagnostic[cmd](bufnr) end)
end, { desc = "Toggle diagnostics" })


-- leap (hop replacement)
local leap = require('leap')
map({'n', 'x', 'o'}, '-',  '<Plug>(leap-forward)')
map({'n', 'x', 'o'}, '_',  '<Plug>(leap-backward)')
leap.opts.equivalence_classes = { ' \t\r\n', '([{', ')]}', '\'"`' }
-- require('leap.user').set_repeat_keys('<enter>', '<backspace>')
leap.opts.preview_filter = function () return false end
-- vim.api.nvim_set_hl(0, 'LeapBackdrop', { link = 'Comment' })

-- harpoon & yeet
local harp = require('harpoon')
local yeet = require('yeet')
harp:setup({
  yeet = {
    select = function(list_item, _, _)
      require('yeet').execute(list_item.value)
    end
  }
})
map('n', '<leader>ym', function()
  harp.ui:toggle_quick_menu(harp:list("yeet"))
end, { desc="Open yeet harpoon menu"})

map('n', '<leader>yt', function ()
  yeet.select_target()
end, { desc="Select yeet target"})

map('n', '<leader>ya', function ()
  yeet.toggle_post_write()
end, { desc="Toggle autocommand on write"})

-- Doubletap \ to yeet
map('n', '\\\\', function ()
  yeet.execute()
end, { desc="Yeet"})

-- Run command without clearing term
map('n', '<leader>\\', function ()
  require("yeet").execute(nil, { clear_before_yeet = false, interrupt_before_yeet = true })
end, { desc="Yeet without clearing"})

-- Harpoon
map('n', '<leader><leader>a', function()
  harp:list():add()
end, {desc="harpoon add mark"})

map('n', '<leader><leader>m', function()
  harp.ui:toggle_quick_menu(harp:list())
end, {desc="harpoon show marks"})

map('', '<leader><leader>n', function()
  harp:list():next()
end, {desc='harpoon next mark'})

map('', '<leader><leader>p', function()
  harp:list():prev()
end, {desc='harpoon prev mark'})

vim.keymap.set('', '<leader><leader>x', function()
  harp:list():select(1)
end, { desc = 'Harpoon to file 1' })
vim.keymap.set('', '<leader><leader>c', function()
  harp:list():select(2)
end, { desc = 'Harpoon to file 2' })
vim.keymap.set('', '<leader><leader>d', function()
  harp:list():select(3)
end, { desc = 'Harpoon to file 3' })
vim.keymap.set('', '<leader><leader>r', function()
  harp:list():select(4)
end, { desc = 'Harpoon to file 4' })

-- telescope
local tel_conf = require("telescope.config").values
local function toggle_telescope(harpoon_files)
    local file_paths = {}
    for _, item in ipairs(harpoon_files.items) do
        table.insert(file_paths, item.value)
    end

    require("telescope.pickers").new({}, {
        prompt_title = "Harpoon",
        finder = require("telescope.finders").new_table({
            results = file_paths,
        }),
        previewer = tel_conf.file_previewer({}),
        sorter = tel_conf.generic_sorter({}),
    }):find()
end

vim.keymap.set("n", "<leader><leader>t", function() toggle_telescope(harp:list()) end,
    { desc = "Open harpoon window" })

map('', '<leader>sf', '<cmd>Telescope lsp_document_symbols symbols=method,function<cr>',
  {desc='Telescope list methods/functions'})

map('', '<leader>sr', '<cmd>Telescope lsp_references<cr>',
  {desc='Telescope list references'})

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

-- scissors snippets
vim.keymap.set("n", "<leader>se", function() require("scissors").editSnippet() end, { desc = "Edit snippets"})
-- when used in visual mode, prefills the selection as snippet body
vim.keymap.set({ "n", "x" }, "<leader>sa", function() require("scissors").addNewSnippet() end, { desc = "Add snippet"})

-- substitute 
map("n", "s", require('substitute').operator,
  { noremap = true, desc = "substitute"} )
map("n", "ss", require('substitute').line,
  { noremap = true, desc = "substitute line"})
map("n", "S", require('substitute').eol,
  { noremap = true, desc = "substitute eol"})
map("x", "s", require('substitute').visual,
  { noremap = true, desc = "substitute"})

map("n", "<leader>S", require('substitute.range').operator,
  { noremap = true, desc = "substitute range"})
map("x", "<leader>S", require('substitute.range').visual,
  { noremap = true, desc = "substitute range"})
map("n", "<leader>SS", require('substitute.range').word,
  { noremap = true, desc = "substitute range word"})

map("n", "sx", require('substitute.exchange').operator,
  { noremap = true, desc = "exchange"})
map("n", "sxx", require('substitute.exchange').line,
  { noremap = true, desc = "exchange line"})
map("x", "X", require('substitute.exchange').visual,
  { noremap = true, desc = "exchange"})
map("n", "sxc", require('substitute.exchange').cancel,
  { noremap = true, desc = "cancel exchange"})

-- smooth scrolling with neoscroll
local neoscroll = require('neoscroll')
local keymap = {
  ["<C-u>"] = function() neoscroll.ctrl_u({ duration = 150 }) end;
  ["<C-d>"] = function() neoscroll.ctrl_d({ duration = 150 }) end;
  ["<C-b>"] = function() neoscroll.ctrl_b({ duration = 250 }) end;
  ["<C-f>"] = function() neoscroll.ctrl_f({ duration = 250 }) end;
  ["<C-y>"] = function() neoscroll.scroll(-0.1, { move_cursor=false; duration = 100 }) end;
  ["<C-e>"] = function() neoscroll.scroll(0.1, { move_cursor=false; duration = 100 }) end;
  ["<PageUp>"] = function() neoscroll.ctrl_b({ duration = 250 }) end;
  ["<PageDown>"] = function() neoscroll.ctrl_f({ duration = 250 }) end;
}
local modes = { 'n', 'v', 'x' }
for key, func in pairs(keymap) do
  map(modes, key, func)
end
