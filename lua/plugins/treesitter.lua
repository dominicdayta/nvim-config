return {
  {
    "nvim-treesitter/nvim-treesitter",
    build = ":TSUpdate",
    opts = {
      -- Ensures Python and core syntax engines are loaded across your devices
      ensure_installed = { 
          "python", 
          "lua", 
          "vim", 
          "vimdoc", 
          "query", 
          "javascript",
          "cpp",
          "r",
      },
      
      highlight = {
        enable = true,
        additional_vim_regex_highlighting = false,
      },
    },
    config = function(_, opts)
      -- Modern Treesitter uses its root module directly for setup
      require("nvim-treesitter").setup(opts)
    end,
  }
}
