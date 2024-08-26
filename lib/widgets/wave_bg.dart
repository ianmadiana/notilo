import 'package:flutter/material.dart';
import 'package:flutter_custom_clippers/flutter_custom_clippers.dart';

class WaveBackground extends StatelessWidget {
  const WaveBackground({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.bottomCenter,
      child: ClipPath(
        clipper: WaveClipperTwo(reverse: true),
        child: Container(
          height: 150,
          color: Theme.of(context).primaryColor,
        ),
      ),
    );
  }
}
