import 'package:flutter/material.dart';
import 'package:flutter_boring_avatars/flutter_boring_avatars.dart';

class TestPage extends StatefulWidget {
  const TestPage({super.key});

  @override
  State<TestPage> createState() => _TestPageState();
}

class _TestPageState extends State<TestPage> {
  bool animatedBoringAvatarEnter = false;
  bool boringAvatarEnter = false;
  bool boringAvatarDecorationEnter = false;

  tip(String message) {
    ScaffoldMessenger.of(context).clearSnackBars();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Test Page'),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            const Text('BoringAvatar'),
            const Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                SizedBox(width: 32, child: BoringAvatar(name: 'BoringAvatar')),
                SizedBox(width: 64, child: BoringAvatar(name: 'BoringAvatar')),
                SizedBox(width: 128, child: BoringAvatar(name: 'BoringAvatar')),
              ],
            ),
            const SizedBox(height: 32),
            const Text('DefaultBoringAvatarStyle'),
            const DefaultBoringAvatarStyle(
                type: BoringAvatarType.beam,
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    SizedBox(
                        width: 32, child: BoringAvatar(name: 'BoringAvatar')),
                    SizedBox(
                        width: 64, child: BoringAvatar(name: 'BoringAvatar')),
                    SizedBox(
                        width: 128, child: BoringAvatar(name: 'BoringAvatar')),
                  ],
                )),
            const SizedBox(height: 32),
            const Text('BoringAvatarDecoration'),
            Container(
              decoration: BoringAvatarDecoration(
                avatarData: BoringAvatarData.generate(
                  name: 'BoringAvatar',
                  palette: BoringAvatarPalette.defaultPalette,
                  type: BoringAvatarType.bauhaus,
                ),
              ),
              child: const SizedBox(height: 128, width: 128),
            ),
            const SizedBox(height: 32),
            const Text('BoringAvatarDecoration Shape clip'),
            Container(
              decoration: BoringAvatarDecoration(
                avatarData: BoringAvatarData.generate(
                  name: 'BoringAvatar',
                  palette: BoringAvatarPalette.defaultPalette,
                  type: BoringAvatarType.bauhaus,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                    side: const BorderSide(color: Colors.black, width: 2),
                  ),
                ),
              ),
              clipBehavior: Clip.antiAlias,
              child: SizedBox(
                height: 128,
                width: 128,
                child: Column(
                  children: [
                    Container(height: 50, color: Colors.blue),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 32),
            const Text('BoringAvatarDecoration Shape hitTest'),
            GestureDetector(
              onTap: () {
                tip('BoringAvatarDecoration onTap');
              },
              child: MouseRegion(
                cursor: SystemMouseCursors.click,
                hitTestBehavior: HitTestBehavior.deferToChild,
                onEnter: (event) {
                  setState(() {
                    boringAvatarDecorationEnter = true;
                  });
                },
                onExit: (event) {
                  setState(() {
                    boringAvatarDecorationEnter = false;
                  });
                },
                child: Container(
                  decoration: BoringAvatarDecoration(
                    avatarData: BoringAvatarData.generate(
                      name: 'BoringAvatar',
                      palette: BoringAvatarPalette.defaultPalette,
                      type: BoringAvatarType.bauhaus,
                      shape: OvalBorder(
                        side: BorderSide(
                            color: boringAvatarDecorationEnter
                                ? Colors.deepPurple
                                : Colors.black,
                            width: 5),
                      ),
                    ),
                  ),
                  child: const SizedBox(
                    height: 128,
                    width: 128,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 32),
            const Text('BoringAvatar Shape hitTest'),
            GestureDetector(
              onTap: () {
                tip('BoringAvatar onTap');
              },
              child: MouseRegion(
                cursor: SystemMouseCursors.click,
                hitTestBehavior: HitTestBehavior.deferToChild,
                onEnter: (event) {
                  setState(() {
                    boringAvatarEnter = true;
                  });
                },
                onExit: (event) {
                  setState(() {
                    boringAvatarEnter = false;
                  });
                },
                child: SizedBox(
                  width: 128,
                  child: BoringAvatar(
                      name: 'BoringAvatar',
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(40),
                        side: BorderSide(
                            color: boringAvatarEnter
                                ? Colors.deepPurple
                                : Colors.black,
                            width: 5),
                      )),
                ),
              ),
            ),
            const SizedBox(height: 32),
            const Text('AnimatedBoringAvatar Shape hitTest'),
            GestureDetector(
              onTap: () {
                tip('AnimatedBoringAvatar onTap');
              },
              child: MouseRegion(
                cursor: SystemMouseCursors.click,
                hitTestBehavior: HitTestBehavior.deferToChild,
                onEnter: (event) {
                  print("AnimatedBoringAvatar onEnter");
                  setState(() {
                    animatedBoringAvatarEnter = true;
                  });
                },
                onExit: (event) {
                  print("AnimatedBoringAvatar onExit");
                  setState(() {
                    animatedBoringAvatarEnter = false;
                  });
                },
                child: SizedBox(
                  width: 128,
                  child: AnimatedBoringAvatar(
                      duration: const Duration(milliseconds: 1000),
                      curve: Curves.easeInOutCubicEmphasized,
                      type: BoringAvatarType.beam,
                      name: animatedBoringAvatarEnter
                          ? 'Keith Evans'
                          : 'Donald Lopez',
                      shape: OvalBorder(
                        side: BorderSide(
                            color: animatedBoringAvatarEnter
                                ? Colors.deepPurple
                                : Colors.black,
                            width: 5),
                      )),
                ),
              ),
            ),
            const SizedBox(
              height: 200,
              width: double.infinity,
            ),
          ],
        ),
      ),
    );
  }
}
