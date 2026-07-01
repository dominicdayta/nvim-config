return {
  {
    "folke/tokyonight.nvim",
    lazy = false,    -- Load this immediately on startup
    priority = 1000, -- Make sure it loads before other plugins
    config = function()
      -- Activate the colorscheme
      vim.cmd([[colorscheme tokyonight-storm]])
    end,
  }
}
