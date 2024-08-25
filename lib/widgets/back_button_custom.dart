import 'package:flutter/material.dart';

class BackButtonCustom extends StatelessWidget {
  const BackButtonCustom({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(5.0),
      child: IconButton.filled(
        icon: const Icon(
          Icons.arrow_back,
          color: Colors.white,
        ),
        color: Theme.of(context).colorScheme.primary,
        onPressed: () => Navigator.of(context).pop(),
      ),
    );
  }
}
