local function diffview_open()
  local filetypes = { 'DiffviewFiles', 'DiffviewFilePanel' }
  for _, tab in ipairs(vim.api.nvim_list_tabpages()) do
    for _, win in ipairs(vim.api.nvim_tabpage_list_wins(tab)) do
      local buf = vim.api.nvim_win_get_buf(win)
      local ft = vim.bo[buf].ft
      for _, target_ft in ipairs(filetypes) do
        if ft == target_ft then
          if tab ~= vim.api.nvim_get_current_tabpage() then
            vim.api.nvim_set_current_tabpage(tab)
          end
          vim.api.nvim_set_current_win(win)
          return
        end
      end
    end
  end
  vim.cmd 'DiffviewOpen'
end

local function diffview_pick_branch()
  local branches = vim.fn.systemlist { 'git', 'branch', '--format=%(refname:short)' }
  if vim.v.shell_error ~= 0 or #branches == 0 then
    vim.notify('No branches found', vim.log.levels.ERROR)
    return
  end
  Snacks.picker.git_branches({
    confirm = function(picker, item)
      picker:close()
      if item then
        vim.cmd('DiffviewOpen ' .. item.text)
      end
    end,
  })
end

return {
  'sindrets/diffview.nvim',
  opts = {
    use_icons = false,
    show_help_hints = false,
  },
  keys = {
    { '<leader>dd', diffview_open, desc = 'Diffview: Open' },
    { '<leader>db', diffview_pick_branch, desc = 'Diffview: Open vs branch' },
    { '<leader>dh', '<CMD>DiffviewFileHistory %<CR>', desc = 'Diffview: File history' },
    { '<leader>dH', '<CMD>DiffviewFileHistory<CR>', desc = 'Diffview: Repo history' },
    { '<leader>dc', '<CMD>DiffviewClose<CR>', desc = 'Diffview: Close' },
  },
}
