local mark = require("harpoon.mark")
local ui = require("harpoon.ui")

vim.keymap.set('n', "<leader>a", function() mark.add_file() end)
vim.keymap.set("n", "<C-e>", function() ui.toggle_quick_menu() end)
vim.keymap.set("n", "<A-2>", function() ui.nav_next() end)
vim.keymap.set("n", "<A-1>", function() ui.nav_prev() end)
