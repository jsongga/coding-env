local wezterm = require("wezterm")

-- ~/.config/wezterm/wezterm.lua
return {
  window_decorations = "RESIZE",
  window_padding = {
    left = 8,
    right = 8,
    top = 4,
    bottom = 4,
  },
  window_background_opacity = 0.95,
  macos_window_background_blur = 20, -- Mac only: cool frosted-glass effect
  wezterm.on("format-tab-title", function(tab)
    local title = tab.active_pane.title
    local process = tab.active_pane.foreground_process_name
    return string.format(" %s | %s ", wezterm.basename(process or ""), title)
  end),
  enable_tab_bar = true,
  use_fancy_tab_bar = false,
  animation_fps = 120,
  max_fps = 120,
  front_end = "WebGpu",             -- GPU-accelerated rendering
  color_scheme = "tokyonight_storm", -- Must match the [metadata] name
  color_schemes = {
    tokyonight_storm = {
      foreground = "#c0caf5",
      background = "#24283b",
      cursor_bg = "#c0caf5",
      cursor_border = "#c0caf5",
      cursor_fg = "#24283b",
      selection_bg = "#2e3c64",
      selection_fg = "#c0caf5",
      split = "#7aa2f7",
      compose_cursor = "#ff9e64",
      scrollbar_thumb = "#292e42",

      ansi = {
        "#1d202f",
        "#f7768e",
        "#9ece6a",
        "#e0af68",
        "#7aa2f7",
        "#bb9af7",
        "#7dcfff",
        "#a9b1d6",
      },

      brights = {
        "#414868",
        "#ff899d",
        "#9fe044",
        "#faba4a",
        "#8db0ff",
        "#c7a9ff",
        "#a4daff",
        "#c0caf5",
      },

      tab_bar = {
        inactive_tab_edge = "#1f2335",
        background = "#24283b",
        active_tab = { fg_color = "#1f2335", bg_color = "#7aa2f7" },
        inactive_tab = { fg_color = "#545c7e", bg_color = "#292e42" },
        inactive_tab_hover = { fg_color = "#7aa2f7", bg_color = "#292e42" },
        new_tab_hover = { fg_color = "#7aa2f7", bg_color = "#24283b", intensity = "Bold" },
        new_tab = { fg_color = "#7aa2f7", bg_color = "#24283b" },
      },
    },
  },
}
