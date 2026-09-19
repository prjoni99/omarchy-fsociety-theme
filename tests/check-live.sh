#!/bin/bash
# Checks the running session against the fsociety HUD spec.
# Run after `omarchy theme set fsociety`.
set -u

state="$HOME/.local/state/omarchy/current/theme"
fail=0

pass() { echo "ok   $1"; }
flop() { echo "FAIL $1"; fail=1; }

# opt KEY REGEX: `hyprctl getoption KEY` output must match REGEX.
opt() {
  local out
  out=$(hyprctl getoption "$1")
  if grep -qE -- "$2" <<<"$out"; then pass "$1"; else flop "$1: wanted /$2/, got: $(head -1 <<<"$out")"; fi
}

# anim LEAF FIELD VALUE: a field of an animation leaf in `hyprctl animations`.
anim() {
  local got
  got=$(hyprctl animations | awk -v leaf="$1" -v field="$2:" '
    $1 == "name:" { cur = $2; next }
    cur == leaf && $1 == field { sub(/^[[:space:]]*[^:]+:[[:space:]]*/, ""); print; exit }')
  if [[ $got == "$3" ]]; then pass "anim $1 $2"; else flop "anim $1 $2: wanted '$3', got '$got'"; fi
}

# shell SECTION KEY VALUE: a key in the generated shell.toml, value as written.
shell() {
  local got
  got=$(awk -v sec="[$1]" -v key="$2" '
    $0 == sec { on = 1; next }
    /^\[/ { on = 0 }
    on && $1 == key { sub(/^[^=]*=[[:space:]]*/, ""); print; exit }' "$state/shell.toml")
  if [[ $got == "$3" ]]; then pass "shell $1.$2"; else flop "shell $1.$2: wanted '$3', got '$got'"; fi
}

# file_has PATH LINE: PATH contains LINE exactly.
file_has() {
  if grep -qxF -- "$2" "$1"; then pass "$(basename "$1"): $2"; else flop "$(basename "$1"): missing '$2'"; fi
}

[[ $(cat "$state/../theme.name") == fsociety ]] || { echo "fsociety is not the active theme"; exit 2; }
[[ -z $(hyprctl configerrors | tr -d '[:space:]') ]] && pass "no config errors" || flop "config errors: $(hyprctl configerrors)"

# --- Windows (Task 2) ---
opt general:gaps_in '4 4 4 4'
opt general:gaps_out '10 10 10 10'
opt general:border_size 'int: 2$'
opt decoration:rounding 'int: 2$'
opt general:col.active_border 'ffd8463f (00)?d8463f (00)?d8463f ffd8463f 45deg'
opt general:col.inactive_border '991c252a'
opt decoration:blur:size 'int: 3$'
opt decoration:blur:passes 'int: 2$'
opt decoration:blur:vibrancy 'float: 0\.0+$'
opt decoration:active_opacity 'float: 0\.970*$'
opt decoration:inactive_opacity 'float: 0\.90*$'
opt decoration:dim_strength 'float: 0\.20*$'
opt decoration:shadow:range 'int: 12$'
opt decoration:shadow:color '33d8463f'
opt decoration:motion_blur:enabled '(int: 0|bool: false)$'
anim windowsIn bezier hudIn
anim windowsIn style 'popin 97%'
anim windowsOut bezier hudOut
anim workspaces style 'slidefade 8%'
anim borderangle style once
anim borderangle bezier hudSweep

# --- Shell (Task 3) ---
shell hyprland active-border '"rgba(d8463fff) rgba(d8463f00) rgba(d8463f00) rgba(d8463fff) 45deg"'
shell bar background '"#050607"'
shell bar background-alpha 0.80
shell bar size-horizontal 26
shell bar size-vertical 28
shell notifications border-width '"1 1 1 3"'
shell popups border-width 1
shell tooltip border-width 1
shell controls selected-border-width '"0 0 0 2"'
shell controls selected-fill-alpha 0.10
shell menu scrim-alpha 0.70
shell launcher scrim-alpha 0.70
shell polkit scrim-alpha 0.70
shell image-picker scrim-alpha 0.70
shell spacing scale 0.95

# --- Terminal (Task 4) ---
file_has "$state/ghostty.conf" "cursor-color = #d8463f"
file_has "$state/ghostty.conf" "cursor-text = #0c0f11"

# --- Lock, btop, art ---
shell lock background '"#050607"'
shell lock background-alpha 0.88
shell lock border-active '"rgba(d8463fff) rgba(8c2f2bff) 45deg"'
shell lock border-error '"#d8463f"'
file_has "$state/btop.theme" 'theme[temp_end]="#d8463f"'
file_has "$state/btop.theme" 'theme[cpu_end]="#e2e9eb"'
file_has "$state/chromium.theme" "5,6,7"
file_has "$state/keyboard.rgb" "#3a4448"
for bg in 6-brackets 7-readout 8-hatch; do
  for tag in 4k qhd; do
    [[ -s $state/backgrounds/$bg-$tag.jpg ]] && pass "background $bg-$tag" || flop "background $bg-$tag missing"
  done
done
dims=$(identify -format '%wx%h' "$state/unlock.png" 2>/dev/null)
[[ $dims == 640x530 ]] && pass "unlock.png 640x530" || flop "unlock.png: wanted 640x530, got '$dims'"

exit $fail
