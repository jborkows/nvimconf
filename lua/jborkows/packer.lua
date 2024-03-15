vim.cmd [[packadd packer.nvim]]

return require('packer').startup(function(use)
	use 'wbthomason/packer.nvim'
	use 'folke/tokyonight.nvim'

	use 'nvim-lua/plenary.nvim'
	use 'BurntSushi/ripgrep'
	use {
		'nvim-telescope/telescope.nvim', tag = '0.1.6',
		-- or                            , branch = '0.1.x',
		requires = { { 'nvim-lua/plenary.nvim' } }
	}

	use({ 'nvim-treesitter/nvim-treesitter', run = ':TSUpdate', tag = "v0.9.2" })
	use 'nvim-treesitter/nvim-treesitter-context'
	use 'nvim-treesitter/playground'
	use {
		"ThePrimeagen/harpoon",
		branch = "harpoon2",
		requires = { { "nvim-lua/plenary.nvim" } }
	}
	use('mbbill/undotree')
	use('tpope/vim-fugitive')
	use 'tpope/vim-surround'
	use 'tpope/vim-commentary'
	use 'xiyaowong/telescope-emoji.nvim'
	use 'rcarriga/nvim-notify'
	use 'lewis6991/gitsigns.nvim'
	use {
		'VonHeikemen/lsp-zero.nvim',
		requires = {
			-- LSP Support
			{ 'neovim/nvim-lspconfig' },
			{ 'williamboman/mason.nvim' },
			{ 'williamboman/mason-lspconfig.nvim' },

			-- Autocompletion
			{ 'hrsh7th/nvim-cmp' },
			{ 'hrsh7th/cmp-buffer' },
			{ 'hrsh7th/cmp-path' },
			{ 'saadparwaiz1/cmp_luasnip' },
			{ 'hrsh7th/cmp-nvim-lsp' },
			{ 'hrsh7th/cmp-nvim-lua' },

			-- Snippets
			{ 'L3MON4D3/LuaSnip' },
			{ 'rafamadriz/friendly-snippets' },
		}
	}
	use {
		'nvim-tree/nvim-tree.lua',
		requires = {
			'nvim-tree/nvim-web-devicons', -- optional, for file icons
		},
		tag = 'nightly'           -- optional, updated every week. (see issue #1193)
	}
	use 'simrat39/symbols-outline.nvim'

	use 'mfussenegger/nvim-dap'
	use 'mfussenegger/nvim-jdtls'
	-- use { "rcarriga/nvim-dap-ui", requires = { "mfussenegger/nvim-dap" } }
	-- use "folke/neodev.nvim"
	-- -- use 'simrat39/rust-tools.nvim'
	-- require("neodev").setup({
	-- 	library = { plugins = { "nvim-dap-ui" }, types = true },
	-- })
	use 'simrat39/rust-tools.nvim'

	-- Debugging
	use 'nvim-lua/plenary.nvim'
	use({ "rcarriga/nvim-dap-ui", requires = { "mfussenegger/nvim-dap" } })
	use 'theHamsta/nvim-dap-virtual-text'
	use 'ThePrimeagen/refactoring.nvim'
	use({
		"jackMort/ChatGPT.nvim",
		-- config = function()
		-- 	require("chatgpt").setup()
		-- end,
		requires = {
			"MunifTanjim/nui.nvim",
			"nvim-lua/plenary.nvim",
			"nvim-telescope/telescope.nvim"
		}
	})
	use 'christoomey/vim-tmux-navigator'
	use 'tpope/vim-obsession'
	use 'github/copilot.vim'
	use {
		"folke/which-key.nvim",
		config = function()
			vim.o.timeout = true
			vim.o.timeoutlen = 300
		end
	}
	use 'laytan/cloak.nvim'
end)
