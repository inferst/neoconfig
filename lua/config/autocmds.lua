-- [[ Basic Autocommands ]]
--  See `:help lua-guide-autocommands`

-- Highlight when yanking (copying) text
--  Try it with `yap` in normal mode
--  See `:help vim.highlight.on_yank()`
vim.api.nvim_create_autocmd('TextYankPost', {
  desc = 'Highlight when yanking (copying) text',
  group = vim.api.nvim_create_augroup('kickstart-highlight-yank', { clear = true }),
  callback = function()
    vim.highlight.on_yank()
  end,
})

-- Close buffers when files are deleted in Oil
vim.api.nvim_create_autocmd('User', {
  desc = 'Close buffers when files are deleted in Oil',
  pattern = 'OilActionsPost',
  callback = function(args)
    if args.data.err then
      return
    end
    for _, action in ipairs(args.data.actions) do
      if action.type == 'delete' then
        local _, path = require('oil.util').parse_url(action.url)
        local bufnr = vim.fn.bufnr(path)
        if bufnr ~= -1 then
          vim.cmd.bwipeout { bufnr, bang = true }
        end
      end
    end
  end,
})

local persistence_group = vim.api.nvim_create_augroup('Persistence', { clear = true })

-- Restore session in folder
vim.api.nvim_create_autocmd('VimEnter', {
  group = persistence_group,
  callback = function()
    -- NOTE: Before restoring the session, check:
    -- 1. No arg passed when opening nvim, means no `nvim --some-arg ./some-path`
    -- 2. No pipe, e.g. `echo "Hello world" | nvim`
    if vim.fn.argc() == 0 and not vim.g.started_with_stdin then
      require('persistence').load()
    end
  end,
  -- HACK: need to enable `nested` otherwise the current buffer will not have a filetype(no syntax)
  nested = true,
})

-- Delete empty and term buffers before save session

local bufs_to_delete_patterns = {
  '^neo%-tree filesystem',
  '^term://',
  '^quickfix',
  'NeogitStatus',
}

vim.api.nvim_create_autocmd('User', {
  group = persistence_group,
  pattern = 'PersistenceSavePre',
  callback = function()
    for _, buf in ipairs(vim.api.nvim_list_bufs()) do
      local name = vim.api.nvim_buf_get_name(buf)

      local matches_pattern = false
      for _, pattern in ipairs(bufs_to_delete_patterns) do
        if name:match(pattern) then
          matches_pattern = true
          break
        end
      end

      if vim.api.nvim_buf_is_loaded(buf) and (name == '' or matches_pattern) and not vim.bo[buf].modified then
        vim.api.nvim_buf_delete(buf, { force = true })
      end
    end
  end,
})

-- Add if condition surrounds

local nvim_surround_augroup = vim.api.nvim_create_augroup('NvimSurroundByFileType', { clear = true })

vim.api.nvim_create_autocmd('FileType', {
  group = nvim_surround_augroup,
  pattern = { 'javascript', 'typescript', 'javascriptreact', 'typescriptreact', 'vue' },
  callback = function()
    require('nvim-surround').buffer_setup {
      surrounds = {
        ['i'] = {
          add = function()
            return { { 'if () {' }, { '}' } }
          end,
        },
      },
    }
  end,
})

vim.api.nvim_create_autocmd('FileType', {
  group = nvim_surround_augroup,
  pattern = 'rust',
  callback = function()
    require('nvim-surround').buffer_setup {
      surrounds = {
        ['i'] = {
          add = function()
            local condition = vim.fn.input 'If condition: '
            if condition == '' then
              condition = 'true'
            end
            return { { 'if true {' }, { '}' } }
          end,
        },
      },
    }
  end,
})
