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

function display_data(data, output_bufnr)
	if data then
		vim.api.nvim_buf_set_lines(output_bufnr, -1, -1, false, data)
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

local attach_to_buffer = function(output_bufnr, pattern, command)
	vim.api.nvim_create_autocmd("BufWritePost", {
		group = command_group,
		pattern = pattern,
		callback = function()
			vim.api.nvim_buf_set_lines(output_bufnr, 0, -1, false, {
				"output of: main.go"
			})
			vim.fn.jobstart(command, {
				stdout_buffered = true,
				on_stdout = function(_, data)
					-- if data are present append lines starting from end of file (-1) to end of file (-1)
					display_data(data, output_bufnr)
				end,
				on_stderr = function(_, data)
					display_data(data, output_bufnr)
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
end

--attach_to_buffer(17, "*.go", { "go", "run", "main.go" })


vim.api.nvim_create_user_command("MyCustomCommand", function()
	print "My custom command here..."
	local bufnr = tonumber(vim.fn.input("Bufnra to attach: "))
	local pattern = vim.fn.input "Pattern: "
	local command = vim.split(vim.fn.input "Command: ", " ")
	print("Using ", bufnr, " pattern ", pattern, " command '", command, "'")
	attach_to_buffer(bufnr, pattern, command)
end, {})
