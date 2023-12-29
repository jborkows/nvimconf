local module = {}

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
end
module.lspFormatting = lspFormatting
module.on_attach = on_attach
return module
