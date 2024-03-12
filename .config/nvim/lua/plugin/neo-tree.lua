return {
  "nvim-neo-tree/neo-tree.nvim",
  branch = "v3.x",
  dependencies = {
    "nvim-lua/plenary.nvim", -- lua helpers
    "MunifTanjim/nui.nvim", -- ui powers
    -- "3rd/image.nvim", -- optional image support in preview window
  },
  config = function()
    vim.keymap.set("n", "\\", ":Neotree toggle current reveal_force_cwd<CR>", {})
    vim.keymap.set("n", "|", ":Neotree toggle reveal<CR>", {})
    require("neo-tree").setup {
      close_if_last_window = true,
    }
  end
}
