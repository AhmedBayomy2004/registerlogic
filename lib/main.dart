import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:registerlogic/api_logic.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final ApiService api = ApiService();
  bool scanned = false;

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(title: Text("QR code"), backgroundColor: Colors.blue),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text("QR Test"),
              SizedBox(height: 50),
              SizedBox(
                height: 200,
                width: 200,

                child: ClipRRect(
                  borderRadius: BorderRadius.all(Radius.circular(20)),
                  child: Builder(
                    builder: (context) {
                      return MobileScanner(
                        onDetect: (result) async {
                          if (scanned) return;
                          scanned = true;
                          String? userId = result.barcodes.first.rawValue;

                          String message = await api.register(userId);
                          if (!context.mounted) {
                            return;
                          }
                          showDialog(
                            context: context,
                            builder: (context) {
                              return AlertDialog(
                                content: Text(message),
                                actions: [
                                  TextButton(
                                    onPressed: () {
                                      Navigator.pop(context);
                                    },
                                    child: const Text("OK"),
                                  ),
                                ],
                              );
                            },
                          ).then((onValue) {
                            scanned = false;
                          });
                        },
                      );
                    },
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
