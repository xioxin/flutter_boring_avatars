<img width="50px" align="right" alt="Github" src="https://raw.githubusercontent.com/xioxin/flutter_boring_avatars/main/screenshots/logo.png" />

flutter_boring_avatars
------------

[![Pub Version (including pre-releases)](https://img.shields.io/pub/v/flutter_boring_avatars?include_prereleases)](https://pub.dev/packages/flutter_boring_avatars)


[English](README.md) | 中文

## 功能

Boring avatars 可以根据用户名和调色板生成独特的头像。

这个项目是 [Boring Avatars](https://boringavatars.com/) 的 Flutter 实现。

它与原始项目在实现方式上有一些不同，使用了 Canvas 实现并添加了过渡动画。

查看 [Web 示例](https://xioxin.github.io/flutter_boring_avatars/) 以体验效果。

## 截图

![preview1.png](https://raw.githubusercontent.com/xioxin/flutter_boring_avatars/main/screenshots/preview1.png)

## 安装
在 `pubspec.yaml` 文件中添加依赖：

```yaml
dependencies:
  flutter_boring_avatars: any # or the latest version on Pub
```

## 使用

获取一个简单的头像
```Dart
BoringAvatar(name:"Maria Mitchell", type: BoringAvatarType.marble);
```

获取一个带有动画的头像，当名字发生变化时，头像会有一个漂亮的过度动画
```Dart
AnimatedBoringAvatar(
  name: "Maria Mitchell",
  type: BoringAvatarType.marble,
  duration: const Duration(milliseconds: 300),
)
```

获取一个带有自定义调色板的头像
```Dart
final colorPaletta = BoringAvatarPalette(Color(0xffA3A948), Color(0xffEDB92E), Color(0xffF85931), Color(0xffCE1836), Color(0xff009989));

BoringAvatar(name:"Maria Mitchell", palette: colorPaletta);
```

设置默认类型和调色板，只适用于 BoringAvatar 和 AnimatedBoringAvatar
```Dart
build(context) {
  return DefaultBoringAvatarStyle(
    type: BoringAvatarType.marble, 
    paletta: colorPaletta,
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

使用 `ShapeBorder` 控制头像形状和添加边框
```Dart
BoringAvatar(
  name:"Maria Mitchell",
  type: BoringAvatarType.marble,
  shape: OvalBorder(), // or RoundedRectangleBorder(borderRadius: BorderRadius.circular(16))
);
```

将头像用于Decoration, 同样的在AnimatedContainer中使用也支持过渡动画
```Dart
Container(
  decoration: BoringAvatarDecoration(
    avatarData: BoringAvatarData.generate(name: name),
  ),
);
```

将头像导出为图片
```Dart
final avatarData = BoringAvatarData.generate(name: name);
final image = await avatarData.toImage(size: const Size.square(256));
final pngByteData = await image.toByteData(format: ImageByteFormat.png);
```

## 感谢
感谢 [Boring Avatars](https://boringavatars.com/) 的开发者们。

在示例中使用了来自 [Matt DesLauriers](https://www.mattdesl.com/) 的[精美调色板项目](https://github.com/Experience-Monks/nice-color-palettes)。

如果你喜欢这个项目，请给我一个 Star。