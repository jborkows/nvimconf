return {
  -- Lazy
  {
    'jackMort/ChatGPT.nvim',
    event = 'VeryLazy',
    config = function()
      vim.env.OPENAI_API_HOST = 'api.openai.com'

      vim.api.nvim_create_user_command('EnableChat', function()
        require('chatgpt').setup {
          api_key_cmd = 'op read op://private/OpenAI/credential --no-newline',
          openai_params = {
            model = 'gpt-4-0125-preview',
            max_tokens = 4096,
          },
        }
      end, {})
    end,
    dependencies = {
      'MunifTanjim/nui.nvim',
      'nvim-lua/plenary.nvim',
      'folke/trouble.nvim',
      'nvim-telescope/telescope.nvim',
    },
  },
}
