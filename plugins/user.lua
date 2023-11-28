return {
  -- You can also add new plugins here as well:
  -- Add plugins, the lazy syntax
  -- "andweeb/presence.nvim",
  -- {
  --   "ray-x/lsp_signature.nvim",
  --   event = "BufRead",
  --   config = function()
  --     require("lsp_signature").setup()
  --   end,
  -- },
  {"olimorris/onedarkpro.nvim", priority = 1000}, {
    "zbirenbaum/copilot.lua",
    -- cmd = "Copilot",
    -- event = "InsertEnter",
    config = function()
      require("copilot").setup({
        suggestion = {suggestion = {enabled = false}, panel = {enabled = false}}
      })
    end
  }, {
    "zbirenbaum/copilot-cmp",
    event = {"InsertEnter", "LspAttach"},
    dependencies = {"zbirenbaum/copilot.lua"},
    config = function() require("copilot_cmp").setup() end
  }, {
    "hrsh7th/nvim-cmp",
    dependencies = {"zbirenbaum/copilot-cmp"},
    opts = function(_, opts)
      -- opts parameter is the default options table
      -- the function is lazy loaded so cmp is able to be required
      local cmp = require "cmp"
      local luasnip = require "luasnip"
      local lspkind = require "lspkind"
      -- local has_words_before = function()
      --   local cursor = vim.api.nvim_win_get_cursor(0)
      --   return
      --       (vim.api.nvim_buf_get_lines(0, cursor[1] - 1, cursor[1], true)[1] or
      --           ''):sub(cursor[2], cursor[2]):match('%s')
      -- end
      local has_words_before = function()
        if vim.api.nvim_buf_get_option(0, "buftype") == "prompt" then
          return false
        end
        local line, col = unpack(vim.api.nvim_win_get_cursor(0))
        return col ~= 0 and
                   vim.api.nvim_buf_get_text(0, line - 1, 0, line - 1, col, {})[1]:match(
                       "^%s*$") == nil
      end
      opts.sources = cmp.config.sources {
        {name = "nvim_lsp", priority = 1000},
        {name = "luasnip", priority = 750}, {name = "buffer", priority = 500},
        {name = "path", priority = 250}, {name = "copilot", priority = 1250}
      }
      opts.formatting = {
        format = lspkind.cmp_format({
          mode = "symbol",
          max_width = 50,
          symbol_map = {Copilot = ""}
        })
      }
      -- modify the mapping part of the table
      -- opts.mapping["<Tab>"] = cmp.mapping(function(fallback)
      --   if require("copilot.suggestion").is_visible() then
      --     require("copilot.suggestion").accept()
      --   elseif cmp.visible() then
      --     cmp.select_next_item({behavior = cmp.SelectBehavior.Insert})
      --   elseif luasnip.expandable() then
      --     luasnip.expand()
      --   elseif has_words_before() then
      --     cmp.complete()
      --   else
      --     fallback()
      --   end
      -- end, {"i", "s"})
      opts.mapping["<Tab>"] = vim.schedule_wrap(function(fallback)
        if cmp.visible() and has_words_before() then
          cmp.select_next_item({behavior = cmp.SelectBehavior.Select})
        else
          fallback()
        end
      end)
      return opts
    end
  }, {"David-Kunz/jester"}, {
    "iamcco/markdown-preview.nvim",
    build = "cd app && npm install",
    init = function() vim.g.mkdp_filetypes = {"markdown"} end,
    ft = {"markdown"}
  }, {
    "nvim-neotest/neotest",
    dependencies = {
      "nvim-lua/plenary.nvim", "nvim-treesitter/nvim-treesitter",
      "antoinemadec/FixCursorHold.nvim", "marilari88/neotest-vitest",
      "haydenmeade/neotest-jest"
    },
    config = function()
      require('neotest').setup({
        adapters = {require('neotest-vitest')},
        require('neotest-jest')({jestCommand = "yarn test --"})
      })
    end
  }, {
    "xilesun/clipboard-image.nvim",
    config = function()
      require('clipboard-image').setup({
        default = {img_dir = {"%:p:h", "static"}, img_dir_txt = "./static"}
      })
    end
  }
}
