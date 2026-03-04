return {
  {
    "stevearc/conform.nvim",
    opts = {
      formatters_by_ft = {
        cpp = { "clang-format" },
        c = { "clang-format" },
      },
    },
    formatters = {
      ["clang-format"] = {
        prepend_args = { "--style=file" },
      },
    },
  },
}
