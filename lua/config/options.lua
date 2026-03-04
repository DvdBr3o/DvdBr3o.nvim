-- Options are automatically loaded before lazy.nvim startup
-- Default options that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/options.lua
-- Add any additional options here

-- INFO: If you use termux ssh -> windows -> wsl, remember
-- `[Environment]::SetEnvironmentVairable("WSLENV", "TERM/u", "User")`
-- to pass env var `$TERM`. And of course pass `TERM=xterm-termux` if
-- you use termux ssh.
if os.getenv("TERM") == "xterm-termux" then
  vim.g.terminal_ansi_colors = {}
  vim.opt.guicursor = "a:blinkon0"

  local function smear_out_sp()
    for _, group in ipairs(vim.fn.getcompletion("", "highlight")) do
      local hl = vim.api.nvim_get_hl(0, { name = group, link = false })
      if hl.sp or hl.undercurl then
        vim.api.nvim_set_hl(0, group, {
          fg = hl.fg,
          bg = hl.bg,
          underline = (hl.underline or hl.undercurl),
          undercurl = false,
          sp = nil,
          force = true,
        })
      end
    end
  end

  vim.api.nvim_create_autocmd("LspTokenUpdate", {
    callback = function(args)
      local token = args.data.token
    end,
  })

  vim.api.nvim_create_autocmd("ColorScheme", {
    callback = function()
      vim.schedule(smear_out_sp)
    end,
  })
end

local opt = vim.opt

opt.tabstop = 4
opt.shiftwidth = 4

-- Neovide --
if vim.g.neovide then
  opt.guifont = "CaskaydiaCove Nerd Font Mono:14"
end
