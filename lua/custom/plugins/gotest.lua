return {
  {
    'jborkows/gotest.nvim',
    config = function()
      local plugin = require 'gotest'
      plugin.setup()
    end,
    dependencies = {
      'nvim-lua/plenary.nvim',
    },
  },
}
