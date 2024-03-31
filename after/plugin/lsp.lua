local lsp = require('lsp-zero')
-- require("neodev").setup({
-- 	-- add any options here, or leave empty to use the default settings
-- })
-- require("dapui").setup({})
lsp.preset('recommended')


lsp.ensure_installed({
	'tsserver',
	'eslint',
	'lua_ls',
	'rust_analyzer',
	"bashls",
	"gopls",
})

-- lsp.configs.javascript.formatters = {
-- 	{
-- 		exe = 'prettier',
-- 		args = { '--stdin-filepath', '%filepath' },
-- 		stdin = true,
-- 	},
-- }
-- Fix Undefined global 'vim'
-- lsp.configure('sumneko_lua', {
-- 	settings = {
-- 		Lua = {
-- 			diagnostics = {
-- 				globals = { 'vim' }
-- 			}
-- 		}
-- 	}
-- })


local cmp = require('cmp')
local cmp_select = { behavior = cmp.SelectBehavior.Select }
local cmp_mappings = lsp.defaults.cmp_mappings({
	['<C-p>'] = cmp.mapping.select_prev_item(cmp_select),
	['<C-n>'] = cmp.mapping.select_next_item(cmp_select),
	['<C-y>'] = cmp.mapping.confirm({ select = true }),
	["<C-Space>"] = cmp.mapping.complete(),
})

-- disable completion with tab
-- this helps with copilot setup
cmp_mappings['<Tab>'] = nil
cmp_mappings['<S-Tab>'] = nil

lsp.setup_nvim_cmp({
	mapping = cmp_mappings
})

lsp.set_preferences({
	suggest_lsp_servers = false,
	sign_icons = {
		error = 'E',
		warn = 'W',
		hint = 'H',
		info = 'I'
	}
})

local lspFormatting = vim.api.nvim_create_augroup("jb-lsp-group", { clear = true })
local dap = require 'dap'
local on_attach = function(client, bufnr)
	local opts = { buffer = bufnr, remap = false }

	if client.name == "eslint" then
		vim.cmd.LspStop('eslint')
		return
	end

	vim.keymap.set("n", "gd", vim.lsp.buf.definition, opts)
	vim.keymap.set("n", "gD", vim.lsp.buf.declaration, opts)
	vim.keymap.set("n", "K", vim.lsp.buf.hover, opts)
	vim.keymap.set("n", "<leader>vws", vim.lsp.buf.workspace_symbol, opts)
	vim.keymap.set("n", "<leader>od", vim.diagnostic.open_float, opts)
	vim.keymap.set("n", "<leader>td", function()
		vim.cmd.Telescope("diagnostics")
	end, opts)

	vim.keymap.set("n", "<leader>ss", function()
		vim.cmd.Telescope("lsp_document_symbols")
	end, opts)
	vim.keymap.set("n", "[", vim.diagnostic.goto_next, opts)
	vim.keymap.set("n", "]", vim.diagnostic.goto_prev, opts)
	vim.keymap.set({ "n", "v" }, "<leader>ca", vim.lsp.buf.code_action, opts)
	vim.keymap.set("n", "<leader>cf", vim.lsp.buf.format, opts)
	vim.keymap.set("n", "<leader>fu", vim.lsp.buf.references, opts)
	vim.keymap.set("n", "<leader>gi", vim.lsp.buf.implementation, opts)
	vim.keymap.set("n", "<leader>mv", vim.lsp.buf.rename, opts)
	vim.keymap.set("i", "<C-h>", vim.lsp.buf.signature_help, opts)
	vim.keymap.set('n', "<leader>b", dap.toggle_breakpoint, opts)

	vim.api.nvim_clear_autocmds({ group = lspFormatting, buffer = bufnr })
	if client.supports_method("textDocument/formatting") then
		vim.api.nvim_create_autocmd("BufWritePre", {
			group = lspFormatting,
			pattern = { "*.rs", "*.lua", "*.css", "*.dockerfile" },
			callback = function()
				vim.lsp.buf.format()
			end
		}
		);
	end
	vim.api.nvim_create_autocmd("BufWritePost", {
		group = lspFormatting,
		pattern = { "*.ts", "*.tsx", "*.js", "*.jsx", "*.cjs" },
		callback = function()
			vim.api.nvim_command('silent !prettier --write %')
		end
	})
	vim.api.nvim_create_autocmd("BufWritePre", {
		group = lspFormatting,
		pattern = { "*.go" },
		callback = function()
			vim.lsp.buf.format()
			vim.lsp.buf.code_action(
				{
					context = { only = { "source.organizeImports" } },
					apply = true
				}
			)
		end
	}
	);

	vim.api.nvim_create_autocmd("BufWritePre", {
		group = lspFormatting,
		pattern = { "*.rs" },
		callback = function()
			vim.lsp.buf.format()
		end
	}
	);
