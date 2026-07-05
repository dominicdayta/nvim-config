return {
  {
    "OXY2DEV/markview.nvim",
    ft = { "markdown" }, -- Only loads when you open a Markdown file
    dependencies = {
      "nvim-treesitter/nvim-treesitter",
      "nvim-tree/nvim-web-devicons"
    },
    opts = {
      -- Enables real-time rendering adjustments under your cursor
      hybrid_mode = true, 
      
      -- Prevents rendering glitches if you use line wrapping in Goyo
      modes = { "n", "i", "no", "c" }, 
    }
  },
  {
    "nvim-treesitter/nvim-treesitter",
    opts = function(_, opts)
      -- Ensure Neovim has the required parsers downloaded
      if type(opts.ensure_installed) == "table" then
        vim.list_extend(opts.ensure_installed, { "markdown", "markdown_inline", "html" })
      end
    end,
  }
}

