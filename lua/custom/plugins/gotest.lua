return {
  {
    'jborkows/gotest.nvim',
    config = function()
      local plugin = require 'gotest'
      plugin.setup(
        plugin.debug
      -- ,
      -- plugin.goTestCommand {
      --   'go',
      --   'test',
      --   '-v',
      --   '-json',
      --   './...',
      -- }
      )
    end,
    dependencies = {
      'nvim-lua/plenary.nvim',
    },
  },
}
