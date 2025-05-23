# Ultra-Wide Monitor Features for AeroSpace

This patch adds two features specifically designed for ultra-wide monitors:

1. **Single Window Margins**: Configurable extra margins when only one window is tiled on a workspace
2. **Center-Expand Command**: A toggleable command to expand a window with configurable margins (similar to fullscreen but with gaps)

## Features

### Single Window Margins

When you have a single window on a workspace, it can be too wide on ultra-wide monitors. This feature adds extra configurable margins to center the window at a more reasonable width.

**Configuration:**
```toml
[gaps.single-window-margin]
left = 400   # Extra margin in pixels
right = 400
top = 0
bottom = 0
```

These margins are applied IN ADDITION to the regular outer gaps, but only when:
- There is exactly one window in the workspace's root tiling container
- The window is tiled (not floating)

### Center-Expand Command

A new command that expands the focused window to fill the workspace with configurable margins, similar to fullscreen but respecting gaps.

**Configuration:**
```toml
[gaps.center-expand-margin]
left = 300   # Margin in pixels when center-expanded
right = 300
top = 50
bottom = 50
```

**Usage:**
```bash
# Toggle center-expand
aerospace center-expand

# Explicit on/off
aerospace center-expand on
aerospace center-expand off
```

**Key Bindings Example:**
```toml
[mode.main.binding]
alt-f = 'center-expand'
```

## Per-Monitor Configuration

Both features support per-monitor configuration using dynamic values:

```toml
[gaps.single-window-margin]
left = [{ monitor."LG UltraWide" = 500 }, 200]  # 500px on LG UltraWide, 200px on others
right = [{ monitor."LG UltraWide" = 500 }, 200]

[gaps.center-expand-margin]
left = [{ monitor."LG UltraWide" = 400 }, 100]
right = [{ monitor."LG UltraWide" = 400 }, 100]
```

## Implementation Details

### Files Modified:
- `Sources/AppBundle/config/parseGaps.swift` - Extended Gaps structure
- `Sources/AppBundle/tree/Window.swift` - Added window state tracking
- `Sources/AppBundle/layout/layoutRecursive.swift` - Modified layout logic
- `Sources/Common/cmdArgs/cmdArgsManifest.swift` - Added command registration
- `Sources/AppBundle/command/cmdManifest.swift` - Added command mapping

### New Files:
- `Sources/AppBundle/command/impl/CenterExpandCommand.swift` - Command implementation
- `Sources/Common/cmdArgs/impl/CenterExpandCmdArgs.swift` - Command arguments

## Building

```bash
./build-debug.sh
```

## Testing

After building, create a test configuration:

```toml
# ~/.aerospace-debug.toml
[gaps]
inner.horizontal = 10
inner.vertical = 10
outer.left = 10
outer.right = 10
outer.top = 10
outer.bottom = 10

[gaps.single-window-margin]
left = 400
right = 400

[gaps.center-expand-margin]
left = 300
right = 300
top = 50
bottom = 50

[mode.main.binding]
alt-f = 'center-expand'
```

Then run:
```bash
./run-debug.sh
```

## Maintaining as a Patch

This implementation is designed to minimize merge conflicts:

1. Most changes are additive (new fields, new commands)
2. Core layout logic changes are minimal and isolated
3. No changes to existing command behavior

To maintain this patch:
```bash
# Create patch files
git format-patch main..HEAD -o patches/

# Apply patches after rebasing
git am patches/*.patch
```