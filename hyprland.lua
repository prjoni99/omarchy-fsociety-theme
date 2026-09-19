-- fsociety HUD: lock-on brackets, dark phosphor glass, fast hard-stop motion.
-- The red is a signal, not decoration: it marks the focused window only.

local brackets = {
  colors = { "rgba(d8463fff)", "rgba(d8463f00)", "rgba(d8463f00)", "rgba(d8463fff)" },
  angle = 45,
}
local hairline = "rgba(1c252a99)"

hl.config({
  general = {
    gaps_in = 4,
    gaps_out = 10,
    border_size = 2,
    col = {
      active_border = brackets,
      inactive_border = hairline,
    },
  },

  decoration = {
    rounding = 2,
    rounding_power = 2,

    -- Dark glass with a little screen grain, not frosted.
    blur = {
      enabled = true,
      size = 3,
      passes = 2,
      new_optimizations = true,
      brightness = 0.8,
      contrast = 1.0,
      vibrancy = 0.0,
      noise = 0.03,
      popups = true,
      special = true,
    },

    active_opacity = 0.97,
    inactive_opacity = 0.90,
    fullscreen_opacity = 1.0,

    -- The focused window is the lit display.
    dim_inactive = true,
    dim_strength = 0.20,
    dim_special = 0.4,

    -- A tight red emission on focus, like a CRT edge.
    shadow = {
      enabled = true,
      range = 12,
      render_power = 3,
      offset = { 0, 0 },
      color = "rgba(d8463f33)",
      color_inactive = "rgba(00000055)",
    },

    motion_blur = { enabled = false },
  },

  group = {
    col = {
      border_active = brackets,
      border_inactive = hairline,
    },
    groupbar = { rounding = 2, gradient_rounding = 2 },
  },
})

-- Omarchy tags windows `default-opacity` with "0.985 0.96", which multiplies
-- with the values above. Restate it so the glass reads as specified.
o.window({ tag = "default-opacity" }, { opacity = "0.97 0.90" })

-- Blur the shell's surfaces so the bar and overlays sit on the same glass.
hl.layer_rule({ match = { namespace = "omarchy-bar" }, blur = true, ignore_alpha = 0.2 })
hl.layer_rule({
  match = {
    namespace = "^(omarchy-menu|omarchy-notifications|omarchy-osd|omarchy-polkit|omarchy-reminders|omarchy-emojis|omarchy-clipboard|omarchy-image-selector|omarchy-keyboard-panel|omarchy-network-qr)$",
  },
  blur = true,
  ignore_alpha = 0.3,
})

-- Motion: fast in, hard stop, no overshoot anywhere.
hl.curve("hudIn", { type = "bezier", points = { { 0.16, 1.0 }, { 0.3, 1.0 } } })
hl.curve("hudOut", { type = "bezier", points = { { 0.4, 0.0 }, { 1.0, 1.0 } } })
hl.curve("hudSweep", { type = "bezier", points = { { 0.22, 0.0 }, { 0.18, 1.0 } } })

hl.animation({ leaf = "windows", enabled = true, speed = 2.5, bezier = "hudIn", style = "popin 97%" })
hl.animation({ leaf = "windowsIn", enabled = true, speed = 2.5, bezier = "hudIn", style = "popin 97%" })
hl.animation({ leaf = "windowsOut", enabled = true, speed = 1.8, bezier = "hudOut", style = "popin 97%" })
hl.animation({ leaf = "windowsMove", enabled = true, speed = 2.5, bezier = "hudIn" })
hl.animation({ leaf = "fade", enabled = true, speed = 2.0, bezier = "hudIn" })
hl.animation({ leaf = "fadeIn", enabled = true, speed = 2.0, bezier = "hudIn" })
hl.animation({ leaf = "fadeOut", enabled = true, speed = 1.5, bezier = "hudOut" })
hl.animation({ leaf = "layersIn", enabled = true, speed = 2.0, bezier = "hudIn", style = "fade" })
hl.animation({ leaf = "layersOut", enabled = true, speed = 1.5, bezier = "hudOut", style = "fade" })
hl.animation({ leaf = "workspaces", enabled = true, speed = 2.5, bezier = "hudSweep", style = "slidefade 8%" })
hl.animation({ leaf = "specialWorkspace", enabled = true, speed = 2.5, bezier = "hudIn", style = "slidefadevert 8%" })
hl.animation({ leaf = "border", enabled = true, speed = 2.0, bezier = "hudIn" })

-- "Target acquired": the brackets rotate into place once when a window gains
-- focus. Never loops, so nothing moves while you work.
hl.animation({ leaf = "borderangle", enabled = true, speed = 8, bezier = "hudSweep", style = "once" })
