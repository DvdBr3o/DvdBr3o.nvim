return {
  { import = "lazyvim.plugins.extras.ui.edgy" },
  -- {
  --   "folke/edgy.nvim",
  --   event = "VeryLazy",
  --   keys = {
  --     {
  --       "<leader>ue",
  --       function()
  --         require("edgy").toggle()
  --       end,
  --       desc = "Edgy Toggle",
  --     },
  --     -- stylua: ignore
  --     { "<leader>uE", function() require("edgy").select() end, desc = "Edgy Select Window" },
  --   },
  --   opts = function()
  --     local opts = {
  --       bottom = {
  --         {
  --           ft = "toggleterm",
  --           size = { height = 0.4 },
  --           filter = function(buf, win)
  --             return vim.api.nvim_win_get_config(win).relative == ""
  --           end,
  --         },
  --         {
  --           ft = "noice",
  --           size = { height = 0.4 },
  --           filter = function(buf, win)
  --             return vim.api.nvim_win_get_config(win).relative == ""
  --           end,
  --         },
  --         "Trouble",
  --         { ft = "qf", title = "QuickFix" },
  --         {
  --           ft = "help",
  --           size = { height = 20 },
  --           -- don't open help files in edgy that we're editing
  --           filter = function(buf)
  --             return vim.bo[buf].buftype == "help"
  --           end,
  --         },
  --         { title = "Spectre", ft = "spectre_panel", size = { height = 0.4 } },
  --         { title = "Neotest Output", ft = "neotest-output-panel", size = { height = 15 } },
  --       },
  --       left = {
  --         { title = "Neotest Summary", ft = "neotest-summary" },
  --         -- "neo-tree",
  --       },
  --       right = {
  --         { title = "Grug Far", ft = "grug-far", size = { width = 0.4 } },
  --       },
  --       keys = {
  --         -- increase width
  --         ["<c-Right>"] = function(win)
  --           win:resize("width", 2)
  --         end,
  --         -- decrease width
  --         ["<c-Left>"] = function(win)
  --           win:resize("width", -2)
  --         end,
  --         -- increase height
  --         ["<c-Up>"] = function(win)
  --           win:resize("height", 2)
  --         end,
  --         -- decrease height
  --         ["<c-Down>"] = function(win)
  --           win:resize("height", -2)
  --         end,
  --       },
  --     }

  --     if LazyVim.has("neo-tree.nvim") then
  --       local pos = {
  --         filesystem = "left",
  --         buffers = "top",
  --         git_status = "right",
  --         document_symbols = "bottom",
  --         diagnostics = "bottom",
  --       }
  --       local sources = LazyVim.opts("neo-tree.nvim").sources or {}
  --       for i, v in ipairs(sources) do
  --         table.insert(opts.left, i, {
  --           title = "Neo-Tree " .. v:gsub("_", " "):gsub("^%l", string.upper),
  --           ft = "neo-tree",
  --           filter = function(buf)
  --             return vim.b[buf].neo_tree_source == v
  --           end,
  --           pinned = true,
  --           open = function()
  --             vim.cmd(("Neotree show position=%s %s dir=%s"):format(pos[v] or "bottom", v, LazyVim.root()))
  --           end,
  --         })
  --       end
  --     end

  --     -- trouble
  --     for _, pos in ipairs({ "top", "bottom", "left", "right" }) do
  --       opts[pos] = opts[pos] or {}
  --       table.insert(opts[pos], {
  --         ft = "trouble",
  --         filter = function(_buf, win)
  --           return vim.w[win].trouble
  --             and vim.w[win].trouble.position == pos
  --             and vim.w[win].trouble.type == "split"
  --             and vim.w[win].trouble.relative == "editor"
  --             and not vim.w[win].trouble_preview
  --         end,
  --       })
  --     end

  --     -- snacks terminal
  --     for _, pos in ipairs({ "top", "bottom", "left", "right" }) do
  --       opts[pos] = opts[pos] or {}
  --       table.insert(opts[pos], {
  --         ft = "snacks_terminal",
  --         size = { height = 0.4 },
  --         title = "%{b:snacks_terminal.id}: %{b:term_title}",
  --         filter = function(_buf, win)
  --           return vim.w[win].snacks_win
  --             and vim.w[win].snacks_win.position == pos
  --             and vim.w[win].snacks_win.relative == "editor"
  --             and not vim.w[win].trouble_preview
  --         end,
  --       })
  --     end
  --     return opts
  --   end,
  -- },
  {
    "folke/persistence.nvim",
    event = "BufReadPre",
    opts = {},
    lazy = false,
    -- stylua: ignore
    keys = {
      { "<leader>qs", function() require("persistence").load() end, desc = "Restore Session" },
      { "<leader>qS", function() require("persistence").select() end,desc = "Select Session" },
      { "<leader>ql", function() require("persistence").load({ last = true }) end, desc = "Restore Last Session" },
      { "<leader>qd", function() require("persistence").stop() end, desc = "Don't Save Current Session" },
    },
  },
  {
    "akinsho/bufferline.nvim",
    event = "VeryLazy",
    keys = {
      { "<leader>bp", "<Cmd>BufferLineTogglePin<CR>", desc = "Toggle Pin" },
      { "<leader>bP", "<Cmd>BufferLineGroupClose ungrouped<CR>", desc = "Delete Non-Pinned Buffers" },
      { "<leader>br", "<Cmd>BufferLineCloseRight<CR>", desc = "Delete Buffers to the Right" },
      { "<leader>bl", "<Cmd>BufferLineCloseLeft<CR>", desc = "Delete Buffers to the Left" },
      { "<S-h>", "<cmd>BufferLineCyclePrev<cr>", desc = "Prev Buffer" },
      { "<S-l>", "<cmd>BufferLineCycleNext<cr>", desc = "Next Buffer" },
      { "[b", "<cmd>BufferLineCyclePrev<cr>", desc = "Prev Buffer" },
      { "]b", "<cmd>BufferLineCycleNext<cr>", desc = "Next Buffer" },
      { "[B", "<cmd>BufferLineMovePrev<cr>", desc = "Move buffer prev" },
      { "]B", "<cmd>BufferLineMoveNext<cr>", desc = "Move buffer next" },
    },
    opts = {
      options = {
        hover = {
          enabled = true,
          delay = 200,
          reveal = { "close" },
        },
        -- stylua: ignore
        close_command = function(n) Snacks.bufdelete(n) end,
        -- stylua: ignore
        right_mouse_command = function(n) Snacks.bufdelete(n) end,
        diagnostics = "nvim_lsp",
        always_show_bufferline = false,
        diagnostics_indicator = function(_, _, diag)
          local icons = LazyVim.config.icons.diagnostics
          local ret = (diag.error and icons.Error .. diag.error .. " " or "")
            .. (diag.warning and icons.Warn .. diag.warning or "")
          return vim.trim(ret)
        end,
        offsets = {
          {
            filetype = "neo-tree",
            text = "Neo-tree",
            highlight = "Directory",
            text_align = "left",
          },
        },
        ---@param opts bufferline.IconFetcherOpts
        get_element_icon = function(opts)
          return LazyVim.config.icons.ft[opts.filetype]
        end,
      },
    },
    config = function(_, opts)
      require("bufferline").setup(opts)
      -- Fix bufferline when restoring a session
      vim.api.nvim_create_autocmd({ "BufAdd", "BufDelete" }, {
        callback = function()
          vim.schedule(function()
            pcall(nvim_bufferline)
          end)
        end,
      })
    end,
  },
  {
    "nvim-neo-tree/neo-tree.nvim",
    branch = "v3.x",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "nvim-tree/nvim-web-devicons", -- not strictly required, but recommended
      "MunifTanjim/nui.nvim",
      -- "3rd/image.nvim", -- Optional image support in preview window: See `# Preview Mode` for more information
    },
  },
}
