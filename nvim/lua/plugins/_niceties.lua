vim.api.nvim_create_autocmd("TextYankPost", {
	desc = "visual feedback on yank",
	group = vim.api.nvim_create_augroup("kickstart-highlight-yank", { clear = true }),
	callback = function() vim.highlight.on_yank() end,
})

return {
	{
		"catppuccin/nvim",
		priority = 1000,
		lazy = false,
		name = "catppuccin",
		config = function()
			vim.cmd.colorscheme "catppuccin"
		end
	},
	{
		"nvim-tree/nvim-web-devicons",
		opts = {}
	},
	{
		-- maybe move to mini.pairs?
		"windwp/nvim-autopairs",
		event = "InsertEnter",
		opts = {}
	},
	{
		-- maybe move to mini.comment?
		"numToStr/Comment.nvim",
		opts = {}
	},
	{
		"echasnovski/mini.nvim",
		config = function()
			require("mini.ai").setup { n_lines = 500 }
			require("mini.surround").setup()
		end
	},
	{
		"tpope/vim-sleuth",
	},
	{
		"nvim-lualine/lualine.nvim",
		dependencies = { "nvim-tree/nvim-web-devicons" },
		opts = {}
	},

	-- consider: 
	--     lukas-reineke/indent-blankline.nvim -- vertical lines for indents
	--     mini.sessions -- remember where you left off
}

