require('dap.ext.vscode').load_launchjs()

-- dap = require('dap')
-- dap.adapters.codelldb = {
--   type = 'server',
--   port = "17000",
--   executable = {
--     -- CHANGE THIS to your path!
--     command =  '~/.local/share/nvim/mason/bin/codelldb',
--     args = {"--port", "17000"},

--     -- On windows you may have to uncomment this:
--     -- detached = false,
--   }
-- }
-- -- dap.adapters.lldb = {
-- -- 	type = 'executable',
-- -- 	command = '~/.local/share/nvim/mason/bin/codelldb', -- adjust as needed, must be absolute path
-- -- 	name = 'lldb'
-- -- }
-- dap.configurations.cpp = {
--   {
--     name = "Launch file",
--     type = "codelldb",
--     request = "launch",
--     program = function()
--       return vim.fn.input('Path to executable: ', vim.fn.getcwd() .. '/', 'file')
--     end,
--     cwd = '${workspaceFolder}',
--     stopOnEntry = false,
--   },
-- }
-- dap.configurations.rust = dap.configurations.cpp 
