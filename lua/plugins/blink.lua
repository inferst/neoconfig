return {
  'saghen/blink.cmp',
  version = '1.*',
  dependencies = {
    {
      'L3MON4D3/LuaSnip',
      version = '2.*',
      build = (function()
        if vim.fn.has 'win32' == 1 or vim.fn.executable 'make' == 0 then
          return
        end
        return 'make install_jsregexp'
      end)(),
      dependencies = {
        {
          'rafamadriz/friendly-snippets',
          config = function()
            require('luasnip.loaders.from_vscode').lazy_load()
            -- Custom snippets
            -- require('luasnip.loaders.from_vscode').lazy_load { paths = { '~/.config/nvim/snippets' } }
          end,
        },
      },
      opts = {},
    },
  },
  opts = {
    keymap = { preset = 'default' },

    appearance = {
      use_nvim_cmp_as_default = true,
      nerd_font_variant = 'mono',
    },

    cmdline = {
      enabled = false,
    },

    sources = {
      default = {
        'lsp',
        'path',
        'snippets',
        'buffer',
      },
      -- default = { 'lsp', 'path', 'snippets', 'buffer', 'dadbod' },
      -- providers = {
      --   dadbod = { name = 'Dadbod', module = 'vim_dadbod_completion.blink' },
      -- },
    },

    completion = {
      documentation = {
        auto_show = true,
        auto_show_delay_ms = 100,
      },
    },

    signature = { enabled = true },

    snippets = { preset = 'luasnip' },
  },
}
