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
	"gopls"
})

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

lsp.on_attach(function(client, bufnr)
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
	vim.keymap.set("n", "[", vim.diagnostic.goto_next, opts)
	vim.keymap.set("n", "]", vim.diagnostic.goto_prev, opts)
	vim.keymap.set({ "n", "v" }, "<leader>ca", vim.lsp.buf.code_action, opts)
	vim.keymap.set("n", "<leader>cf", vim.lsp.buf.format, opts)
	vim.keymap.set("n", "<leader>fu", vim.lsp.buf.references, opts)
	vim.keymap.set("n", "<leader>gi", vim.lsp.buf.implementation, opts)
	vim.keymap.set("n", "<leader>mv", vim.lsp.buf.rename, opts)
	vim.keymap.set("i", "<C-h>", vim.lsp.buf.signature_help, opts)

	vim.api.nvim_clear_autocmds({ group = lspFormatting, buffer = bufnr })
	if client.supports_method("textDocument/formatting") then
		vim.api.nvim_create_autocmd("BufWritePre", {
			group = lspFormatting,
			pattern = { "*.rs", "*.lua", "*.ts", "*.js", "*.css", "*.dockerfile" },
			callback = function()
				vim.lsp.buf.format()
			end
		}
		);
	end

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
end)
lsp.skip_server_setup({ 'rust_analyzer' })

local home = os.getenv('HOME')
local codelldb_root = home .. '/.local/share/nvim/mason/packages/codelldb/extension/'
local codelldb_path = codelldb_root .. "adapter/codelldb"
local liblldb_path = codelldb_root .. "lldb/lib/liblldb.so"
lsp.setup()

local rust_tools = require('rust-tools')
local opts = {
	--
	server = {
		on_attach = function(_, bufnr)
			-- Hover actions
			vim.keymap.set("n", "<C-space>", rust_tools.hover_actions.hover_actions, { buffer = bufnr })
			-- Code action groups
			vim.keymap.set("n", "<Leader>ax", rust_tools.code_action_group.code_action_group, { buffer = bufnr })
		end,
	},
	-- ... other configs
	dap = {
		adapter = require('rust-tools.dap').get_codelldb_adapter(
			codelldb_path, liblldb_path)
	}
}

-- Normal setup
require('rust-tools').setup(opts)

require("dapui").setup()
vim.diagnostic.config({
	virtual_text = true,
})
