return {
  {
    "akinsho/toggleterm.nvim",
    cmd = "ToggleTerm",
    keys = {
      { "<leader>tg", "<cmd>ToggleTerm<cr>", desc = "Toggle Terminal" },
      { "<C-`>", "<cmd>ToggleTerm<cr>", desc = "Toggle Terminal" }, -- TODO: Make "Ctrl+`" available.
    },
    version = "*",
    opts = {
      shell = "nu",
    },
  },
}
