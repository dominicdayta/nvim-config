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

          -- 1. TURN OFF LSP FOR THIS BUFFER
          -- This detaches any active LSP servers from the current writing file
          local clients = vim.lsp.get_clients({ bufnr = 0 })
          for _, client in ipairs(clients) do
            vim.lsp.buf_detach_client(0, client.id)
          end

          -- 2. TURN OFF AUTOCOMPLETION
          -- Safely instructs nvim-cmp to pause suggestions
          local has_cmp, cmp = pcall(require, "cmp")
          if has_cmp then
            cmp.setup.buffer({ enabled = false })
          end

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

          -- 3. RE-ENABLE AUTOCOMPLETION
          -- Restores standard completion behavior when you exit
          local has_cmp, cmp = pcall(require, "cmp")
          if has_cmp then
            cmp.setup.buffer({ enabled = true })
          end
          
          -- Note: LSP will automatically reconnect the next time you open a code file, 
          -- but if you want to force it right away on this buffer, you can run :LspStart

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
