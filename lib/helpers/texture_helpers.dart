import 'package:flutter/services.dart';
import 'package:flutter_raycasting/data.dart';
import 'package:image/image.dart' as image;

Future<Map<String, BitmapTexture>> loadTextures() async {
  final textures = <String, BitmapTexture>{};

  textures['unknown'] = await getBitmapTexture('assets/unknown.bmp');
  textures['grass'] = await getBitmapTexture('assets/grass.bmp');
  textures['portal'] = await getBitmapTexture('assets/portal.bmp');
  textures['wall_stone'] = await getBitmapTexture('assets/wall_stone.bmp');
  textures['wall_green'] = await getBitmapTexture('assets/wall_green.bmp');
  textures['wall_brick'] = await getBitmapTexture('assets/wall_brick.bmp');
  textures['background'] = await getBitmapTexture('assets/background.bmp');

  return textures;
}

Future<BitmapTexture> getBitmapTexture(String bitmapAsset) async {
  final data = await rootBundle.load(bitmapAsset);
  final bytes = data.buffer.asUint8List();

  final result = image.decodeBmp(bytes)!;

  final colorArray = <List<Color>>[];

  for (var y = 0; y < result.height; y++) {
    colorArray.add(<Color>[]);
    for (var x = 0; x < result.width; x++) {
      final pixel = result.getPixel(x, y);

      final color = Color.fromARGB(
        pixel.a.toInt(),
        pixel.r.toInt(),
        pixel.g.toInt(),
        pixel.b.toInt(),
      );

      colorArray[y].add(color);
    }
  }

  return BitmapTexture(colorArray);
}
