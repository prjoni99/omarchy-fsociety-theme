# Cinematic artwork refresh

## Scope

Add an original night-workstation wallpaper and matching lock artwork.
Keep the cold blue-black palette, quiet negative space, and readable shell.
The repository contains assets, supported theme configuration, and documentation
only: no scripts, generators, executable code, or terminal companions.

## Art direction

An empty apartment at night, rain on the window, a small aging laptop pushed
to the far right. The room carries the mood; no fake hacking readouts,
neon wash, show stills, or actors. The lock graphic uses the same atmosphere
with a small `hello, friend.` greeting. Preserve existing assets and ship the
new lock graphic as an optional sibling until reviewed in a running shell.

## Delivery (complete)

- [x] Generate and inspect wallpaper and matching lock artwork.
- [x] Save assets in the repository and document their use and prompts.
- [x] Check image integrity, documentation, and the no-code constraint.

Both delivered images decode and were visually inspected. Existing TOML files
parse successfully; `git diff --check` passes. Additions are only two raster
assets and two Markdown documents. No build target exists for this asset-only
change. Wallpaper output is 1672 × 941; optional lock output is 1377 × 1142.

## Verification limits

This macOS workspace cannot demonstrate the running Omarchy shell. Image
inspection and file checks verify the artwork, not live shell integration.

## Wallpaper collection (complete)

Five additional original cinematic scenes: empty subway, server aisle,
closed arcade, rooftop, and electronics repair bench. Keep the cold palette,
restrained highlights, negative space, and no text or fake UI. Generate each
as a separate landscape wallpaper and preserve native resolution.

- [x] Generate and visually inspect five distinct wallpapers.
- [x] Save compressed WebP assets and document prompts and dimensions.
- [x] Verify decoding, documentation links, and asset-only additions.

All five generated images were visually inspected. Delivered WebP files decode
successfully with dwebp; local documentation links resolve and diff whitespace
checks pass. Native resolution is 1672 × 941 each; combined size is 398,812
bytes. No scripts or test files were added. Live Omarchy verification remains
outside this macOS artwork workflow.
