import 'dart:io';
import 'package:flutter/material.dart';
import 'package:qr_code_scanner_plus/qr_code_scanner_plus.dart';
import 'package:save_eat/components/colored_button_widget.dart';
import 'package:url_launcher/url_launcher.dart';

class QrScanPage extends StatefulWidget {
  const QrScanPage({super.key});

  @override
  State<QrScanPage> createState() => _QrScanPageState();
}

class _QrScanPageState extends State<QrScanPage>
    with AutomaticKeepAliveClientMixin {
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');
  Barcode? result;
  QRViewController? controller;
  bool isScanning = false;

  @override
  bool get wantKeepAlive => true;

  @override
  void reassemble() {
    super.reassemble();
    if (Platform.isAndroid) {
      controller?.pauseCamera();
    } else if (Platform.isIOS) {
      controller?.resumeCamera();
    }
  }

  @override
  void dispose() {
    controller?.dispose();
    super.dispose();
  }

  Future<void> _launchUrl(String url) async {
    final Uri uri = Uri.parse(url);
    if (!await launchUrl(uri, mode: LaunchMode.externalApplication)) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Could not launch $url')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);

    final Size screenSize = MediaQuery.of(context).size;
    final scanAreaSize =
        screenSize.width * 0.90; // Increased scanner square size

    return SingleChildScrollView(
      child: Column(
        children: [
          // Adjust vertical spacing to position the QR scanner higher
          const SizedBox(height: 20), // Reduced from 30 to 20

          // QR Scanner Area - Fixed position regardless of scanning state
          Container(
            width: scanAreaSize,
            height: scanAreaSize,
            margin: const EdgeInsets.symmetric(
                horizontal: 20, vertical: 5), // Reduced vertical margin
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              boxShadow: const [
                BoxShadow(
                  color: Color(0x3F000000),
                  blurRadius: 10,
                  offset: Offset(0, 4),
                ),
              ],
            ),
            clipBehavior: Clip.hardEdge,
            child: isScanning
                ? _buildQrView(context, scanAreaSize)
                : _buildPlaceholderView(),
          ),

          // Scan or Cancel button appears below the QR Scanner
          if (!isScanning)
            Padding(
              padding: const EdgeInsets.symmetric(
                  vertical: 15, horizontal: 50), // Reduced vertical padding
              child: ColoredButtonWidget(
                text: "Scan",
                backgroundColor: Colors.green,
                onPressed: () {
                  setState(() {
                    isScanning = true;
                  });
                },
                height: 50,
                width: 185,
                borderRadius: 10,
              ),
            ),

          // Cancel button appears in the same position as the scan button
          if (isScanning && result == null)
            Padding(
              padding: const EdgeInsets.symmetric(
                  vertical: 15, horizontal: 50), // Reduced vertical padding
              child: ColoredButtonWidget(
                text: "Cancel",
                backgroundColor: Colors.red,
                onPressed: () {
                  setState(() {
                    isScanning = false;
                    controller?.pauseCamera();
                  });
                },
                height: 50,
                width: 185,
                borderRadius: 10,
              ),
            ),

          // Result area appears only when a QR code is scanned
          if (result != null)
            Padding(
              padding: const EdgeInsets.symmetric(
                  horizontal: 20, vertical: 15), // Reduced vertical padding
              child: Column(
                children: [
                  // Scanned Code Title above the rectangle
                  const Text(
                    'Scanned Code',
                    style: TextStyle(
                      fontFamily: 'Inconsolata',
                      fontSize: 18,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 8),
                  // Code container
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10),
                      boxShadow: const [
                        BoxShadow(
                          color: Color(0x3F000000),
                          blurRadius: 4,
                          offset: Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Text(
                      '${result!.code}',
                      style: const TextStyle(
                        fontFamily: 'Inconsolata',
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                  const SizedBox(height: 15), // Reduced spacing
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 50),
                    child: ColoredButtonWidget(
                      text: "Process Data",
                      backgroundColor: Colors.green,
                      onPressed: () {
                        // Launch URL if the QR code is a valid URL
                        if (result?.code != null) {
                          _launchUrl(result!.code!);
                        }
                      },
                      height: 50,
                      width: 185,
                      borderRadius: 10,
                    ),
                  ),
                  const SizedBox(height: 12), // Reduced spacing
                  // Scan Again button with ColoredButtonWidget style in grey
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 50),
                    child: ColoredButtonWidget(
                      text: "Scan Again",
                      backgroundColor: Colors.grey.shade600,
                      onPressed: () {
                        setState(() {
                          result = null;
                          // Keep the camera active when resetting
                          isScanning = true;
                          controller?.resumeCamera();
                        });
                      },
                      height: 50,
                      width: 185,
                      borderRadius: 10,
                    ),
                  ),
                  // Added small padding at the bottom to prevent overflow
                  const SizedBox(height: 5),
                ],
              ),
            ),
          // Add bottom padding to ensure last elements are visible when scrolling
          const SizedBox(height: 5),
        ],
      ),
    );
  }

  Widget _buildPlaceholderView() {
    return Container(
      color: Colors.white,
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: const [
            Icon(
              Icons.qr_code_scanner,
              size: 80,
              color: Color(0xFF505050),
            ),
            SizedBox(height: 20),
            Text(
              'QR Code Scanner',
              style: TextStyle(
                fontFamily: 'Inconsolata',
                fontSize: 18,
                fontWeight: FontWeight.w500,
              ),
            ),
            SizedBox(height: 10),
            Text(
              'Press the Scan button to start',
              style: TextStyle(
                fontFamily: 'Inconsolata',
                fontSize: 14,
                color: Color(0xFF505050),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildQrView(BuildContext context, double size) {
    return QRView(
      key: qrKey,
      onQRViewCreated: _onQRViewCreated,
      overlay: QrScannerOverlayShape(
        borderColor: Colors.blue,
        borderRadius: 10,
        borderLength: 30,
        borderWidth: 10,
        cutOutSize: size - 40,
      ),
      onPermissionSet: (ctrl, p) {
        if (!p) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('No camera permission')),
          );
        }
      },
    );
  }

  void _onQRViewCreated(QRViewController controller) {
    setState(() {
      this.controller = controller;
    });
    controller.scannedDataStream.listen((scanData) {
      if (mounted && scanData.code != null && scanData.code!.isNotEmpty) {
        setState(() {
          result = scanData;
          controller.pauseCamera();
        });
      }
    });
  }
}
