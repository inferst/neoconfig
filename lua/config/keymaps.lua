-- [[ Basic Keymaps ]]
--  See `:help vim.keymap.set()`

-- Clear highlights on search when pressing <Esc> in normal mode
--  See `:help hlsearch`
vim.keymap.set('n', '<Esc>', '<cmd>nohlsearch<CR>')

-- Diagnostic keymaps
vim.keymap.set('n', '<leader>e', vim.diagnostic.open_float, { desc = 'Show diagnostic [E]rror messages' })
vim.keymap.set('n', '<leader>q', vim.diagnostic.setloclist, { desc = 'Open diagnostic [Q]uickfix list' })

-- Exit terminal mode in the builtin terminal with a shortcut that is a bit easier
-- for people to discover. Otherwise, you normally need to press <C-\><C-n>, which
-- is not what someone will guess without a bit more experience.
--
-- NOTE: This won't work in all terminal emulators/tmux/etc. Try your own mapping
-- or just use <C-\><C-n> to exit terminal mode
vim.keymap.set('t', '<Esc><Esc>', '<C-\\><C-n>', { desc = 'Exit terminal mode' })

-- TIP: Disable arrow keys in normal mode
vim.keymap.set('n', '<left>', '<cmd>echo "Use h to move!"<CR>')
vim.keymap.set('n', '<right>', '<cmd>echo "Use l to move!"<CR>')
vim.keymap.set('n', '<up>', '<cmd>echo "Use k to move!"<CR>')
vim.keymap.set('n', '<down>', '<cmd>echo "Use j to move!"<CR>')

-- Keybinds to make split navigation easier.
--  Use CTRL+<hjkl> to switch between windows
--
--  See `:help wincmd` for a list of all window commands
vim.keymap.set('n', '<C-h>', '<C-w><C-h>', { desc = 'Move focus to the left window' })
vim.keymap.set('n', '<C-l>', '<C-w><C-l>', { desc = 'Move focus to the right window' })
vim.keymap.set('n', '<C-j>', '<C-w><C-j>', { desc = 'Move focus to the lower window' })
vim.keymap.set('n', '<C-k>', '<C-w><C-k>', { desc = 'Move focus to the upper window' })

-- NOTE: Some terminals have colliding keymaps or are not able to send distinct keycodes
-- vim.keymap.set("n", "<C-S-h>", "<C-w>H", { desc = "Move window to the left" })
-- vim.keymap.set("n", "<C-S-l>", "<C-w>L", { desc = "Move window to the right" })
-- vim.keymap.set("n", "<C-S-j>", "<C-w>J", { desc = "Move window to the lower" })
-- vim.keymap.set("n", "<C-S-k>", "<C-w>K", { desc = "Move window to the upper" })

vim.keymap.set('n', '<leader>g', '<CMD>Neogit<CR>', { desc = 'Neo[G]it' })

vim.keymap.set('n', '<leader>u', '<CMD>GrugFar<CR>', { desc = 'GrugFar' })

-- vim.keymap.set('n', '<leader>p', '<CMD>DBUITabToggle<CR>', { desc = 'DBUI' })

vim.keymap.set('n', '<c-/>', '<CMD>Term<CR>', { desc = 'Terminal' })

vim.keymap.set('n', '{', '<CMD>execute "keepjumps norm! {"<CR>', { noremap = true, silent = true })
vim.keymap.set('n', '}', '<CMD>execute "keepjumps norm! }"<CR>', { noremap = true, silent = true })

vim.keymap.set('n', '<leader>co', function()
  vim.lsp.buf.code_action {
    context = { diagnostics = {}, only = { 'source.organizeImports' } },
    apply = true,
  }
end, { desc = 'Organize Imports' })

vim.keymap.set('n', '<leader>cM', function()
  vim.lsp.buf.code_action {
    ---@diagnostic disable-next-line: assign-type-mismatch
    context = { diagnostics = {}, only = { 'source.addMissingImports.ts' } },
    apply = true,
  }
end, { desc = 'Add missing imports' })

vim.keymap.set('n', '<leader>cu', function()
  vim.lsp.buf.code_action {
    ---@diagnostic disable-next-line: assign-type-mismatch
    context = { diagnostics = {}, only = { 'source.removeUnused.ts' } },
    apply = true,
  }
end, { desc = 'Remove unused imports' })

vim.keymap.set('n', '<leader>cD', function()
  vim.lsp.buf.code_action {
    ---@diagnostic disable-next-line: assign-type-mismatch
    context = { diagnostics = {}, only = { 'source.fixAll.ts' } },
    apply = true,
  }
end, { desc = 'Fix all diagnostics' })
