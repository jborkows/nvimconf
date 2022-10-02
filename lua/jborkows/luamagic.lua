-- to get current buffer number
-- :echo nvim_get_current_buf()

local buffnr = 14
function displayHelloWorld()
	-- put always text from start 0 to end of file (-1)
	vim.api.nvim_buf_set_lines(buffnr, 0, -1, false, {
		"Hello",
		"world",
		"2020",
	})
end

--displayHelloWorld()
local command_group = vim.api.nvim_create_augroup("automagic-jb", {
	clear = true,
})

function display_data(data)
	if data then
		vim.api.nvim_buf_set_lines(buffnr, -1, -1, false, data)
	end

end

function trim(s)
	return (s:gsub("^%s*(.-)%s*$", "%1"))
end

function print_data_as_text(data)
	s = ""
	for _, v in pairs(data) do
		s = s .. v .. " "
	end
	return trim(s)
end

vim.api.nvim_create_autocmd("BufWritePost", {
	group = command_group,
	pattern = "main.go",
	callback = function()
		vim.api.nvim_buf_set_lines(buffnr, 0, -1, false, {
			"output of: main.go"
		})
		vim.fn.jobstart({ "go", "run", "main.go" }, {
			stdout_buffered = true,
			on_stdout = function(_, data)
				-- if data are present append lines starting from end of file (-1) to end of file (-1)
				display_data(data)
			end,
			on_stderr = function(_, data)
				display_data(data)
				local text = print_data_as_text(data)
				if text and text ~= '' then
					require("notify").notify({
						"Some problem",
						print_data_as_text(data)
					}, "error", {
						title = "Error",
						icon = ""


					})
				end
			end
		})
	end,
})
