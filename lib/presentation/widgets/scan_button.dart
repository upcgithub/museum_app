import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:museum_app/presentation/navigation/routes.dart';
import 'package:museum_app/presentation/providers/museum_provider.dart';
import 'package:provider/provider.dart';

class ScanButton extends StatelessWidget {
  const ScanButton({super.key});

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      backgroundColor: Colors.black,
      elevation: 0,
      onPressed: () async {
        await _handleScan(context);
      },
      child: const Icon(
        Icons.filter_center_focus,
        color: Colors.white,
      ),
    );
  }

  Future<void> _handleScan(BuildContext context) async {
    try {
      final barcodeProdResult = await FlutterBarcodeScanner.scanBarcode(
        '#3D8BEF',
        'Cancelar',
        false,
        ScanMode.QR,
      );

      if (barcodeProdResult == '-1') return;

      // Extraer el tipo y el ID en una sola operación
      final parts = barcodeProdResult.split('/');
      if (parts.length != 2) return;

      final type = parts[0];
      final id = parts[1];

      log('Tipo: $type, ID: $id');

      // Iniciar la obtención de datos inmediatamente
      if (!context.mounted) return;

      final artwork = await context.read<MuseumProvider>().getArtworkById(id);

      if (artwork == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Obra de arte no encontrada')),
        );
        return;
      }

      // Navega directamente con los datos del artwork
      // TODO refactor artwork detail screen to use a model
      Navigator.pushNamed(
        context,
        AppRoutes.artworkDetail,
        arguments: {
          'id': artwork.id,
          'title': artwork.title,
          'imageUrl': artwork.imageUrl,
          'description': artwork.description ?? '',
          'relatedArtworks': const [
            {
              'imageUrl':
                  'https://upload.wikimedia.org/wikipedia/commons/thumb/6/64/Fabritius-vink.jpg/490px-Fabritius-vink.jpg',
              'title': 'Chaffinch',
            },
            {
              'imageUrl':
                  'https://upload.wikimedia.org/wikipedia/commons/thumb/d/db/Vermeer%2C_Johannes_-_Woman_reading_a_letter_-_ca._1662-1663.jpg/1920px-Vermeer%2C_Johannes_-_Woman_reading_a_letter_-_ca._1662-1663.jpg',
              'title': 'The Milkmaid',
            },
          ],
        },
      );
    } catch (e) {
      if (!context.mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Error al escanear el código QR')),
      );
    }
  }
}