end
-- vim.api.nvim_create_autocmd("BufWritePost", {
-- 	group = lspFormatting,
-- 	pattern = { "*.xml" },
-- 	callback = function()
-- 		vim.api.nvim_command('silent %!xmllint "%" --format')
-- 		vim.api.nvim_buf_reload(vim.api.nvim_get_current_buf(), {})
-- 	end
-- })

local execute_formatting_command = function(extension, commandCreator)
	local lines = vim.api.nvim_buf_get_lines(0, 0, -1, false)
	local content = table.concat(lines, "\n")

	-- Create a temporary file
	local tmpfile = vim.fn.tempname() .. extension
	local escaped_tmpfile = vim.fn.shellescape(tmpfile)

	-- Write the buffer content to the temporary file
	local file = io.open(tmpfile, "w")
	file:write(content)
	file:close()

	local command = commandCreator(escaped_tmpfile)
	os.execute(command)

	file = io.open(tmpfile, "r")
	local modified_content = file:read("*a")
	file:close()

	vim.api.nvim_buf_set_lines(0, 0, -1, false, vim.split(modified_content, "\n"))

	-- Remove the temporary file
	os.remove(tmpfile)
end

vim.api.nvim_create_autocmd("BufWritePre", {
	group = lspFormatting,
	pattern = { "*.xml" },
	callback = function()
		execute_formatting_command(".xml", function(filePath)
			return 'xmllint --format --output ' .. filePath .. ' ' .. filePath
		end)
	end
})

-- vim.api.nvim_create_autocmd("BufWritePost", {
-- 	group = lspFormatting,
-- 	pattern = { "*.json" },
-- 	callback = function()
-- 		vim.api.nvim_command('silent !prettier --write %')
-- 	end
-- })

vim.api.nvim_create_autocmd("BufWritePre", {
	group = lspFormatting,
	pattern = { "*.json" },
	callback = function()
		execute_formatting_command(".json", function(filePath)
			return 'prettier --log-level silent --write ' .. filePath
		end)
	end
})
lsp.on_attach(on_attach)
lsp.setup()
lsp.skip_server_setup({ 'rust_analyzer' })


require("dapui").setup()
vim.diagnostic.config({
	virtual_text = true,
})
local lspconfig = require('lspconfig')
lspconfig.lua_ls.setup {
	settings = {
		Lua = {
			runtime = {
				-- Tell the language server which version of Lua you're using
				-- (most likely LuaJIT in the case of Neovim)
				version = 'LuaJIT',
			},
			diagnostics = {
				-- Get the language server to recognize the `vim` global
				globals = {
					'vim',
					'require'
				},
			},
			workspace = {
				-- Make the server aware of Neovim runtime files
				library = vim.api.nvim_get_runtime_file("", true),
			},
			-- Do not send telemetry data containing a randomized but unique identifier
			telemetry = {
				enable = false,
			},
		},
	},
}


function AnsibleLspOn()
	vim.cmd.LspStop()
	vim.cmd.LspStart("ansiblels")
end

vim.cmd("command! AnsibleLspOn lua AnsibleLspOn()")

return {
	on_attach = on_attach,
}
