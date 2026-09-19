-- fsociety Neovim. Omarchy's aether colorscheme, fed the theme palette, plus
-- three overrides that follow the theme rule: red marks the cursor line
-- number (focus), diagnostic errors, and the current search match. Everything
-- else stays neutral.
--
-- Lua, so a git-installed theme cannot ship it: opt in with a symlinked
-- working copy (see README).
return {
  {
    "bjarneo/aether.nvim",
    branch = "v3",
    name = "aether",
    priority = 1000,
    opts = {
      colors = {
        bg = "#0c0f11",
        dark_bg = "#080a0c",
        darker_bg = "#050607",
        lighter_bg = "#161a1d",

        fg = "#c3cbce",
        dark_fg = "#5c686c",
        light_fg = "#afb9bd",
        bright_fg = "#e2e9eb",
        muted = "#3a4448",

        red = "#c7423c",
        yellow = "#c9a15a",
        orange = "#c97c4a",
        green = "#5a8f6e",
        cyan = "#4c8c93",
        blue = "#4a6e8c",
        magenta = "#8c6076",
        brown = "#6e4a3c",

        bright_red = "#ec5f55",
        bright_yellow = "#e4c07b",
        bright_green = "#7dbe95",
        bright_cyan = "#74bfc5",
        bright_blue = "#6e9bbd",
        bright_magenta = "#b4879c",

        accent = "#d8463f",
        cursor = "#d8463f",
        foreground = "#c3cbce",
        background = "#0c0f11",
        selection = "#2a1a1a",
        selection_foreground = "#e2e9eb",
        selection_background = "#2a1a1a",
      },
    },
  },
  {
    "LazyVim/LazyVim",
    opts = {
      colorscheme = "aether",
    },
    init = function()
      vim.api.nvim_create_autocmd("ColorScheme", {
        group = vim.api.nvim_create_augroup("fsociety_hud", { clear = true }),
        pattern = "aether",
        callback = function()
          local set = vim.api.nvim_set_hl
          set(0, "CursorLineNr", { fg = "#d8463f", bold = true })
          set(0, "LineNr", { fg = "#3a4448" })
          set(0, "CurSearch", { fg = "#e2e9eb", bg = "#c7423c" })
          set(0, "Search", { fg = "#e2e9eb", bg = "#2a1a1a" })
          set(0, "DiagnosticError", { fg = "#d8463f" })
          set(0, "DiagnosticUnderlineError", { sp = "#d8463f", undercurl = true })
        end,
      })
    end,
  },
}
