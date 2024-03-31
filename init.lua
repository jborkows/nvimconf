require("jborkows")

local function load_project_config()
	local project_config = '.nvimrc.lua'
	-- Check if the project-specific config file exists in the current working directory
	local config_path = vim.fn.getcwd() .. '/' .. project_config
	if vim.fn.filereadable(config_path) == 1 then
		-- Source the project-specific config file
		dofile(config_path)
	end
end
-- Automatically call load_project_config when Neovim starts
vim.api.nvim_create_autocmd("VimEnter", {
	pattern = "*",
	callback = load_project_config,
})
