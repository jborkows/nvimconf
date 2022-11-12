vim.cmd [[
filetype plugin on
runtime macros/matchit.vim
fun! TrimWhitespace()
        let l:save = winsaveview()
        keeppatterns %s/\s\+$//e
        call winrestview(l:save)
endfun
augroup jb
        autocmd!
        autocmd BufWritePre * :call TrimWhitespace()
augroup END

nnoremap  <silent> <C-l> :<C-u>nohlsearch<CR><C-l>
nnoremap  <silent> [b :bprevious<CR>
nnoremap  <silent> ]b :bnext<CR>
"Gets the folder of command - relative
cnoremap <expr> %% getcmdtype() == ':' ? expand('%:h').'/' : '%%'
]]
local nnoremap = require("jborkows.keymap").nnoremap
local inoremap = require("jborkows.keymap").inoremap
local tnoremap = require("jborkows.keymap").tnoremap
local vnoremap = require("jborkows.keymap").vnoremap
-- replace with snippets
-- inoremap("{", "<ESC>A{}<ESC>ha")
-- inoremap("(", "()<ESC>ha")
--
-- inoremap("\"", "\"\"<ESC>ha")
nnoremap("<Leader>p", "0P")
nnoremap("<leader>d", "\"_d")
nnoremap("<leader>/", ":Commentary<CR>")
nnoremap("<leader>pv", "<cmd>Ex<CR>")
nnoremap("<leader>ff", "<cmd>lua require('telescope.builtin').find_files()<cr>")
nnoremap("<leader><leader>f", "<cmd>lua require('telescope.builtin').find_files()<cr>")
nnoremap("<leader>fg", "<cmd>lua require('telescope.builtin').live_grep()<cr>")
nnoremap("<leader>fb", "<cmd>lua require('telescope.builtin').buffers()<cr>")
nnoremap("<leader>fh", "<cmd>lua require('telescope.builtin').help_tags()<cr>")
nnoremap("<F5>", ":UndotreeToggle<CR>")

nnoremap("<leader>ca", "<cmd>lua require('harpoon.mark').add_file()<cr>")
nnoremap("<leader><leader>ca", "<cmd>lua require('harpoon.mark').add_file()<cr>")
nnoremap("<leader>cw", "<cmd>lua require('harpoon.ui').toggle_quick_menu()<cr>")
nnoremap("<leader>cl", "<cmd>belowright split <bar> resize 10 <bar> terminal<cr>")
tnoremap("<esc>", [[<C-\><C-n>]])
-- reload fill
vim.keymap.set("n", "<leader>sl", "<cmd>source %<CR>")
local opts = { noremap = true, silent = true }
vim.keymap.set('n', '<space>?', vim.diagnostic.open_float, opts)
vim.keymap.set('n', '[d', vim.diagnostic.goto_prev, opts)
vim.keymap.set('n', ']d', vim.diagnostic.goto_next, opts)
vim.keymap.set('n', '<space>q', vim.diagnostic.setloclist, opts)

-- Use an on_attach function to only map the following keys
-- after the language server attaches to the current buffer
local on_attach = function(client, bufnr)
	-- Enable completion triggered by <c-x><c-o>
	vim.api.nvim_buf_set_option(bufnr, 'omnifunc', 'v:lua.vim.lsp.omnifunc')

	-- Mappings.
	-- See `:help vim.lsp.*` for documentation on any of the below functions
	local bufopts = { noremap = true, silent = true, buffer = bufnr }
	vim.keymap.set('n', 'gD', vim.lsp.buf.declaration, bufopts)
	vim.keymap.set('n', 'gd', vim.lsp.buf.definition, bufopts)
	vim.keymap.set('n', 'fu', vim.lsp.buf.references, bufopts)
	vim.keymap.set('n', 'K', vim.lsp.buf.hover, bufopts)
	vim.keymap.set('n', 'gi', vim.lsp.buf.implementation, bufopts)
	vim.keymap.set('n', '<C-k>', vim.lsp.buf.signature_help, bufopts)
	vim.keymap.set('n', '<space>wa', vim.lsp.buf.add_workspace_folder, bufopts)
	vim.keymap.set('n', '<space>wr', vim.lsp.buf.remove_workspace_folder, bufopts)
	vim.keymap.set('n', '<space>wl', function()
		print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
	end, bufopts)
	vim.keymap.set('n', '<space>D', vim.lsp.buf.type_definition, bufopts)
	vim.keymap.set('n', '<space>rn', vim.lsp.buf.rename, bufopts)
	vim.keymap.set('n', '<space>la', vim.lsp.buf.code_action, bufopts)
	vim.keymap.set('n', 'gr', vim.lsp.buf.references, bufopts)
	vim.keymap.set('n', '<leader>cf', vim.lsp.buf.format, bufopts)
	vim.keymap.set('n', '<leader>ld', vim.diagnostic.goto_next, bufopts)
	vim.keymap.set('n', '<leader>lt', "<cmd>Telescope diagnostics<cr>", bufopts)
end

local lsp_flags = {
	-- This is the default in Nvim 0.7+
	debounce_text_changes = 150,
}
require('lspconfig')['yamlls'].setup {
	settings = {
		yaml = {
			schemas = { kubernetes = "globPattern", }
		}
	}
}

