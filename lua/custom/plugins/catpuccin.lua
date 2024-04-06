return {
  {
    'catppuccin/nvim',
    name = 'catppuccin',
    priority = 1000,
    init = function()
      require('catppuccin').setup {
        flavour = 'mocha', -- latte, frappe, macchiato, mocha
        -- flavour = "auto" -- will respect terminal's background
        background = { -- :h background
          light = 'latte',
          dark = 'mocha',
        },
        transparent_background = true, -- disables setting the background color.
      }

      -- setup must be called before loading
      vim.cmd.colorscheme 'catppuccin'
    end,
  },
}
