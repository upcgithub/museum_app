import 'package:flutter/material.dart';

class ScanButton extends StatelessWidget {
  const ScanButton({super.key});

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      backgroundColor: Colors.black,
      elevation: 0,
      onPressed: () async {},
      child: const Icon(
        Icons.filter_center_focus,
        color: Colors.white,
      ),
    );
  }
}
