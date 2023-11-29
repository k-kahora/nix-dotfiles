local builtin = require('telescope.builtin')
vim.keymap.set('n', '<leader>ff', ":Telescope find_files<CR>", { desc = "Find Files"})
-- vim.keymap.set('n', '<leader>fg', "<cmd>lua require('telescope').extensions.live_grep_args.live_grep_args()<CR>", { desc = "Live Grep"})
-- vim.keymap.set('n', '<leader>fc', '<cmd>lua require("telescope.builtin").live_grep({ glob_pattern = "!{spec,test}"})<CR>', { desc = "Live Grep Code"})
-- vim.keymap.set('n', '<leader>fb', builtin.buffers, { desc = "Find Buffers"})
-- vim.keymap.set('n', '<leader>fh', builtin.help_tags, { desc = "Find Help Tags"})
-- vim.keymap.set('n', '<leader>fs', builtin.lsp_document_symbols, { desc = "Find Symbols"})
-- vim.keymap.set('n', '<leader>fi', '<cmd>AdvancedGitSearch<CR>', { desc = "AdvancedGitSearch"})
-- vim.keymap.set('n', '<leader>fo', builtin.oldfiles, { desc = "Find Old Files"})
-- vim.keymap.set('n', '<leader>fw', builtin.grep_string, { desc = "Find Word under Cursor"})
-- vim.keymap.set('n', '<leader>gc', builtin.git_commits, { desc = "Search Git Commits"})
-- vim.keymap.set('n', '<leader>gb', builtin.git_bcommits, { desc = "Search Git Commits for Buffer"})
--
require('telescope').setup({
	extensions = {
    	fzf = {
      	fuzzy = true,                    -- false will only do exact matching
      	override_generic_sorter = true,  -- override the generic sorter
      	override_file_sorter = true,     -- override the file sorter
      	case_mode = "smart_case",        -- or "ignore_case" or "respect_case"
                                       -- the default case_mode is "smart_case"
    	}
  	}
})

require('telescope').load_extension('fzf')

