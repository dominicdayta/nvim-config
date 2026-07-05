return {
  {
    'junegunn/goyo.vim',
    cmd = "Goyo",
    keys = {
      { "<leader>g", "<cmd>Goyo<cr>", desc = "Toggle Goyo (Prose Mode)" },
    },
    dependencies = { 'junegunn/limelight.vim' },
    config = function()
      local goyo_grp = vim.api.nvim_create_augroup("GoyoProse", { clear = true })

      -- Minimal word counter for Lualine to read natively
      local function get_words()
        local stats = vim.fn.wordcount()
        local words = stats.visual_words or stats.words
        return tostring(words) .. " words"
      end

      vim.api.nvim_create_autocmd("User", {
        pattern = "GoyoEnter",
        group = goyo_grp,
        callback = function()
          vim.opt_local.wrap = true
          vim.opt_local.linebreak = true
          vim.opt_local.scrolloff = 999
          vim.cmd("Limelight")

          -- Safely instruct Lualine to switch to a clean prose layout
          local has_lualine, lualine = pcall(require, "lualine")
          if has_lualine then
            lualine.setup({
              sections = {
                lualine_a = {}, lualine_b = {}, lualine_c = {},
                lualine_x = {}, lualine_y = {},
                lualine_z = { { get_words } } -- Shows ONLY word count in the bottom right
              }
            })
          end
        end,
      })

      vim.api.nvim_create_autocmd("User", {
        pattern = "GoyoLeave",
        group = goyo_grp,
        callback = function()
          vim.opt_local.wrap = false
          vim.opt_local.linebreak = false
          vim.opt_local.scrolloff = 5
          vim.cmd("Limelight!")

          -- Reload your regular Lualine programming layout when exiting
          local has_lualine, lualine = pcall(require, "lualine")
          if has_lualine then
            -- This resets Lualine back to your default configuration
            lualine.setup() 
          end
        end,
      })
    end
  }
}

