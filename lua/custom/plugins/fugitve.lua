return {
  {
    'tpope/vim-fugitive',
    config = function()
      vim.keymap.set('n', '<leader>gs', vim.cmd.Git)
      vim.keymap.set('n', 'gr', '<cmd>diffget //3<CR>')
      vim.keymap.set('n', 'gl', '<cmd>diffget //2<CR>')
      vim.keymap.set('n', '<leader>gh', '<cmd>OGcLog<CR>',
        { desc = 'open file history and populate quick list with file version' })
      vim.keymap.set('n', '<leader>gd', '<cmd>Gdiffsplit<CR>', { desc = 'dif split' })
    end,
  },
}
