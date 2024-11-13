local builtin = require('telescope.builtin')

vim.keymap.set('n', '<space>o', builtin.find_files, {})
vim.keymap.set('n', '<space><space>', builtin.oldfiles, {})
vim.keymap.set('n', '<space>fg', builtin.live_grep, {})
vim.keymap.set('n', '<space>fh', builtin.help_tags, {})

local function get_visual_selection()
    local reg_save = vim.fn.getreg('"')
    local regtype_save = vim.fn.getregtype('"')
    vim.cmd('normal! gvy')
    local selection = vim.fn.getreg('"')
    vim.fn.setreg('"', reg_save, regtype_save)
    return selection
end

local function search_selection()
    local selection = get_visual_selection()
    selection = selection:gsub("\n", ""):gsub("^%s*(.-)%s*$", "%1")
    if selection ~= "" then
        builtin.live_grep({
            default_text = selection,
        })
    end
end

local function search_word_under_cursor()
    local word = vim.fn.expand('<cword>')
    if word ~= "" then
        builtin.live_grep({
            default_text = word,
        })
    end
end

vim.api.nvim_create_user_command('SearchSelection', function()
    search_selection()
end, { range = true })

vim.keymap.set('v', '<space>fs', ':SearchSelection<CR>',
    { noremap = true, silent = true, desc = "Search selection with Telescope" })
vim.keymap.set('n', '<space>fs', search_word_under_cursor,
    { noremap = true, silent = true, desc = "Search word under cursor with Telescope" })
