function EnableChat()
	-- local result = vim.fn.system( "op read op://private/OpenAI/credential --no-newline")
	vim.env.OPENAI_API_HOST = "api.openai.com"

	require("chatgpt").setup(
		{

			api_key_cmd = "op read op://private/OpenAI/credential --no-newline",
			openai_params = {
				model = "gpt-3.5-turbo",
			}
		}
	)
end
