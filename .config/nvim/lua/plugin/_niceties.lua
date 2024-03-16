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
            require("catppuccin").setup({
                integrations = {
                    cmp = true,
                    mason = true,
                    neotree = true,
                }
            })
        end
    },
    {
        'AlexvZyl/nordic.nvim',
        priority = 1000,
        lazy = false,
        config = function()
            -- require('nordic').setup { }
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
        -- supposedly lazy and fast
        "nvim-lualine/lualine.nvim",
        dependencies = { "nvim-tree/nvim-web-devicons" },
        opts = {
            options = {
                component_separators = '',
                section_separators = '',
            },
            sections = {
                lualine_b = { {"branch", icon="󰊢"}, "diff", "diagnostics" },
                lualine_c = { {"filename", path=1} },
                lualine_x = {function()
                    -- show attached LSP servers 
                    local clients = vim.lsp.get_clients()
                    if next(clients) == nil then return '' end
                    local c = {}
                    for _, client in pairs(clients) do table.insert(c, client.name) end
                    return "\u{f085} " .. table.concat(c, ",")
                end},
                lualine_y = {"encoding", {"fileformat",icons_enabled=true,symbols={unix="LF",dos="CRLF",mac="CR"}} },
            },
            tabline = {
                lualine_a = {"buffers"},
            },
            -- globalstatus = true, -- single statusline at bottom instead of every window
        }
    },
    -- investigate BLAZINGLY FAST and lazy "https://github.com/NvChad/NvChad?tab=readme-ov-file"
    -- consider: 
    --     m4xshen/hardtime.nvim -- practice vim motions
    --     lukas-reineke/indent-blankline.nvim -- vertical lines for indents
    --     mini.sessions -- remember where you left off
}

