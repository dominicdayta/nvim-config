return {
  "nvim-tree/nvim-tree.lua",
  version = "*",
  lazy = false,
  dependencies = {
    "nvim-tree/nvim-web-devicons", -- optional, for file icons
  },
  config = function()
    -- Recommended: disable netrw at the start of init.lua (nvim-tree requirement)
    vim.g.loaded_netrw = 1
    vim.g.loaded_netrwPlugin = 1

    -- Set termguicolors to enable highlight groups
    vim.opt.termguicolors = true

    require("nvim-tree").setup({
      sort = {
        sorter = "case_sensitive",
      },
      view = {
        width = 30,
        relativenumber = true,
      },
      renderer = {
        group_empty = true,
      },
      filters = {
        dotfiles = false, -- Set to true if you want to hide dotfiles by default
      },
    })

    -- Keymap to toggle the tree
    vim.keymap.set("n", "<C-n>", ":NvimTreeToggle<CR>", { desc = "Toggle NvimTree", silent = true })
    vim.keymap.set("n", "<leader>e", ":NvimTreeFocus<CR>", { desc = "Focus NvimTree", silent = true })
  end,
}
