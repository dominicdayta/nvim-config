return {
  {
    "R-nvim/R.nvim",
    -- Crucial: lazy = false ensures tree-sitter parsers sync correctly 
    lazy = false,
    -- Clones dependencies and submodules natively via Lazy
    submodules = true,
    dependencies = {
      "R-nvim/cmp-r", -- Autocompletion source for R objects/functions
    },
    opts = {
      -- Customizes arguments passed when initializing the console
      R_args = { "--quiet", "--no-save" },
      
      -- Forces the R console to use Neovim's internal terminal splits
      R_external_term = false,
      
      -- Setup local buffer keymaps when an R or Rmd file loads
      hook = {
        on_filetype = function()
          -- Use standard Enter to execute code smoothly
          vim.keymap.set("n", "<Enter>", "<Plug>RDSendLine", { buffer = true, desc = "Send line to R" })
          vim.keymap.set("x", "<Enter>", "<Plug>RSendSelection", { buffer = true, desc = "Send selection to R" })
        end,
      },
      
      -- RStudio UI Layout Emulation
      min_editor_width = 18,
      rconsole_width = 0,      -- Let splits divide naturally
      rconsole_height = 15,     -- Spawns the R Console along the bottom layout
      objbr_mappings = {       -- Quick navigation keys inside your Object Browser
        k = "browser_move_up",
        j = "browser_move_down",
      },
    },
    config = function(_, opts)
      require("r").setup(opts)
    end,
  },
  -- Ensure Tree-sitter has the required parsers for clean code evaluation
  {
    "nvim-treesitter/nvim-treesitter",
    opts = function(_, opts)
      if type(opts.ensure_installed) == "table" then
        vim.list_extend(opts.ensure_installed, { "r", "markdown", "markdown_inline", "csv" })
      end
    end,
  }
}
