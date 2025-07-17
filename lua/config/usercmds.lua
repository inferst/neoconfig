-- Format command
vim.api.nvim_create_user_command('Format', function(args)
  local range = nil
  if args.count ~= -1 then
    local end_line = vim.api.nvim_buf_get_lines(0, args.line2 - 1, args.line2, true)[1]
    range = {
      start = { args.line1, 0 },
      ['end'] = { args.line2, end_line:len() },
    }
  end
  require('conform').format { async = true, lsp_format = 'fallback', range = range }
end, { range = true })

-- Open terminal in the same buffer
local terminal_buf = nil

vim.api.nvim_create_user_command('Term', function()
  if vim.fn.bufexists(terminal_buf) == 1 and terminal_buf ~= nil then
    local win = vim.fn.win_getid()
    vim.api.nvim_win_set_buf(win, terminal_buf)
  else
    vim.cmd 'term'
    terminal_buf = vim.fn.bufnr '%'
  end
end, {})
