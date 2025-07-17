return {
  'Exafunction/windsurf.nvim',
  dependencies = {
    'nvim-lua/plenary.nvim',
  },
  config = function()
    require('codeium').setup {
      enable_cmp_source = false,
      virtual_text = {
        enabled = true,
        key_bindings = {
          -- Accept the current completion.
          accept = '<C-a>',
          -- Accept the next word.
          accept_word = false,
          -- Accept the next line.
          accept_line = false,
          -- Clear the virtual text.
          clear = false,
          -- Cycle to the next completion.
          next = '<M-]>',
          -- Cycle to the previous completion.
          prev = '<M-[>',
        },
      },
    }
  end,
}
