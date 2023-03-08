-- Remaps for the refactoring operations currently offered by the plugin
vim.api.nvim_set_keymap("v", "<leader>ef", [[ <Esc><Cmd>lua require('refactoring').refactor('Extract Function')<CR>]],
	{ noremap = true, silent = true, expr = false })
vim.api.nvim_set_keymap("v", "<leader>eff",
	[[ <Esc><Cmd>lua require('refactoring').refactor('Extract Function To File')<CR>]],
	{ noremap = true, silent = true, expr = false })
vim.api.nvim_set_keymap("v", "<leader>ev", [[ <Esc><Cmd>lua require('refactoring').refactor('Extract Variable')<CR>]],
	{ noremap = true, silent = true, expr = false })
vim.api.nvim_set_keymap("v", "<leader>ri", [[ <Esc><Cmd>lua require('refactoring').refactor('Inline Variable')<CR>]],
	{ noremap = true, silent = true, expr = false })

-- Extract block doesn't need visual mode
vim.api.nvim_set_keymap("n", "<leader>eb", [[ <Cmd>lua require('refactoring').refactor('Extract Block')<CR>]],
	{ noremap = true, silent = true, expr = false })
vim.api.nvim_set_keymap("n", "<leader>ebf", [[ <Cmd>lua require('refactoring').refactor('Extract Block To File')<CR>]],
	{ noremap = true, silent = true, expr = false })

-- Inline variable can also pick up the identifier currently under the cursor without visual mode
vim.api.nvim_set_keymap("n", "<leader>ri", [[ <Cmd>lua require('refactoring').refactor('Inline Variable')<CR>]],
	{ noremap = true, silent = true, expr = false })

require("telescope").load_extension("refactoring")

-- remap to open the Telescope refactoring menu in visual mode
vim.api.nvim_set_keymap(
	"v",
	"<leader>rr",
	"<Esc><cmd>lua require('telescope').extensions.refactoring.refactors()<CR>",
	{ noremap = true }
)

require('refactoring').setup({
	-- prompt for return type
	prompt_func_return_type = {
		go = true,
		cpp = true,
		c = true,
		java = true,
	},
	-- prompt for function parameters
	prompt_func_param_type = {
		go = true,
		cpp = true,
		c = true,
		java = true,
	},
})
