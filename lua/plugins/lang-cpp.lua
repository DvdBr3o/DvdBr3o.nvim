return {
  {
    "Mythos-404/xmake.nvim",
    lazy = false,
    version = "^3",
    event = "BufReadPost xmake.lua",
    config = true,
  },
  {
    "nvim-treesitter/nvim-treesitter",
    opts = { ensure_installed = { "cpp" } },
  },
  {
    "p00f/clangd_extensions.nvim",
    lazy = true,
    config = function() end,
    opts = {
      inlay_hints = {
        inline = false,
      },
      ast = {
        --These require codicons (https://github.com/microsoft/vscode-codicons)
        role_icons = {
          type = "",
          declaration = "",
          expression = "",
          specifier = "",
          statement = "",
          ["template argument"] = "",
        },
        kind_icons = {
          Compound = "",
          Recovery = "",
          TranslationUnit = "",
          PackExpansion = "",
          TemplateTypeParm = "",
          TemplateTemplateParm = "",
          TemplateParamObject = "",
        },
      },
    },
  },
  {
    "neovim/nvim-lspconfig",
    opts = {
      servers = {
        -- Ensure mason installs the server
        clangd = {
          keys = {
            { "<leader>ch", "<cmd>ClangdSwitchSourceHeader<cr>", desc = "Switch Source/Header (C/C++)" },
          },
          root_dir = function(fname)
            return require("lspconfig.util").root_pattern(
              "Makefile",
              "configure.ac",
              "configure.in",
              "config.h.in",
              "meson.build",
              "meson_options.txt",
              "build.ninja"
            )(fname) or require("lspconfig.util").root_pattern("compile_commands.json", "compile_flags.txt")(
              fname
            ) or require("lspconfig.util").find_git_ancestor(fname)
          end,
          capabilities = {
            offsetEncoding = { "utf-16" },
          },
          cmd = {
            "clangd",
            "--background-index",
            "--clang-tidy",
            "--header-insertion=iwyu",
            "--completion-style=detailed",
            "--function-arg-placeholders",
            "--fallback-style=llvm",
          },
          init_options = {
            usePlaceholders = true,
            completeUnimported = true,
            clangdFileStatus = true,
          },
        },
      },
      setup = {
        clangd = function(_, opts)
          local clangd_ext_opts = LazyVim.opts("clangd_extensions.nvim")
          require("clangd_extensions").setup(vim.tbl_deep_extend("force", clangd_ext_opts or {}, { server = opts }))
          return false
        end,
      },
    },
  },
  {
    "nvim-cmp",
    opts = function(_, opts)
      table.insert(opts.sorting.comparators, 1, require("clangd_extensions.cmp_scores"))
    end,
  },
  {
    "mfussenegger/nvim-dap",
    recommended = true,
    desc = "Debugging support. Requires language specific adapters to be configured. (see lang extras)",

    dependencies = {
      "rcarriga/nvim-dap-ui",
      -- virtual text for the debugger
      {
        "theHamsta/nvim-dap-virtual-text",
        opts = {},
      },
    },

		-- stylua: ignore
		keys = {
		  	{ "<leader>d", "", desc = "+debug", mode = {"n", "v"} },
		  	{ "<leader>dB", function() require("dap").set_breakpoint(vim.fn.input('Breakpoint condition: ')) end, desc = "Breakpoint Condition" },
		  	{ "<leader>db", function() require("dap").toggle_breakpoint() end, desc = "Toggle Breakpoint" },
		  	{ "<leader>dc", function() require("dap").continue() end, desc = "Continue" },
		  	{ "<leader>da", function() require("dap").continue({ before = get_args }) end, desc = "Run with Args" },
		  	{ "<leader>dC", function() require("dap").run_to_cursor() end, desc = "Run to Cursor" },
		  	{ "<leader>dg", function() require("dap").goto_() end, desc = "Go to Line (No Execute)" },
		  	{ "<leader>di", function() require("dap").step_into() end, desc = "Step Into" },
		  	{ "<leader>dj", function() require("dap").down() end, desc = "Down" },
		  	{ "<leader>dk", function() require("dap").up() end, desc = "Up" },
		  	{ "<leader>dl", function() require("dap").run_last() end, desc = "Run Last" },
		  	{ "<leader>do", function() require("dap").step_out() end, desc = "Step Out" },
		  	{ "<leader>dO", function() require("dap").step_over() end, desc = "Step Over" },
		  	{ "<leader>dp", function() require("dap").pause() end, desc = "Pause" },
		  	{ "<leader>dr", function() require("dap").repl.toggle() end, desc = "Toggle REPL" },
		  	{ "<leader>ds", function() require("dap").session() end, desc = "Session" },
		  	{ "<leader>dt", function() require("dap").terminate() end, desc = "Terminate" },
		  	{ "<leader>dw", function() require("dap.ui.widgets").hover() end, desc = "Widgets" },
		},

    config = function()
      -- load mason-nvim-dap here, after all adapters have been setup
      if LazyVim.has("mason-nvim-dap.nvim") then
        require("mason-nvim-dap").setup(LazyVim.opts("mason-nvim-dap.nvim"))
      end

      vim.api.nvim_set_hl(0, "DapStoppedLine", { default = true, link = "Visual" })

      for name, sign in pairs(LazyVim.config.icons.dap) do
        sign = type(sign) == "table" and sign or { sign }
        vim.fn.sign_define(
          "Dap" .. name,
          { text = sign[1], texthl = sign[2] or "DiagnosticInfo", linehl = sign[3], numhl = sign[3] }
        )
      end

      -- setup dap config by VsCode launch.json file
      local vscode = require("dap.ext.vscode")
      local json = require("plenary.json")
      vscode.json_decode = function(str)
        return vim.json.decode(json.json_strip_comments(str))
      end

      -- Extends dap.configurations with entries read from .vscode/launch.json
      if vim.fn.filereadable(".vscode/launch.json") then
        vscode.load_launchjs()
      end
    end,
  },
  {
    "rcarriga/nvim-dap-ui",
    dependencies = { "nvim-neotest/nvim-nio" },
  		-- stylua: ignore
  		keys = {
  		  { "<leader>du", function() require("dapui").toggle({ }) end, desc = "Dap UI" },
  		  { "<leader>de", function() require("dapui").eval() end, desc = "Eval", mode = {"n", "v"} },
  		},
    opts = {},
    config = function(_, opts)
      local dap = require("dap")
      local dapui = require("dapui")
      dapui.setup(opts)
      dap.listeners.after.event_initialized["dapui_config"] = function()
        dapui.open({})
      end
      dap.listeners.before.event_terminated["dapui_config"] = function()
        dapui.close({})
      end
      dap.listeners.before.event_exited["dapui_config"] = function()
        dapui.close({})
      end
    end,
  },
  {
    "theHamsta/nvim-dap-virtual-text",
    opts = {},
  },
  {
    -- Ensure C/C++ debugger is installed
    "williamboman/mason.nvim",
    optional = true,
    opts = { ensure_installed = { "codelldb" } },
  },
  {
    "eriks47/generate.nvim",
    dependencies = { "nvim-treesitter/nvim-treesitter" },
    keys = {
      {
        "<leader>cI",
        "<cmd>Generate implementations<cr>",
        desc = "Create implementation for declaration. (C/C++)",
      },
    },
  },
  {
    "jay-babu/mason-nvim-dap.nvim",
    dependencies = "mason.nvim",
    cmd = { "DapInstall", "DapUninstall" },
    opts = {
      -- Makes a best effort to setup the various debuggers with
      -- reasonable debug configurations
      automatic_installation = true,

      -- You can provide additional configuration to the handlers,
      -- see mason-nvim-dap README for more information
      handlers = {},

      -- You'll need to check that you have the required things installed
      -- online, please don't ask me how to install them :)
      ensure_installed = {
        -- Update this to ensure that you have the debuggers for the langs you want
      },
    },
    -- mason-nvim-dap is loaded when nvim-dap loads
    config = function() end,
  },
}
