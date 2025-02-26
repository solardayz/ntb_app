import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';

class QRScannerScreen extends StatefulWidget {
  const QRScannerScreen({Key? key}) : super(key: key);

  @override
  State<QRScannerScreen> createState() => _QRScannerScreenState();
}

class _QRScannerScreenState extends State<QRScannerScreen> {
  final MobileScannerController _controller = MobileScannerController();
  bool _isScanned = false; // 중복 스캔 방지

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  // mobile_scanner 6.0.6 에서는 onDetect 콜백의 인자로 BarcodeCapture를 받습니다.
  void _onDetect(BarcodeCapture capture) {
    if (!_isScanned && capture.barcodes.isNotEmpty) {
      final Barcode barcode = capture.barcodes.first;
      final String? code = barcode.rawValue;
      if (code != null) {
        _isScanned = true;
        Navigator.pop(context, code);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("QR 스캔"),
        backgroundColor: Colors.black,
      ),
      body: MobileScanner(
        controller: _controller,
        onDetect: _onDetect,
      ),
    );
  }
}
