return {
  {
    'jborkows/nvimplugin-reloader',
    config = function()
      local reloader = require 'reloader'
      reloader.setup(reloader.debug)
    end,
    dependencies = {
      'nvim-lua/plenary.nvim',
    },
  },
}
