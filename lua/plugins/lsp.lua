return {
  -- 1. Modern LSP Configuration (Neovim 0.11+ Standards)
  {
    "neovim/nvim-lspconfig",
    dependencies = {
      -- Automatically install LSPs to stdpath for neovim
      "williamboman/mason.nvim",
      "williamboman/mason-lspconfig.nvim",
      -- Allows extra capabilities provided by nvim-cmp
      "hrsh7th/cmp-nvim-lsp",
    },
    config = function()
      -- Set up Mason first so it can download tools
      require("mason").setup()

      -- Define your required servers in an array
      local servers = {
        "vtsls",             -- JavaScript / TypeScript
        "clangd",            -- C++
        "pyright",           -- Python
        "r_language_server", -- R
      }

      -- Ensure your specific language servers are installed automatically
      require("mason-lspconfig").setup({
        ensure_installed = servers,
      })

      -- Broadcast nvim-cmp's autocomplete capabilities globally to ALL language configs
      local capabilities = require("cmp_nvim_lsp").default_capabilities()
      vim.lsp.config("*", {
        capabilities = capabilities,
      })

      -- Loop through and turn on each server natively
      -- (Bypasses the deprecated require('lspconfig')[name].setup() completely)
      for _, server_name in ipairs(servers) do
        vim.lsp.enable(server_name)
      end
    end,
  },

  -- 2. Autocompletion Engine Setup
  {
    "hrsh7th/nvim-cmp",
    dependencies = {
      "hrsh7th/cmp-buffer",
      "hrsh7th/cmp-path",
      -- ── SNIPPET ENGINE & SOURCES ──────────────────────────────────
      "L3MON4D3/LuaSnip",             -- The main snippet engine
      "saadparwaiz1/cmp_luasnip",     -- Bridges LuaSnip into nvim-cmp
      "rafamadriz/friendly-snippets", -- Ready-to-use snippets for JS, C++, Python, R
    },
    config = function()
      local cmp = require("cmp")
      local luasnip = require("luasnip")

      -- Load VSCode-like snippets (from friendly-snippets)
      require("luasnip.loaders.from_vscode").lazy_load()

      cmp.setup({
        -- Link your snippet engine to nvim-cmp
        snippet = {
          expand = function(args)
            luasnip.lsp_expand(args.body)
          end,
        },
        
        -- Smart keymappings for autocompletion and snippet jumping
        mapping = cmp.mapping.preset.insert({
          ["<C-Space>"] = cmp.mapping.complete(),
          ["<CR>"] = cmp.mapping.confirm({ select = true }),
          
          -- Tab key behavior: Move to next item or jump forward inside a snippet
          ["<Tab>"] = cmp.mapping(function(fallback)
            if cmp.visible() then
              cmp.select_next_item()
            elseif luasnip.expand_or_jumpable() then
              luasnip.expand_or_jump()
            else
              fallback()
            end
          end, { "i", "s" }),

          -- Shift+Tab key behavior: Move to previous item or jump backward inside a snippet
          ["<S-Tab>"] = cmp.mapping(function(fallback)
            if cmp.visible() then
              cmp.select_prev_item()
            elseif luasnip.jumpable(-1) then
              luasnip.jump(-1)
            else
              fallback()
            end
          end, { "i", "s" }),
        }),

        -- Tell nvim-cmp to include snippets in the suggestion menu
        sources = cmp.config.sources({
          { name = "nvim_lsp" },
          { name = "luasnip" }, -- Adds your code templates to the menu
          { name = "buffer" },
          { name = "path" },
        }),
      })
    end,
  },
}

