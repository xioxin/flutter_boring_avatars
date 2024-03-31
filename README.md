# flutter_boring_avatars

## Features
Flutter implementation of [boring avatars](https://github.com/boringdesigners/boring-avatars) that generates custom, round avatars from any username and color palette.

Key differences from the original project include the use of Canvas and the addition of transition animations.

Check out the [Web Example](https://xioxin.github.io/flutter_boring_avatars/) for a demonstration.

## Getting started

```Dart
final colors = [Color(0xffA3A948), Color(0xffEDB92E), Color(0xffF85931), Color(0xffCE1836), Color(0xff009989)];

BoringAvatars(name: "Maria Mitchell", colors: colors, type: BoringAvatarsType.marble);

// or animation
AnimatedBoringAvatars(
  duration: const Duration(milliseconds: 300),
  name: "Maria Mitchell",
  colors: colors,
  type: BoringAvatarsType.marble
)
```
