local initialized = false
return {
  -- Lazy
  {
    'jackMort/ChatGPT.nvim',
    event = 'VeryLazy',
    config = function()
      vim.env.OPENAI_API_HOST = 'api.openai.com'

      local function initialize()
        require('chatgpt').setup {
          api_key_cmd = 'op read op://private/OpenAI/credential --no-newline',
          openai_params = {
            model = 'gpt-4-0125-preview',
            max_tokens = 4096,
          },
        }
        initialized = true
      end

      vim.api.nvim_create_user_command('EnableChat', initialize, {})

      local function openChat()
        if not initialized then
          initialize()
        end
        vim.cmd.ChatGPT()
      end
      vim.keymap.set('n', '<F2>', openChat, { desc = 'open chat' })
    end,
    dependencies = {
      'MunifTanjim/nui.nvim',
      'nvim-lua/plenary.nvim',
      'folke/trouble.nvim',
      'nvim-telescope/telescope.nvim',
    },
  },
}
