function CopilotStatus()
	vim.cmd.Copilot("status")
end

function CopilotEnable()
	vim.cmd.Copilot("enable")
end

function CopilotDisable()
	vim.cmd.Copilot("disable")
end

vim.g.copilot_filetypes = {
	markdown = true,
	yaml = true,
}
