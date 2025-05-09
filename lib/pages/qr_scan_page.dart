import 'dart:io';
import 'package:flutter/material.dart';
import 'package:qr_code_scanner_plus/qr_code_scanner_plus.dart';
import 'package:save_eat/components/colored_button_widget.dart';
import 'package:url_launcher/url_launcher.dart';
import 'dart:convert';
import 'package:mqtt_client/mqtt_client.dart';
import 'package:mqtt_client/mqtt_server_client.dart';
import 'package:save_eat/components/qr_result_widget.dart';

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
  String? restaurant;
  String? tableId;
  String? errorMsg;
  bool isSummoning = false;
  final String mqttBroker =
      '192.168.1.98'; // Replace with your laptop's IP address
  final String mqttTopic = '/tables/scan';
  late MqttServerClient mqttClient;

  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    super.initState();
    mqttClient = MqttServerClient(
        mqttBroker, 'flutter_client_${DateTime.now().millisecondsSinceEpoch}');
    mqttClient.logging(on: false);
    mqttClient.keepAlivePeriod = 20;
    mqttClient.onConnected = () => debugPrint('MQTT Connected');
    mqttClient.onDisconnected = () => debugPrint('MQTT Disconnected');
  }

  @override
  void reassemble() {
    super.reassemble();
    if (Platform.isAndroid) {
      controller?.pauseCamera();
    } else if (Platform.isIOS) {
      controller?.resumeCamera();
    }
  }

  Future<void> _launchUrl(String url) async {
    final Uri uri = Uri.parse(url);
    if (!await launchUrl(uri, mode: LaunchMode.externalApplication)) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Could not launch $url')),
      );
    }
  }

  Future<void> _connectMqtt() async {
    if (mqttClient.connectionStatus?.state == MqttConnectionState.connected)
      return;
    try {
      await mqttClient.connect();
    } catch (e) {
      setState(() {
        errorMsg = 'MQTT connect error: $e';
      });
      // Retry connection after a delay
      Future.delayed(const Duration(seconds: 5), () => _connectMqtt());
    }
  }

  void _parseQr(String qr) {
    // Accept QR codes like: clonedse://nav/restaurant/table_id
    final uri = Uri.tryParse(qr);
    if (uri == null) {
      debugPrint('QR parse error: uri is null. Raw: $qr');
      setState(() {
        errorMsg = 'Invalid QR code';
        restaurant = null;
        tableId = null;
      });
      return;
    }
    if (uri.scheme != 'clonedse') {
      debugPrint(
          'QR parse error: scheme is not clonedse. Found: \'${uri.scheme}\'');
      setState(() {
        errorMsg = 'Invalid QR code';
        restaurant = null;
        tableId = null;
      });
      return;
    }
    if (!uri.path.startsWith('/nav/')) {
      debugPrint(
          'QR parse error: path does not start with /nav/. Found: \'${uri.path}\'');
      setState(() {
        errorMsg = 'Invalid QR code';
        restaurant = null;
        tableId = null;
      });
      return;
    }
    // Remove leading slash and split
    final parts = uri.path.replaceFirst('/', '').split('/');
    // parts should be: ['nav', 'restaurant', 'table_id']
    if (parts.length != 3) {
      debugPrint('QR parse error: path split parts != 3. Found: $parts');
      setState(() {
        errorMsg = 'Invalid QR code';
        restaurant = null;
        tableId = null;
      });
      return;
    }
    setState(() {
      restaurant = parts[1];
      tableId = parts[2];
      errorMsg = null;
    });
  }

  Future<void> _summonRobot() async {
    if (restaurant == null || tableId == null) return;
    setState(() {
      isSummoning = true;
      errorMsg = null;
    });
    final timestamp = DateTime.now().millisecondsSinceEpoch ~/ 1000;
    final payload = jsonEncode({
      'restaurant': restaurant,
      'table_id': tableId,
      'timestamp': timestamp,
    });
    await _connectMqtt();
    try {
      final builder = MqttClientPayloadBuilder();
      builder.addString(payload);
      mqttClient.publishMessage(
          mqttTopic, MqttQos.atLeastOnce, builder.payload!);
      setState(() {
        errorMsg = null;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Robot summoned!')),
      );
    } catch (e) {
      setState(() {
        errorMsg = 'Failed to summon robot: $e';
      });
    } finally {
      setState(() {
        isSummoning = false;
      });
    }
  }

  void _showSummonDialog() {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Confirm Summon'),
        backgroundColor: Colors.white,
        content: Text(
          'Are you sure you want to summon the robot to table ${tableId?.replaceFirst('table_', '')} ?',
          style: TextStyle(
            fontFamily: 'Inconsolata',
            fontSize: 16,
            fontWeight: FontWeight.w400,
          ),
        ),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(ctx),
              child: const Text(
                'Cancel',
                style: TextStyle(
                  fontFamily: 'Inconsolata',
                  fontWeight: FontWeight.w500,
                  fontSize: 18,
                  color: Color(0x6F000000),
                ),
              )),
          TextButton(
            onPressed: () {
              Navigator.pop(ctx);
              _summonRobot();
            },
            child: const Text(
              'Confirm',
              style: TextStyle(
                fontFamily: 'Inconsolata',
                fontWeight: FontWeight.w500,
                fontSize: 18,
                color: Colors.green,
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);

    final Size screenSize = MediaQuery.of(context).size;
    final scanAreaSize = screenSize.width * 0.80;

    return SingleChildScrollView(
      child: Column(
        children: [
          const SizedBox(height: 20),

          // QR Scanner Area - Fixed position regardless of scanning state
          Container(
            width: scanAreaSize,
            height: scanAreaSize,
            margin: const EdgeInsets.symmetric(horizontal: 30, vertical: 10),
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
              padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 50),
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
              padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 50),
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
          if (result != null &&
              errorMsg == null &&
              restaurant != null &&
              tableId != null)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
              child: QrResultWidget(
                restaurant: restaurant!,
                tableId: tableId!,
                onSummon: _showSummonDialog,
                onScanAgain: () {
                  setState(() {
                    result = null;
                    restaurant = null;
                    tableId = null;
                    errorMsg = null;
                    isScanning = true;
                  });
                  controller?.resumeCamera();
                },
              ),
            ),
          if (errorMsg != null)
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 20),
              child: Column(
                children: [
                  Text(
                    errorMsg!,
                    style: const TextStyle(color: Colors.red, fontSize: 16),
                  ),
                  const SizedBox(height: 12),
                  ColoredButtonWidget(
                    text: "Scan Again",
                    backgroundColor: Colors.red,
                    onPressed: () {
                      setState(() {
                        result = null;
                        restaurant = null;
                        tableId = null;
                        errorMsg = null;
                        isScanning = true;
                      });
                      controller?.resumeCamera();
                    },
                    height: 50,
                    width: 185,
                    borderRadius: 10,
                  ),
                ],
              ),
            ),
          const SizedBox(height: 15),
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
        _parseQr(scanData.code!);
      }
    });
  }
}
