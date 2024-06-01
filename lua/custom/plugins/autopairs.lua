return {
  {
    'windwp/nvim-autopairs',
    event = 'InsertEnter',
    config = true,
    init = function()
      require('nvim-autopairs').setup {}
    end,
    -- use opts = {} for passing setup options
    -- this is equalent to setup({}) function
  },
}
