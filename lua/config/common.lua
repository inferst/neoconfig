-- JSX comment support
local get_option = vim.filetype.get_option
---@diagnostic disable-next-line: duplicate-set-field
vim.filetype.get_option = function(filetype, option)
  return option == 'commentstring' and require('ts_context_commentstring.internal').calculate_commentstring() or get_option(filetype, option)
end

-- -- Open DBUI in the tab
-- local dbui_buf = nil
-- local dbui_query_buf = nil
--
-- vim.api.nvim_create_user_command('DBUITabToggle', function()
--   if vim.fn.bufexists(dbui_buf) == 1 and dbui_buf ~= nil then
--     local current = vim.api.nvim_get_current_tabpage()
--
--     for _, tabid in ipairs(vim.api.nvim_list_tabpages()) do
--       for _, winid in ipairs(vim.api.nvim_tabpage_list_wins(tabid)) do
--         local winbufnr = vim.api.nvim_win_get_buf(winid)
--         local winvalid = vim.api.nvim_win_is_valid(winid)
--
--         if winvalid and winbufnr == dbui_buf then
--           if current == tabid then
--             if vim.fn.bufexists(dbui_query_buf) == 1 and dbui_query_buf ~= nil then
--               vim.api.nvim_buf_delete(dbui_query_buf, { force = true })
--               dbui_query_buf = nil
--             end
--
--             dbui_buf = nil
--             vim.cmd 'tabclose'
--
--             return
--           else
--             vim.api.nvim_set_current_tabpage(tabid)
--             return
--           end
--         end
--       end
--     end
--   else
--     vim.cmd 'tabnew'
--     dbui_query_buf = vim.fn.bufnr '%'
--
--     vim.cmd 'DBUI'
--     dbui_buf = vim.fn.bufnr '%'
--   end
-- end, {})

-- -- Organize Imports in typescript files
-- vim.api.nvim_create_user_command('OrganizeImports', function()
--   vim.api.nvim_command 'TSToolsOrganizeImports'
-- end, {})

-- Set tab title
function _G.current_tab()
  local path = {}
  local cwd = vim.uv.cwd()

  if cwd then
    for item in string.gmatch(cwd, '([^/]+)') do
      table.insert(path, item)
    end
  end

  return path[#path]
end

-- Hide "No information available" notification
-- vim.lsp.handlers['textDocument/hover'] = function(_, result, ctx, config)
--   config = config or {}
--   config.focus_id = ctx.method
--   if not (result and result.contents) then
--     return
--   end
--   local markdown_lines = vim.lsp.util.convert_input_to_markdown_lines(result.contents)
--   markdown_lines = vim.lsp.util.trim_empty_lines(markdown_lines)
--   if vim.tbl_isempty(markdown_lines) then
--     return
--   end
--   return vim.lsp.util.open_floating_preview(markdown_lines, 'markdown', config)
-- end

local orig_hover = vim.lsp.buf.hover
---@diagnostic disable-next-line: duplicate-set-field
vim.lsp.buf.hover = function()
  orig_hover { border = 'rounded' }
end

-- Markdown syntax for mdx files
vim.filetype.add {
  extension = {
    mdx = 'markdown',
  },
}

-- When make session, leave only visible buffers
vim.opt.sessionoptions:remove("buffers")
