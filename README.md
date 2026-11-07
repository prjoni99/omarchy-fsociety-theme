# fsociety

An [Omarchy](https://omarchy.org) theme. Cold blue-black grade, desaturated
support colors, one signature red spent only where it means something:
focus, selection, errors, alerts. Never decoration.

![fsociety](preview.png)

## Install

```bash
omarchy theme install https://github.com/prjoni99/omarchy-fsociety-theme.git
```

That gives you the palette, the shell styling and the wallpapers. After that
it's in the theme picker like any other: `omarchy theme set fsociety`, or pick
it from the menu.

## What's in it

| | |
|---|---|
| `colors.toml` | Palette. Omarchy regenerates VS Code and the rest from this. |
| `shell.*.toml` | Eleven files theming the Omarchy shell — bar, launcher, menu, lock screen, notifications, polkit, popups, tooltips, controls, image picker, spacing. |
| `btop.theme` | Neutral greys; red only at the hot end of temperature, low memory, and the selected process. |
| `chromium.theme`, `keyboard.rgb` | Browser frame in the bar's near-black; a muted keyboard glow. |
| `backgrounds/` | Fourteen wallpapers: eleven AI-generated photos and three HUD frames, the frames in 4K and QHD. |
| `unlock.png` | Lock screen graphic. |
| `unlock-nightshift.png` | Optional cinematic lock artwork; not enabled automatically. |
| `icons.theme` | Yaru-red-dark. |

## Palette

| Role | Hex | | Role | Hex |
|---|---|---|---|---|
| accent | `#d8463f` | | red | `#c7423c` |
| background | `#0c0f11` | | orange | `#c97c4a` |
| dark background | `#080a0c` | | yellow | `#c9a15a` |
| darker background | `#050607` | | green | `#5a8f6e` |
| lighter background | `#161a1d` | | cyan | `#4c8c93` |
| foreground | `#c3cbce` | | blue | `#4a6e8c` |
| dark foreground | `#5c686c` | | magenta | `#8c6076` |
| bright foreground | `#e2e9eb` | | brown | `#6e4a3c` |

The design rule, if you want to extend it: the red is a signal, not decoration.
It marks keyboard focus, the active border, selection, and errors — nothing else.
Idle and hover states stay neutral so the red keeps its meaning.

## Frame

The shell wears lock-on brackets on its cards: a red border lit only at two
opposite corners. Notifications and selected rows get a red rail on the left.

## Backgrounds

Wallpapers 1–5 and 9–14 are AI-generated for this theme; 6–8 are generated
HUD frames: near-black, a faint grid, one small HUD element low in a
corner. All are covered by the license below. Swap in your own by dropping files into
`~/.config/omarchy/backgrounds/fsociety/` — Omarchy picks them up alongside
the bundled ones, no need to edit the theme.

### Nightshift

`9-nightshift.webp` adds an empty apartment workstation, rain on the window,
and a dim laptop tucked to the right. The dark left side leaves space for
your windows. This original AI-generated image is 1672 × 941, not 4K.

![Nightshift wallpaper](backgrounds/9-nightshift.webp)

The matching optional artwork is `unlock-nightshift.png`, with a small
`hello, friend.` greeting. It is an artwork alternative, not a screenshot
of the running lock screen. The existing `unlock.png` remains the default.
To try the alternative, back up `unlock.png` in your installed theme folder
and replace that local file with `unlock-nightshift.png`. A theme update may
overwrite that local customization. Live shell layout still needs checking
on Omarchy.

Artwork direction and generation prompts are recorded in [ARTWORK.md](ARTWORK.md).

### More cinematic options

Five additional scenes use the same cold palette and quiet negative space.
Each is 1672 × 941 at native resolution, not 4K.

| Wallpaper | Scene |
|---|---|
| [Last train](backgrounds/10-last-train.webp) | Empty subway carriage under tired fluorescent light. |
| [Cold storage](backgrounds/11-cold-storage.webp) | Server racks and a shadowy concrete aisle. |
| [End of line](backgrounds/12-end-of-line.webp) | Closed seaside arcade behind a security shutter. |
| [Above the noise](backgrounds/13-above-the-noise.webp) | Rooftop water tower beneath a dark city sky. |
| [Open circuit](backgrounds/14-open-circuit.webp) | Dismantled laptop on an electronics repair bench. |

See [the artwork gallery and prompts](ARTWORK.md#additional-cinematic-wallpapers)
for previews of all five.

## Notes

This repository ships assets, supported theme configuration, and documentation
only. Do not add scripts, generators, tests, hooks, installers, or executable
code; the Omarchy theme gallery requires a code-free theme repository.

This is a fan theme inspired by the look of *Mr. Robot*. It is not affiliated
with, endorsed by, or connected to USA Network, NBCUniversal, or the show's
creators. No show assets are redistributed here.

## License

MIT — see [LICENSE](LICENSE).

---

Made by Jon Vargas at [CasaVargas](https://casavargas.app), a small studio making apps
for the Mac, iPhone, Windows and Linux.
