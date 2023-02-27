vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1

-- set termguicolors to enable highlight groups
vim.opt.termguicolors = true

-- empty setup using defaults
-- require("nvim-tree").setup()

-- OR setup with some options
require("nvim-tree").setup({
	sort_by             = "case_sensitive",
	view                = {
		width = 30,
		mappings = {
			list = {
				{ key = "u", action = "dir_up" },
			},
		},
	},
	renderer            = {
		group_empty = true,
	},
	filters             = {
		dotfiles = true,
		exclude = { ".github", ".gitignore", ".idea" }
	},
	update_focused_file = {
		enable = true,
		update_cwd = true
	}
})
vim.schedule(function()
	require 'nvim-tree'.open_on_directory()
end)

-- open file on edit
local api = require("nvim-tree.api")
api.events.subscribe(api.events.Event.FileCreated, function(file)
	vim.cmd("edit " .. file.fname)
end)
