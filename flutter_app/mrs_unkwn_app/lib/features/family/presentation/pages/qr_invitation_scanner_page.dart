import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';

import '../bloc/family_bloc.dart';

/// Page to scan a QR code and accept a family invitation.
class QrInvitationScannerPage extends StatefulWidget {
  const QrInvitationScannerPage({super.key});

  @override
  State<QrInvitationScannerPage> createState() => _QrInvitationScannerPageState();
}

class _QrInvitationScannerPageState extends State<QrInvitationScannerPage> {
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');
  QRViewController? controller;

  @override
  void dispose() {
    controller?.dispose();
    super.dispose();
  }

  void _onQRViewCreated(QRViewController ctrl) {
    controller = ctrl;
    ctrl.scannedDataStream.listen((scanData) {
      final code = scanData.code;
      if (code != null) {
        ctrl.pauseCamera();
        context.read<FamilyBloc>().add(AcceptInvitationRequested(code));
        Navigator.of(context).pop(code);
      }
    });
  }

  void _onPermissionSet(BuildContext context, QRViewController ctrl, bool granted) {
    if (!granted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Kamerazugriff verweigert')),
      );
      Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('QR-Code scannen')),
      body: QRView(
        key: qrKey,
        onQRViewCreated: _onQRViewCreated,
        onPermissionSet: (ctrl, p) => _onPermissionSet(context, ctrl, p),
      ),
    );
  }
}
