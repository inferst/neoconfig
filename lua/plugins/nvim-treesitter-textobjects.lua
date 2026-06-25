return {
  'nvim-treesitter/nvim-treesitter-textobjects',
  branch = 'main',
  init = function()
    -- Disable entire built-in ftplugin mappings to avoid conflicts.
    -- See https://github.com/neovim/neovim/tree/master/runtime/ftplugin for built-in ftplugins.
    vim.g.no_plugin_maps = true

    -- Or, disable per filetype (add as you like)
    -- vim.g.no_python_maps = true
    -- vim.g.no_ruby_maps = true
    -- vim.g.no_rust_maps = true
    -- vim.g.no_go_maps = true
  end,
  -- opts = {
  --   select = {
  --     enable = true,
  --     lookahead = true,
  --     include_surrounding_whitespace = true,
  --     keymaps = {
  --       -- You can use the capture groups defined in textobjects.scm
  --       ['af'] = { query = '@function.outer', desc = 'around a function' },
  --       ['if'] = { query = '@function.inner', desc = 'inner part of a function' },
  --       ['ac'] = { query = '@class.outer', desc = 'around a class' },
  --       ['ic'] = { query = '@class.inner', desc = 'inner part of a class' },
  --       ['ai'] = { query = '@conditional.outer', desc = 'around an if statement' },
  --       ['ii'] = { query = '@conditional.inner', desc = 'inner part of an if statement' },
  --       ['al'] = { query = '@loop.outer', desc = 'around a loop' },
  --       ['il'] = { query = '@loop.inner', desc = 'inner part of a loop' },
  --       ['ap'] = { query = '@parameter.outer', desc = 'around parameter' },
  --       ['ip'] = { query = '@parameter.inner', desc = 'inside a parameter' },
  --     },
  --     selection_modes = {
  --       ['@parameter.outer'] = 'v', -- charwise
  --       ['@parameter.inner'] = 'v', -- charwise
  --       ['@function.outer'] = 'v', -- charwise
  --       ['@conditional.outer'] = 'V', -- linewise
  --       ['@loop.outer'] = 'V', -- linewise
  --       ['@class.outer'] = '<c-v>', -- blockwise
  --     },
  --   },
  --   move = {
  --     enable = true,
  --     set_jumps = true, -- whether to set jumps in the jumplist
  --     goto_previous_start = {
  --       ['[f'] = { query = '@function.outer', desc = 'Previous function' },
  --       ['[c'] = { query = '@class.outer', desc = 'Previous class' },
  --       ['[p'] = { query = '@parameter.inner', desc = 'Previous parameter' },
  --     },
  --     goto_next_start = {
  --       [']f'] = { query = '@function.outer', desc = 'Next function' },
  --       [']c'] = { query = '@class.outer', desc = 'Next class' },
  --       [']p'] = { query = '@parameter.inner', desc = 'Next parameter' },
  --     },
  --   },
  -- },
  config = function()
    require('nvim-treesitter-textobjects').setup {
      select = {
        -- Automatically jump forward to textobj, similar to targets.vim
        lookahead = true,
        -- You can choose the select mode (default is charwise 'v')
        --
        -- Can also be a function which gets passed a table with the keys
        -- * query_string: eg '@function.inner'
        -- * method: eg 'v' or 'o'
        -- and should return the mode ('v', 'V', or '<c-v>') or a table
        -- mapping query_strings to modes.
        selection_modes = {
          ['@parameter.outer'] = 'v', -- charwise
          ['@function.outer'] = 'V', -- linewise
          -- ['@class.outer'] = '<c-v>', -- blockwise
        },
        -- If you set this to `true` (default is `false`) then any textobject is
        -- extended to include preceding or succeeding whitespace. Succeeding
        -- whitespace has priority in order to act similarly to eg the built-in
        -- `ap`.
        --
        -- Can also be a function which gets passed a table with the keys
        -- * query_string: eg '@function.inner'
        -- * selection_mode: eg 'v'
        -- and should return true of false
        include_surrounding_whitespace = false,
      },
    }

    vim.keymap.set({ 'x', 'o' }, 'am', function()
      require('nvim-treesitter-textobjects.select').select_textobject('@function.outer', 'textobjects')
    end)
    vim.keymap.set({ 'x', 'o' }, 'im', function()
      require('nvim-treesitter-textobjects.select').select_textobject('@function.inner', 'textobjects')
    end)
    vim.keymap.set({ 'x', 'o' }, 'ac', function()
      require('nvim-treesitter-textobjects.select').select_textobject('@class.outer', 'textobjects')
    end)
    vim.keymap.set({ 'x', 'o' }, 'ic', function()
      require('nvim-treesitter-textobjects.select').select_textobject('@class.inner', 'textobjects')
    end)
    -- You can also use captures from other query groups like `locals.scm`
    vim.keymap.set({ 'x', 'o' }, 'as', function()
      require('nvim-treesitter-textobjects.select').select_textobject('@local.scope', 'locals')
    end)
    -- put your config here
  end,
}
