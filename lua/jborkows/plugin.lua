vim.cmd [[packadd packer.nvim]]

return require('packer').startup(function(use)
	use 'wbthomason/packer.nvim'
	use 'morhetz/gruvbox'
	use 'folke/tokyonight.nvim'
	use 'nvim-lua/plenary.nvim'
	use 'BurntSushi/ripgrep'
	use 'nvim-telescope/telescope.nvim'
	use {
		"ThePrimeagen/refactoring.nvim",
		requires = {
			{ "nvim-lua/plenary.nvim" },
			{ "nvim-treesitter/nvim-treesitter" }
		}
	}
	use 'mbbill/undotree'
	use 'neovim/nvim-lspconfig'
	use 'nvim-treesitter/nvim-treesitter'
	use 'nvim-treesitter/nvim-treesitter-context'
	use 'nvim-treesitter/playground'
	use 'ThePrimeagen/harpoon'

	use 'tpope/vim-commentary'

	-- Installation nvim lsp
	use 'hrsh7th/cmp-nvim-lsp'
	use 'hrsh7th/cmp-buffer'
	use 'hrsh7th/cmp-path'
	use 'hrsh7th/cmp-cmdline'
	use 'hrsh7th/nvim-cmp'
	use 'L3MON4D3/LuaSnip'
	use 'saadparwaiz1/cmp_luasnip'
	-- go.nvim
	use 'ray-x/go.nvim'
	use 'ray-x/guihua.lua' -- recommanded if need floating window support
	use 'mfussenegger/nvim-dap'
	use 'rcarriga/nvim-dap-ui'
	use 'theHamsta/nvim-dap-virtual-text'

	--use { 'mhartington/formatter.nvim' }
	use 'xiyaowong/telescope-emoji.nvim'
	use 'rcarriga/nvim-notify'
end)
