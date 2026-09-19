#!/bin/bash
# regen-terminals must: set the cursor to the accent, change nothing else
# compared with Omarchy's own rendering, and be byte-identical on a rerun.
set -uo pipefail

repo=$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)
work=$(mktemp -d)
trap 'rm -rf "$work"' EXIT
fail=0
pass() { echo "ok   $1"; }
flop() { echo "FAIL $1"; fail=1; }

cp "$repo/colors.toml" "$work/"
cp "$repo/regen-terminals" "$work/" 2>/dev/null || { echo "FAIL regen-terminals does not exist"; exit 1; }
"$work/regen-terminals" || { echo "FAIL regen-terminals exited non-zero"; exit 1; }

colors=$(omarchy-theme-color --file "$repo/colors.toml" --all)
value() { awk -F'\t' -v k="$1" '$1 == k { print $2 }' <<<"$colors"; }
accent=$(value accent)
bg=$(value background)

# Omarchy's stock rendering, for comparison.
stock="$work/home/.local/state/omarchy/current/next-theme"
mkdir -p "$stock"
cp "$repo/colors.toml" "$stock/"
HOME="$work/home" omarchy-theme-set-templates

has() { grep -qxF -- "$2" "$work/$1" && pass "$1: $2" || flop "$1: missing '$2'"; }
has ghostty.conf "cursor-color = $accent"
has ghostty.conf "cursor-text = $bg"
has kitty.conf "cursor $accent"
has foot.ini "cursor=${bg#\#} ${accent#\#}"
[[ $(grep -cxF "cursor = \"$accent\"" "$work/alacritty.toml") == 2 ]] \
  && pass "alacritty.toml: both cursors are the accent" \
  || flop "alacritty.toml: expected 2 accent cursor lines"

for f in ghostty.conf alacritty.toml kitty.conf foot.ini; do
  if diff <(grep -v cursor "$stock/$f") <(grep -v cursor "$work/$f") >/dev/null; then
    pass "$f: only cursor lines differ from stock"
  else
    flop "$f: non-cursor lines differ from stock"
  fi
done

mkdir "$work/first"
cp "$work"/{ghostty.conf,alacritty.toml,kitty.conf,foot.ini} "$work/first/"
"$work/regen-terminals"
for f in ghostty.conf alacritty.toml kitty.conf foot.ini; do
  cmp -s "$work/first/$f" "$work/$f" && pass "$f: rerun is identical" || flop "$f: rerun differs"
done

exit $fail
