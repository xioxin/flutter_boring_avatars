import 'dart:ui';
import '../flutter_boring_avatars.dart';

Future<Image> createBoringAvatarToImage({
  required String name,
  required Size size,
  BoringAvatarType type = BoringAvatarType.marble,
  BoringAvatarPalette palette = BoringAvatarPalette.defaultPalette,
}) {
  PictureRecorder recorder = PictureRecorder();
  Canvas canvas = Canvas(recorder);
  final data = BoringAvatarData.generate(
    name: name,
    type: type,
    palette: palette,
  );
  data.painter.paint(canvas, size);
  return recorder
      .endRecording()
      .toImage(size.width.floor(), size.height.floor());
}
