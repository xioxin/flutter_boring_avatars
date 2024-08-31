<img width="50px" align="right" alt="Github" src="https://raw.githubusercontent.com/xioxin/flutter_boring_avatars/main/screenshots/logo.png" />

flutter_boring_avatars
------------

[![Pub Version (including pre-releases)](https://img.shields.io/pub/v/flutter_boring_avatars?include_prereleases)](https://pub.dev/packages/flutter_boring_avatars)

English | [中文](README_zh.md)

## Features

Boring avatars can generate unique avatars based on the username and color palette.

This project is a Flutter implementation of [Boring Avatars](https://boringavatars.com/).

It differs from the original project in its implementation, using Canvas for rendering and adding transition animations.

Check out the [Web Demo](https://xioxin.github.io/flutter_boring_avatars/) to experience the effect.

## Screenshots

![preview1.png](https://raw.githubusercontent.com/xioxin/flutter_boring_avatars/main/screenshots/preview1.png)


## Installation
Add the dependency in your `pubspec.yaml` file:

```yaml
dependencies:
  flutter_boring_avatars: any # or the latest version on Pub
```

## Usage

Get a simple avatar
```Dart
BoringAvatar(name: "Maria Mitchell", type: BoringAvatarType.marble);
```

Get an animated avatar that has a nice transition animation when the name changes
```Dart
AnimatedBoringAvatar(
  name: "Maria Mitchell",
  type: BoringAvatarType.marble,
  duration: const Duration(milliseconds: 300),
)
```

Get an avatar with a custom color palette
```Dart
final colorPalette = BoringAvatarPalette(Color(0xffA3A948), Color(0xffEDB92E), Color(0xffF85931), Color(0xffCE1836), Color(0xff009989));

BoringAvatar(name: "Maria Mitchell", palette: colorPalette);
```

Set default type and palette, applicable only for BoringAvatar and AnimatedBoringAvatar
```Dart
build(context) {
  return DefaultBoringAvatarStyle(
    type: BoringAvatarType.marble, 
    palette: colorPalette,
    child: Column(
      children: [
        BoringAvatar(name: "Maria Mitchell"),
        BoringAvatar(name: "Alexis Brooks"),
        BoringAvatar(name: "Justin Gray"),
      ]
    ),
  );
}
```

Use `ShapeBorder` to control the avatar shape and add a border
```Dart
BoringAvatar(
  name: "Maria Mitchell",
  type: BoringAvatarType.marble,
  shape: OvalBorder(), // or RoundedRectangleBorder(borderRadius: BorderRadius.circular(16))
);
```

Use the avatar for Decoration, it also supports transition animations when used in AnimatedContainer
```Dart
Container(
  decoration: BoringAvatarDecoration(
    avatarData: BoringAvatarData.generate(name: name),
  ),
);
```

Export the avatar as an image
```Dart
final avatarData = BoringAvatarData.generate(name: name);
final image = await avatarData.toImage(size: const Size.square(256));
final pngByteData = await image.toByteData(format: ImageByteFormat.png);
```

## Thanks
Thanks to the developers of [Boring Avatars](https://boringavatars.com/).

The example uses the [beautiful palette project](https://github.com/Experience-Monks/nice-color-palettes) from [Matt DesLauriers](https://www.mattdesl.com/).

If you like this project, please give me a star.
