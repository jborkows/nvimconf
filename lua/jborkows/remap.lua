-- vim.keymap.set("n", "<leader>pv", vim.cmd.Ex) --for basic netwr
vim.keymap.set("n", "<leader>pv", require 'nvim-tree'.open)
vim.keymap.set("n", "<leader>sl", "<cmd>source %<CR>")

vim.keymap.set("n", "<leader>cl", "<cmd>belowright split <bar> resize 10 <bar> terminal<cr>A")
vim.keymap.set("n", "<leader>clv", "<cmd>vsp <bar><bar>  terminal<cr>A")
vim.keymap.set("t", "<esc>", [[<C-\><C-n>]])
local opts = { noremap = true, silent = true }
vim.keymap.set('n', '<space>?', vim.diagnostic.open_float, opts)

-- move selected code with intendations
vim.keymap.set("v", "J", ":m '>+1<CR>gv=gv")
vim.keymap.set("v", "K", ":m '<-2<CR>gv=gv")

-- append next line to current with space byt keep cursor
vim.keymap.set("n", "J", "mzJ`z")
vim.keymap.set("n", "<C-d>", "<C-d>zz")
vim.keymap.set("n", "<C-u>", "<C-u>zz")
vim.keymap.set("n", "n", "nzzzv")
vim.keymap.set("n", "N", "Nzzzv")


-- delete into "void" registry
vim.keymap.set("x", "<leader>d", [["_dP]])

-- next greatest remap ever : asbjornHaland
vim.keymap.set({ "n", "v" }, "<leader>y", [["+y]], { desc = "clipboard copy" })
vim.keymap.set("n", "<leader>Y", [["+Y]])
vim.keymap.set("n", "<leader>p", [["+P]], { desc = "clipboard paste" })

vim.keymap.set({ "n", "v" }, "<leader>d", [["_d]])

-- start replacing current word
vim.keymap.set("n", "<leader>s", [[:%s/\<<C-r><C-w>\>/<C-r><C-w>/gI<Left><Left><Left>]])
-- make file executable
vim.keymap.set("n", "<leader>x", "<cmd>!chmod +x %<CR>", { silent = true })
