local mark= require("harpoon.mark")
local ui=require("harpoon.ui")

vim.keymap.set('n',"<leader>a", "<cmd>lua require('harpoon.mark').add_file()<cr>")
vim.keymap.set("n","<C-e>", "<cmd>lua require('harpoon.ui').toggle_quick_menu()<cr>")
