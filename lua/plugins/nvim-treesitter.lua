return { -- Highlight, edit, and navigate code
  'nvim-treesitter/nvim-treesitter',
  build = ':TSUpdate',
  main = 'nvim-treesitter.configs', -- Sets main module to use for opts
  -- [[ Configure Treesitter ]] See `:help nvim-treesitter`
  dependencies = {
    'nvim-treesitter/nvim-treesitter-textobjects',
  },
  opts = {
    ensure_installed = { 'bash', 'c', 'diff', 'html', 'lua', 'luadoc', 'markdown', 'markdown_inline', 'query', 'vim', 'vimdoc', 'json5' },
    -- Autoinstall languages that are not installed
    auto_install = true,
    highlight = {
      enable = true,
      -- Some languages depend on vim's regex highlighting system (such as Ruby) for indent rules.
      --  If you are experiencing weird indenting issues, add the language to
      --  the list of additional_vim_regex_highlighting and disabled languages for indent.
      additional_vim_regex_highlighting = { 'ruby' },
      is_supported = function()
        if vim.fn.strwidth(vim.fn.getline '.') > 300 or vim.fn.getfsize(vim.fn.expand '%') > 1024 * 1024 then
          return false
        else
          return true
        end
      end,
    },
    indent = { enable = true, disable = { 'ruby' } },
    textobjects = {
      select = {
        enable = true,
        lookahead = true,
        include_surrounding_whitespace = true,
        keymaps = {
          -- You can use the capture groups defined in textobjects.scm
          ['af'] = { query = '@function.outer', desc = 'around a function' },
          ['if'] = { query = '@function.inner', desc = 'inner part of a function' },
          ['ac'] = { query = '@class.outer', desc = 'around a class' },
          ['ic'] = { query = '@class.inner', desc = 'inner part of a class' },
          ['ai'] = { query = '@conditional.outer', desc = 'around an if statement' },
          ['ii'] = { query = '@conditional.inner', desc = 'inner part of an if statement' },
          ['al'] = { query = '@loop.outer', desc = 'around a loop' },
          ['il'] = { query = '@loop.inner', desc = 'inner part of a loop' },
          ['ap'] = { query = '@parameter.outer', desc = 'around parameter' },
          ['ip'] = { query = '@parameter.inner', desc = 'inside a parameter' },
        },
        selection_modes = {
          ['@parameter.outer'] = 'v', -- charwise
          ['@parameter.inner'] = 'v', -- charwise
          ['@function.outer'] = 'v', -- charwise
          ['@conditional.outer'] = 'V', -- linewise
          ['@loop.outer'] = 'V', -- linewise
          ['@class.outer'] = '<c-v>', -- blockwise
        },
      },
      move = {
        enable = true,
        set_jumps = true, -- whether to set jumps in the jumplist
        goto_previous_start = {
          ['[f'] = { query = '@function.outer', desc = 'Previous function' },
          ['[c'] = { query = '@class.outer', desc = 'Previous class' },
          ['[p'] = { query = '@parameter.inner', desc = 'Previous parameter' },
        },
        goto_next_start = {
          [']f'] = { query = '@function.outer', desc = 'Next function' },
          [']c'] = { query = '@class.outer', desc = 'Next class' },
          [']p'] = { query = '@parameter.inner', desc = 'Next parameter' },
        },
      },
    },
    folding = true,
  },
  -- There are additional nvim-treesitter modules that you can use to interact
  -- with nvim-treesitter. You should go explore a few and see what interests you:
  --
  --    - Incremental selection: Included, see `:help nvim-treesitter-incremental-selection-mod`
  --    - Show your current context: https://github.com/nvim-treesitter/nvim-treesitter-context
  --    - Treesitter + textobjects: https://github.com/nvim-treesitter/nvim-treesitter-textobjects
}
