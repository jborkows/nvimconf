local rt = require("rust-tools")
local dap = require('dap')

local path = vim.fn.glob(vim.fn.stdpath("data") .. "/mason/packages/codelldb/extension/") or ""
local codelldb_path = path .. "adapter/codelldb"
local liblldb_path = path .. "lldb/lib/liblldb.so"
rt.setup({
	dap = {
		adapter = require("rust-tools.dap").get_codelldb_adapter(codelldb_path, liblldb_path),
	},
	server = {
		capabilities = require("cmp_nvim_lsp").default_capabilities(),
		on_attach = function(_, bufnr)
			print("Attaching rust")
			vim.keymap.set("n", "<C-space>", rt.hover_actions.hover_actions, { buffer = bufnr })
			vim.keymap.set("n", "<Leader>sa", rt.code_action_group.code_action_group, { buffer = bufnr })
			vim.keymap.set('n', "<leader>b", dap.toggle_breakpoint, { buffer = bufnr })
		end,
	},
	tools = {
		hover_actions = {
			auto_focus = true,
		},
	},
})
-- either enable this + start server (or start it automaticaly here)
-- then RustRunnables will not workspaceFolder
-- or go to rust-tools.dap and replace in two lines get_codelldb_adapter and rt_lldb with codelldb
-- remember that require("dapui").toggle() opens more interactive window
-- and DapContinue is importatent
--
--
--
--
-- dap.adapters.codelldb = {
-- 	type = 'server',
-- 	host = '127.0.0.1',
-- 	port = 13000 -- 💀 Use the port printed out or specified with `--port`
-- }

-- dap.configurations.cpp = {
-- 	{
-- 		name = "Launch file",
-- 		type = "codelldb",
-- 		request = "launch",
-- 		program = function()
-- 			return vim.fn.input('Path to executable: ', vim.fn.getcwd() .. '/', 'file')
-- 		end,
-- 		cwd = '${workspaceFolder}',
-- 		stopOnEntry = false,
-- 	},
-- }


-- dap.configurations.c = dap.configurations.cpp
-- dap.configurations.rust = dap.configurations.cpp
