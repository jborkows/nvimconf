require('lint').linters_by_ft = {
	go = { 'golangcilint' },
}
vim.api.nvim_create_autocmd({ 'BufWritePost', 'BufEnter', 'InsertLeave' }, {
	pattern = { '*.go' },
	callback = function()
		require('lint').try_lint()
	end,
})
