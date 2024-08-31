## 1.0.0
Initial release

## 1.0.1
Fix the wrong link address in the readme file.

## 1.0.2
Fix AvatarMarble blur effect fidelity

## 1.1.0
Updated hash algorithm to match the changes made in version 1.6.0 of the original JavaScript project, ensuring consistent avatar generation. (#1)
Special thanks to [fieldOfView](https://github.com/fieldOfView) for discovering and fixing this issue!

## 2.0.0
- Completely refactored the code with a brand new API
- Avatars of different types now also support transition animations
- Supports using avatars in a Decoration manner
- Supports defining shapes and borders
- Supports exporting avatars as images
- Maintains the same generation algorithm as the original project
- Removed the dependency on `svg_path_parser`, now relying only on the Flutter SDK
- A beautiful Web Demo