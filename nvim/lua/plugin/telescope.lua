return {
	{
		"nvim-telescope/telescope.nvim",
		tag = "0.1.x",
		dependencies = {
			{ "nvim-lua/plenary.nvim" },
			{ "BurntSushi/ripgrep" },
			{
				"nvim-telescope/telescope-fzf-native.nvim",
				build = "make",
				cond = function() return vim.fn.executable 'make' == 1 end, -- load only if 'make' is available
			},
			{ "nvim-telescope/telescope-ui-select.nvim" },
		},
		config = function()
			local builtin = require("telescope.builtin")
			vim.keymap.set("n", "<Leader>ff",	builtin.find_files,		{ desc = "Tele: [F]ind [F]iles" })
			vim.keymap.set("n", "<C-p>",		builtin.git_files,		{ desc = "Tele: VS***e mapping" })
			vim.keymap.set("n", "<Leader>fg",	builtin.live_grep, 		{ desc = "Tele: [F]ind with [G]rep" })
			vim.keymap.set("n", "<Leader>fw",	builtin.grep_string,	{ desc = "Tele: [F]ind [W]ord under cursor" })
			vim.keymap.set("n", "<Leader>fb",	builtin.buffers,		{ desc = "Tele: [F]ind in [B]uffers" })
			vim.keymap.set("n", "<Leader>fd",	builtin.diagnostics,	{ desc = "Tele: [F]ind in [D]iagnostics" })
			vim.keymap.set("n", "<Leader>fr",	builtin.resume,			{ desc = "Tele: [F]ind [R]esume" })
			vim.keymap.set("n", "<leader>/", function()
				builtin.current_buffer_fuzzy_find(require("telescope.themes").get_dropdown {
					winblend = 10,
					previewer = false,
				})
			end, { desc = "Tele: [<Leader>/] Fuzzily search current buffer" })
			vim.keymap.set("n", "<leader>fc", function()
				builtin.find_files { cwd = vim.fn.stdpath "config" }
			end, { desc = "[F]ind neovim [C]onfig files" })

			local telescope = require("telescope")
			telescope.setup {
				defaults = {
					mappings = {
						i = { ["<C-[>"] = "close" },
					},
				},
				extensions = {
					["ui-select"] = { require("telescope.themes").get_dropdown() }
				},
			}

			telescope.load_extension("fzf")
			telescope.load_extension("ui-select")
		end
	},
}

