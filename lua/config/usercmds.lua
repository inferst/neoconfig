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

local function find_window(buf)
  for _, win_id in ipairs(vim.api.nvim_list_wins()) do
    if vim.api.nvim_win_get_buf(win_id) == buf then
      return win_id
    end
  end
  return nil
end

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

local gemini_buf = nil

vim.api.nvim_create_user_command('Gemini', function()
  if gemini_buf and vim.api.nvim_buf_is_valid(gemini_buf) then
    local win = find_window(gemini_buf)

    if win ~= nil then
      vim.api.nvim_set_current_win(win)
    else
      vim.api.nvim_win_set_buf(0, gemini_buf)
    end
  else
    vim.cmd 'terminal gemini'
    gemini_buf = vim.api.nvim_get_current_buf()
  end

  vim.cmd 'startinsert'
end, {})
