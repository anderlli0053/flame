import 'dart:ui';

import 'package:flame/components.dart';
import 'package:flame/experimental.dart';
import 'package:flame/game.dart' hide Viewport;

class CameraComponentPropertiesExample extends FlameGame {
  static const description = '''
    This example uses FixedSizeViewport which is dynamically sized and 
    positioned based on the size of the game widget.
    
    The underlying world is represented as a simple coordinate plane, with
    green dot being the origin. The viewfinder uses custom anchor in order to
    declare its "center" half-way between the bottom left corner and the true
    center.
  ''';

  CameraComponent? _camera;

  @override
  Color backgroundColor() => const Color(0xff333333);

  @override
  Future<void> onLoad() async {
    final world = World();
    world.add(Background());
    _camera = CameraComponent(
      world: world,
      viewport: FixedSizeViewport(200, 200)..add(ViewportFrame()),
    )
      ..viewfinder.zoom = 5
      ..viewfinder.anchor = const Anchor(0.25, 0.75);
    await add(world);
    await add(_camera!);
    onGameResize(canvasSize);
  }

  @override
  void onGameResize(Vector2 size) {
    super.onGameResize(size);
    _camera?.viewport.size = size * 0.7;
    _camera?.viewport.position = size * 0.6;
  }
}

class ViewportFrame extends Component {
  final paint = Paint()
    ..style = PaintingStyle.stroke
    ..strokeWidth = 3
    ..color = const Color(0xff87c4e2);

  @override
  void render(Canvas canvas) {
    final size = (parent! as Viewport).size;
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTWH(-size.x / 2, -size.y / 2, size.x, size.y),
        const Radius.circular(5),
      ),
      paint,
    );
  }
}

class Background extends Component {
  final bgPaint = Paint()..color = const Color(0xffff0000);
  final originPaint = Paint()..color = const Color(0xff2f8750);
  final axisPaint = Paint()
    ..strokeWidth = 1
    ..style = PaintingStyle.stroke
    ..color = const Color(0xff878787);
  final gridPaint = Paint()
    ..style = PaintingStyle.stroke
    ..strokeWidth = 0
    ..color = const Color(0xff555555);

  @override
  void render(Canvas canvas) {
    canvas.drawColor(const Color(0xff000000), BlendMode.src);
    for (var i = -100.0; i <= 100.0; i += 10) {
      canvas.drawLine(Offset(i, -100), Offset(i, 100), gridPaint);
      canvas.drawLine(Offset(-100, i), Offset(100, i), gridPaint);
    }
    canvas.drawLine(Offset.zero, const Offset(0, 10), axisPaint);
    canvas.drawLine(Offset.zero, const Offset(10, 0), axisPaint);
    canvas.drawCircle(Offset.zero, 1.0, originPaint);
  }
}
