import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';

class ScanButton extends StatelessWidget {
  const ScanButton({super.key});

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      backgroundColor: Colors.black,
      elevation: 0,
      onPressed: () async {
        String barcodeProdResult = await FlutterBarcodeScanner.scanBarcode(
          '#3D8BEF',
          'Cancelar',
          false,
          ScanMode.QR,
        );

        log('barcodeProdResult: $barcodeProdResult');
      },
      child: const Icon(
        Icons.filter_center_focus,
        color: Colors.white,
      ),
    );
  }
}
