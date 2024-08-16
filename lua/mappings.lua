require "nvchad.mappings"

-- add yours here

local map = vim.keymap.set

map("n", ";", ":", { desc = "CMD enter command mode" })
map("i", "jk", "<ESC>")

-- map({ "n", "i", "v" }, "<C-s>", "<cmd> w <cr>")




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
harp_m = require('harpoon.mark')
harp_u = require('harpoon.ui')
map('n', '<leader><leader>a', function()
  harp_m.add_file()
end, {desc="harpoon add mark"})

map('n', '<leader><leader>m', function()
  harp_u.toggle_quick_menu()
end, {desc="harpoon show marks"})
