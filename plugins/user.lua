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
    cmd = "Copilot",
    event = "InsertEnter",
    config = function()
      require("copilot").setup({
        suggestion = {auto_trigger = true, accept = false}
      })
    end
  }, {
    "hrsh7th/nvim-cmp",
    opts = function(_, opts)
      -- opts parameter is the default options table
      -- the function is lazy loaded so cmp is able to be required
      local cmp = require "cmp"
      local luasnip = require "luasnip"
      local has_words_before = function()
        local cursor = vim.api.nvim_win_get_cursor(0)
        return
            (vim.api.nvim_buf_get_lines(0, cursor[1] - 1, cursor[1], true)[1] or
                ''):sub(cursor[2], cursor[2]):match('%s')
      end
      -- modify the mapping part of the table
      opts.mapping["<Tab>"] = cmp.mapping(function(fallback)
        if require("copilot.suggestion").is_visible() then
          require("copilot.suggestion").accept()
        elseif cmp.visible() then
          cmp.select_next_item({behavior = cmp.SelectBehavior.Insert})
        elseif luasnip.expandable() then
          luasnip.expand()
        elseif has_words_before() then
          cmp.complete()
        else
          fallback()
        end
      end, {"i", "s"})
      return opts
    end
  }, {"David-Kunz/jester"}, {
    "iamcco/markdown-preview.nvim",
    build = "cd app && npm install",
    init = function() vim.g.mkdp_filetypes = {"markdown"} end,
    ft = {"markdown"}
  }
}
