return {
  -- `lazydev` configures Lua LSP for your Neovim config, runtime and plugins
  -- used for completion, annotations and signatures of Neovim apis
  'folke/lazydev.nvim',
  ft = 'lua',
  opts = {
    library = {
      -- Load luvit types when the `vim.uv` word is found
      { path = 'snacks.nvim', words = { 'Snacks' } },
      { path = '${3rd}/luv/library', words = { 'vim%.uv' } },
    },
  },
}
