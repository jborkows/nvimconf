print("Telescope")
require("telescope").setup {
	extensions = {
		emoji = {
			action = function(emoji)
				-- argument emoji is a table.
				-- {name="", value="", cagegory="", description=""}
				print("I am called")
				local pos = vim.api.nvim_win_get_cursor(0)
				local posX = pos[2]
				local line = vim.api.nvim_get_current_line()
				local nline = line:sub(0, posX) .. emoji.value .. line:sub(posX + 1)
				vim.api.nvim_set_current_line(nline)
				vim.api.nvim_win_set_cursor(0, { pos[1], pos[2] + 1 })
				vim.api.nvim_feedkeys("a", "i", true)
				-- insert emoji when picked
				-- vim.api.nvim_put({ emoji.value }, 'c', false, true)
			end,
		}
	},
}

require("telescope").load_extension("emoji")
