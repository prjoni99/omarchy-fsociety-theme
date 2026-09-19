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

exit $fail
