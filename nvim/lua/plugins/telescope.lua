return {
	{
		"nvim-telescope/telescope.nvim",
		tag = "0.1.5",
		dependencies = {
			{ "nvim-lua/plenary.nvim" },
			{ "BurntSushi/ripgrep" },
			{ "nvim-telescope/telescope-fzf-native.nvim", build = "make" },
		},
		config = function()
			local builtin = require("telescope.builtin")
			vim.keymap.set("n", "<Leader>ff", builtin.find_files, {})
			vim.keymap.set("n", "<C-p>", builtin.git_files, {})
			vim.keymap.set("n", "<Leader>fg", builtin.live_grep, {})
			vim.keymap.set("n", "<Leader>fb", builtin.buffers, {})
			require("telescope").setup {
				defaults = {
					mappings = {
						i = { ["<C-[>"] = "close" },
					},
				},
			}
		end
	},
	{
		"nvim-telescope/telescope-ui-select.nvim",
		config = function()
			local telescope = require("telescope")
			telescope.setup {
				extensions = {
					["ui-select"] = {
						require("telescope.themes").get_dropdown()
					}
				}
			}
			telescope.load_extension("ui-select")
		end
	},
}

