vim.api.nvim_create_autocmd({ 'BufWritePost' }, {
	pattern = '*spec.lua',
	group = vim.api.nvim_create_augroup('plenary-tests', { clear = true }),

	callback = function()
		vim.cmd.PlenaryBustedFile(vim.fn.expand '%')
	end,
})