-- vim-go
--vim.cmd [[
--autocmd FileType go nmap <leader>b  <Plug>(go-build)
--autocmd FileType go nmap <leader>r  <Plug>(go-run)
--autocmd FileType go nmap <leader>t  <Plug>(go-test)
--" au filetype go inoremap <buffer> . .<C-x><C-o>
--noremap <F10> :copen 40<cr>
--let g:go_debug_windows = {
--\ 'vars':       'rightbelow 90vnew',
--\ 'stack':      'rightbelow 10new',
--\ }
--]]

-- cmp
local has_words_before = function()
	local line, col = unpack(vim.api.nvim_win_get_cursor(0))
	return col ~= 0 and vim.api.nvim_buf_get_lines(0, line - 1, line, true)[1]:sub(col, col):match("%s") == nil
end

local luasnip = require("luasnip")
local cmp = require("cmp")

cmp.setup({

	-- ... Your other configuration ...

	snippet = {
		-- REQUIRED - you must specify a snippet engine
		expand = function(args)
			--vim.fn["vsnip#anonymous"](args.body) -- For `vsnip` users.
			require('luasnip').lsp_expand(args.body) -- For `luasnip` users.
			-- require('snippy').expand_snippet(args.body) -- For `snippy` users.
			-- vim.fn["UltiSnips#Anon"](args.body) -- For `ultisnips` users.
		end,
	},
	mapping = {

		["<Left>"] = cmp.mapping(cmp.mapping.select_prev_item(), { "i", "c" }),
		["<Right>"] = cmp.mapping(cmp.mapping.select_next_item(), { "i", "c" }),
		["<C-b>"] = cmp.mapping(cmp.mapping.scroll_docs(-4), { "i", "c" }),
		["<C-f>"] = cmp.mapping(cmp.mapping.scroll_docs(4), { "i", "c" }),
		["<C-Space>"] = cmp.mapping(cmp.mapping.complete(), { "i", "c" }),
		["<C-y>"] = cmp.config.disable, -- Specify `cmp.config.disable` if you want to remove the default `<C-y>` mapping.
		["<C-e>"] = cmp.mapping {
			i = cmp.mapping.abort(),
			c = cmp.mapping.close(),
		},
		["<CR>"] = cmp.mapping.confirm { select = true },
		-- ... Your other mappings ...

		["<Tab>"] = cmp.mapping(function(fallback)
			if cmp.visible() then
				cmp.select_next_item()
			elseif luasnip.expand_or_jumpable() then
				luasnip.expand_or_jump()
			elseif has_words_before() then
				print("completed")
				cmp.complete()
			else
				fallback()
			end
		end, { "i", "s" }),

		["<S-Tab>"] = cmp.mapping(function(fallback)
			if cmp.visible() then
				cmp.select_prev_item()
			elseif luasnip.jumpable(-1) then
				luasnip.jump(-1)
			else
				fallback()
			end
		end, { "i", "s" }),

		-- ... Your other mappings ...
	},

	sources = cmp.config.sources({
		{ name = 'nvim_lsp' },
		-- { name = 'vsnip' }, -- For vsnip users.
		{ name = 'luasnip' }, -- For luasnip users.
		-- { name = 'ultisnips' }, -- For ultisnips users.
		-- { name = 'snippy' }, -- For snippy users.
	}, {
		{ name = 'buffer' },
	})
	-- ... Your other configuration ...
})

-- go.nvim
local capabilities = require('cmp_nvim_lsp').default_capabilities()
require 'go'.setup({
	goimport = 'gopls', -- if set to 'gopls' will use golsp format
	gofmt = 'gofumpt', -- if set to gopls will use golsp format
	max_line_len = 120,
	tag_transform = false,
	test_dir = '',
	comment_placeholder = '   ',
	lsp_cfg = {
		capabilities = capabilities
	},
	lsp_gofumpt = true, -- true: set default gofmt in gopls format to gofumpt
	lsp_on_attach = true, -- use on_attach from go.nvim
	dap_debug = true,
})

vim.cmd [[
augroup jbgo
autocmd!
autocmd FileType go nmap <Leader>gc :lua require('go.comment').gen()<cr>
autocmd FileType go nmap <leader>b  :GoBuild<cr>
autocmd FileType go nmap <leader>r  :GoRun<cr>
autocmd FileType go nmap <leader>t  :GoTest<cr>
augroup end
]]

-- lua
local runtime_path = vim.split(package.path, ";")
table.insert(runtime_path, "lua/?.lua")
table.insert(runtime_path, "lua/?/init.lua")
require 'lspconfig'.sumneko_lua.setup {
	settings = {
		Lua = {
			runtime = {
				-- Tell the language server which version of Lua you're using (most likely LuaJIT in the case of Neovim)
				version = 'LuaJIT',
			},
			diagnostics = {
				-- Get the language server to recognize the `vim` global
				globals = { 'vim' },
			},
			workspace = {
				-- Make the server aware of Neovim runtime files
				library = vim.api.nvim_get_runtime_file("", true),
			},
			-- Do not send telemetry data containing a randomized but unique identifier
			telemetry = {
				enable = false,
			},
			format = {
				enable = true
			}
		},
	},
}

-- bash language server
require('lspconfig').bashls.setup {

}
