## 2.1.0

*Special thanks to [blopker](https://github.com/blopker) for the performance improvements in this release!*

### Performance

- **Marble painter: cached static paths and single-pass transforms** — The two SVG-like `Path` objects in the marble variant had constant geometry but were rebuilt from scratch on every paint call. They are now top-level constants, created once. Additionally, the per-element transform and resize transform (previously applied as two separate `Path.transform()` calls, producing 4 `Path` allocations per frame) are now combined into a single `Matrix4`, halving path allocations. Benchmarked at ~2x faster paint calls.

- **Widget data caching** — `BoringAvatar` and `AnimatedBoringAvatar` were `StatelessWidget`s that called `BoringAvatarData.generate()` on every `build()`, re-running the hash function and property calculations even when inputs hadn't changed. Both are now `StatefulWidget`s that cache the generated `BoringAvatarData` and only regenerate when the resolved `name`, `type`, `palette`, or `shape` actually change. This eliminates redundant work during parent rebuilds (e.g. scrolling lists, unrelated `setState` calls).

- **Animated paint hint** — The `CustomPaint` inside `AnimatedBoringCanvas` now sets `willChange: true`, telling the raster cache not to waste effort caching frames that are immediately invalidated during animation.

### Fixes

- Resolved all deprecated API warnings: `Matrix4.translate`/`scale` migrated to `translateByDouble`/`scaleByDouble`, `Color.withOpacity` to `withValues`, `Color.red`/`green`/`blue` to the new component accessors, and `Color.value` to `toARGB32`.


## 2.0.1
- Modify the image link in README to display correctly on pub.dev

## 2.0.0
- Completely refactored the code with a brand new API
- Avatars of different types now also support transition animations
- Supports using avatars in a Decoration manner
- Supports defining shapes and borders
- Supports exporting avatars as images
- Maintains the same generation algorithm as the original project
- Removed the dependency on `svg_path_parser`, now relying only on the Flutter SDK
- A beautiful [Web Demo](https://xioxin.github.io/flutter_boring_avatars/) is available to experience the effect

## 1.1.0
Updated hash algorithm to match the changes made in version 1.6.0 of the original JavaScript project, ensuring consistent avatar generation. (#1)
Special thanks to [fieldOfView](https://github.com/fieldOfView) for discovering and fixing this issue!

## 1.0.2
Fix AvatarMarble blur effect fidelity

## 1.0.1
Fix the wrong link address in the readme file.

## 1.0.0
Initial release