return {
  'folke/snacks.nvim',
  priority = 1000,
  lazy = false,
  opts = {
    bigfile = { enabled = true },
    notifier = { enabled = true },
    quickfile = { enabled = true },
    gitbrowse = { enabled = true },
    -- indent = { enabled = true },
    styles = {
      zen = {
        backdrop = { transparent = false, blend = 80 },
      },
    },
    zen = {
      enabled = true,
      toggles = {
        dim = false,
      },
      show = {
        statusline = true,
      },
    },
    picker = {
      main = {
        file = false,
      },
      sources = {
        git_grep_hunks = {
          supports_live = false,
          format = function(item, picker)
            local file_format = Snacks.picker.format.file(item, picker)
            vim.api.nvim_set_hl(0, 'SnacksPickerGitGrepLineNew', { link = 'Added' })
            vim.api.nvim_set_hl(0, 'SnacksPickerGitGrepLineOld', { link = 'Removed' })
            if item.sign == '+' then
              file_format[#file_format - 1][2] = 'SnacksPickerGitGrepLineNew'
            else
              file_format[#file_format - 1][2] = 'SnacksPickerGitGrepLineOld'
            end
            return file_format
          end,
          finder = function(_, ctx)
            local hcount = 0
            local header = {
              file = '',
              old = { start = 0, count = 0 },
              new = { start = 0, count = 0 },
            }
            local sign_count = 0
            return require('snacks.picker.source.proc').proc(
              ctx:opts {
                cmd = 'git',
                args = { 'diff', '--unified=0' },
                transform = function(item) ---@param item snacks.picker.finder.Item
                  local line = item.text
                  -- [[Header]]
                  if line:match '^diff' then
                    hcount = 3
                  elseif hcount > 0 then
                    if hcount == 1 then
                      header.file = line:sub(7)
                    end
                    hcount = hcount - 1
                  elseif line:match '^@@' then
                    local parts = vim.split(line:match '@@ ([^@]+) @@', ' ')
                    local old_start, old_count = parts[1]:match '-(%d+),?(%d*)'
                    local new_start, new_count = parts[2]:match '+(%d+),?(%d*)'
                    header.old.start, header.old.count = tonumber(old_start), tonumber(old_count) or 1
                    header.new.start, header.new.count = tonumber(new_start), tonumber(new_count) or 1
                    sign_count = 0
                  -- [[Body]]
                  elseif not line:match '^[+-]' then
                    sign_count = 0
                  elseif line:match '^[+-]%s*$' then
                    sign_count = sign_count + 1
                  else
                    item.sign = line:sub(1, 1)
                    item.file = header.file
                    item.line = line:sub(2)
                    if item.sign == '+' then
                      item.pos = { header.new.start + sign_count, 0 }
                      sign_count = sign_count + 1
                    else
                      item.pos = { header.new.start, 0 }
                      sign_count = 0
                    end
                    return true
                  end
                  return false
                end,
              },
              ctx
            )
          end,
        },
      },
      -- sources = {
      --   qflist = {
      --     on_change = function(picker, item)
      --       vim.schedule(function()
      --         picker.preview.win:set_title(item.file)
      --       end)
      --     end,
      --   },
      --   files = {
      --     on_change = function(picker, item)
      --       vim.schedule(function()
      --         picker.preview.win:set_title(item.file)
      --       end)
      --     end,
      --   },
      -- },
      --   formatters = {
      --     file = {
      --       truncate = 70,
      --     },
      --   },
      --   sources = {
      --     smart = {
      --       formatters = {
      --         file = {
      --           truncate = 200,
      --         },
      --       },
      --       layout = {
      --         preview = false,
      --       },
      --     },
      --     lsp_references = {
      --       focus = 'list',
      --     },
      --     git_status = {
      --       focus = 'list',
      --     },
      --   },
    },
  },
  keys = {
    {
      '<leader>sf',
      function()
        Snacks.picker.files()
      end,
      desc = '[S]earch [F]iles',
    },
    {
      '<leader><leader>',
      function()
        Snacks.picker.buffers()
      end,
      desc = '[ ] Find existing buffers',
    },
    {
      '<leader>sk',
      function()
        Snacks.picker.keymaps()
      end,
      desc = '[S]earch [K]eymaps',
    },
    {
      '<leader>s.',
      function()
        Snacks.picker.recent {
          filter = { cwd = true },
        }
      end,
      desc = '[S]earch Recent Files ("." for repeat)',
    },
    {
      '<leader>sd',
      function()
        Snacks.picker.diagnostics()
      end,
      desc = '[S]earch [D]iagnostics',
    },
    {
      '<leader>sn',
      function()
        Snacks.picker.files { cwd = vim.fn.stdpath 'config' }
      end,
      desc = '[S]earch [N]eovim files',
    },
    {
      '<leader>sg',
      function()
        Snacks.picker.grep()
      end,
      desc = '[S]earch by [G]rep (Literal)',
    },
    {
      '<leader>sw',
      function()
        Snacks.picker.grep_word()
      end,
      desc = '[S]earch current [W]ord',
      mode = { 'n', 'x' },
    },
    {
      '<leader>sh',
      function()
        Snacks.picker.git_grep_hunks()
      end,
      desc = '[S]earch git [H]unks',
      mode = { 'n', 'x' },
    },
    {
      '<leader>sr',
      function()
        Snacks.picker.resume()
      end,
      desc = '[S]earch [R]esume',
    },
    {
      '<leader>ss',
      function()
        Snacks.picker.lsp_symbols()
      end,
      desc = 'LSP Symbols',
    },
    {
      '<leader>b',
      function()
        Snacks.gitbrowse()
      end,
      desc = 'Git [B]rowse',
    },
    {
      ']]',
      function()
        Snacks.words.jump(vim.v.count1)
      end,
      desc = 'Next Reference',
      mode = { 'n', 't' },
    },
    {
      '[[',
      function()
        Snacks.words.jump(-vim.v.count1)
      end,
      desc = 'Prev Reference',
      mode = { 'n', 't' },
    },
    {
      '<leader>z',
      function()
        Snacks.zen()
      end,
      desc = 'Toggle [Z]en Mode',
    },
    {
      '<leader>Z',
      function()
        Snacks.zen.zoom()
      end,
      desc = 'Toggle [Z]oom',
    },
    {
      '<leader>n',
      function()
        Snacks.notifier.show_history()
      end,
      desc = '[N]otification History',
    },
  },
}
