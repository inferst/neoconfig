return {
  'kylechui/nvim-surround',
  version = '*',
  event = 'VeryLazy',
  config = function()
    require('nvim-surround').setup {
      indent_lines = function(start, stop)
        local b = vim.bo
        if start < stop and (b.equalprg ~= '' or b.indentexpr ~= '' or b.cindent or b.smartindent or b.lisp) then
          vim.cmd(string.format('silent normal! %dG=%dG', start, stop))
          -- vim.defer_fn(function()
          -- Sometime we need to format via lsp
          vim.lsp.buf.format {
            range = {
              start = { start, 0 },
              ['end'] = { stop, vim.fn.strlen(vim.fn.getline(stop)) },
            },
          }
          -- end, 10)
        end
      end,
      surrounds = {
        g = {
          add = function()
            local config = require 'nvim-surround.config'
            local result = config.get_input 'Enter the generic name: '
            if result then
              return { { result .. '<' }, { '>' } }
            end
          end,
          find = function()
            local config = require 'nvim-surround.config'
            return config.get_selection { node = 'generic_type' }
          end,
          delete = '^(.-<)().-(>)()$',
          change = {
            target = '^(.-<)().-(>)()$',
            replacement = function()
              local config = require 'nvim-surround.config'
              local result = config.get_input 'Enter the generic name: '
              if result then
                return { { result .. '<' }, { '>' } }
              end
            end,
          },
        },
      },
    }
  end,
}
