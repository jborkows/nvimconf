local log_file_path = os.getenv("HOME") .. '/logs/window_open_file_test_1.log'
local init_log = function()
	local log_file_creation, err = io.open(log_file_path, "w")
	if not log_file_creation then
		error("Cannot opern file" .. err)
	end
	log_file_creation:write("Hello" .. "\n")
	log_file_creation:close()
end
init_log()
local log = function(message)
	local log_file = io.open(log_file_path, "a")
	if not log_file then
		error("Cannot open file")
	end
	log_file:write(message .. "\n")
	log_file:close()
end
local test_function_query_string = [[
(
(function_declaration
name: (identifier) @name
parameters:
	(parameter_list
	(parameter_declaration
	    name: (identifier)
		type: (pointer_type
				(qualified_type
				package: (package_identifier) @_package_name
				name: (type_identifier) @_type_name
		    	)
		)
		)
	)
)
(#eq? @_package_name "testing")
(#eq? @_type_name "T")
(#eq? @name "%s")
)
]]

local find_test_line = function(go_bufnr, name)
	local fomatted = string.format(test_function_query_string, name)
	local query = vim.treesitter.parse_query("go", fomatted)
	local parser = vim.treesitter.get_parser(go_bufnr, "go", {})
	local tree = parser:parse()[1]
	local root = tree:root()
	for id, node in query:iter_captures(root, go_bufnr, 0, -1) do
		if id == 1 then
			local range = { node:range() }
			return range[1]
		end
	end
end

local make_key = function(entry)
	-- vim inspect show human readable object
	assert(entry.Package, "Must have package:" .. vim.inspect(entry))
	assert(entry.Test, "Must have test: " .. vim.inspect(entry))
	return string.format("%s/%s", entry.Package, entry.Test)
end

local add_golang_test = function(state, entry)
	local line = find_test_line(state.bufnr, entry.Test)
	local key = make_key(entry)
	state.tests[key] = {
		name = entry.Test,
		line = line,
		output = {}
	}
end

local add_golang_output = function(state, entry)
	assert(state.tests, vim.inspect(state))
	-- in this mode instert trim value as last in table state.tests[key]
	-- vim.trim <- trims
	table.insert(state.tests[make_key(entry)].output, vim.trim(entry.Output))
end

local mark_success = function(state, entry)
	state.tests[make_key(entry)].success = entry.Action == "pass"
end

local ns = vim.api.nvim_create_namespace "live-tests"
local group = vim.api.nvim_create_augroup("jb-go-test", { clear = true })

function myerrorhandler(err)
	log("ERROR:" .. err)
end

local attach_to_buffer = function(bufnr, command)

	vim.api.nvim_create_autocmd("BufWritePost", {
		group = group,
		pattern = "*.go",
		callback = function()

			vim.api.nvim_buf_clear_namespace(bufnr, ns, 0, -1)

			state = {
				bufnr = bufnr,
				tests = {}
			}

			vim.api.nvim_buf_create_user_command(bufnr, "MyGoTestLineDialog", function()
				local line = vim.fn.line "." - 1
				for _, test in pairs(state.tests) do
					if (test.line == line) then
						vim.cmd.new()
						vim.api.nvim_buf_set_lines(vim.api.nvim_get_current_buf(), 0, -1, false, test.output)
					end
				end
			end, {})
			log("Executing tests... ")
			local notificationTitle = "Running tests"
			local notify = require("notify").notify
			notify("Executing...", vim.log.levels.INFO, {
				title = notificationTitle,
			})
			vim.fn.jobstart(command, {
				stdout_buffered = true,
				on_stderr = function(_, data)
				end,
				on_stdout = function(_, data)
					if not data then
						return
					end -- if data are present append lines starting from end of file (-1) to end of file (-1)
					for _, line in ipairs(data) do
						log("Receiving:'" .. line .. "'");
						if not line or line == '' then
							-- nop
						else
							log("Decoding...")
							local decoded = vim.json.decode(line)
							if not decoded.Test then
								log("Cannot use " .. vim.inspect(decoded))
							elseif decoded.Action == "run" then
								add_golang_test(state, decoded)
							elseif decoded.Action == "output" then
								add_golang_output(state, decoded)
							elseif decoded.Action == "pass" or decoded.Action == "fail" then
								mark_success(state, decoded)
								local test = state.tests[make_key(decoded)]
								if test.success and test.line then
									local text = { '✔️' }
									log("Setting success for " .. vim.inspect(test))
									xpcall(function() vim.api.nvim_buf_set_extmark(bufnr, ns, test.line, 0, { virt_text = { text } }) end,
										myerrorhandler)
								end
							elseif decoded.Action == "pause" then
								-- nop
							elseif decoded.Action == "cont" then
								-- nop
							else
								log("Failed to handle " .. decoded.Action)
								error("Failed to handle" .. decoded.Action)
							end
						end

					end
				end,
				on_exit = function()
					local failed = {}
					log("Executing tests finished")
					for _, test in pairs(state.tests) do
						if test.line then
							if not test.success then
								table.insert(failed, {
									bufnr = bufnr,
									lnum = test.line,
									col = 0,
									severity = vim.diagnostic.severity.ERROR,
									source = "my-go-test",
									message = "Test failed",
									user_data = {}
								})
							end
						end
					end
					vim.diagnostic.set(ns, bufnr, failed, {})

					if next(failed) then
						notify("There are test failures", vim.log.levels.WARN, {
							title = notificationTitle,
							icon = "🚨"
						})
					else
						notify("All tests pass", vim.log.levels.INFO, {
							title = notificationTitle,
							icon = "😎"
						})
					end

				end
			})
		end
	})
end


vim.api.nvim_create_user_command(
	"MyGoTestOnSave",
	function()
		attach_to_buffer(vim.api.nvim_get_current_buf(), { "go", "test", "-v", "./...", "-json" })
	end,
	{}
)
