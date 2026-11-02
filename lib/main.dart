import 'dart:io';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';

late List<CameraDescription> cameras;

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  cameras = await availableCameras();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: CameraPage(),
    );
  }
}

class CameraPage extends StatefulWidget {
  const CameraPage({Key? key}) : super(key: key);

  @override
  State<CameraPage> createState() => _CameraPageState();
}

class _CameraPageState extends State<CameraPage> {
  CameraController? controller;
  XFile? foto;
  bool bukaKamera = false;

  final Color pinkMuda = const Color(0xFFFFE4EC);
  final Color pinkSoft = const Color(0xFFF8BBD0);
  final Color pinkTua = const Color(0xFFAD1457);

  @override
  void initState() {
    super.initState();
    controller = CameraController(
      cameras[0],
      ResolutionPreset.max,
    );
    controller!.initialize().then((_) {
      if (!mounted) return;
      setState(() {});
    });
  }

  @override
  void dispose() {
    controller?.dispose();
    super.dispose();
  }

  Future<void> ambilFoto() async {
    final XFile hasil = await controller!.takePicture();
    setState(() {
      foto = hasil;
      bukaKamera = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (controller == null || !controller!.value.isInitialized) {
      return Scaffold(
        backgroundColor: pinkMuda,
        body: Center(
          child: CircularProgressIndicator(color: pinkSoft),
        ),
      );
    }

    return Scaffold(
      backgroundColor: pinkMuda,
      appBar: AppBar(
        title: const Text('nafisa cam'),
        backgroundColor: pinkSoft,
        foregroundColor: pinkTua,
      ),
      body: Center(
        child: bukaKamera
            ? Column(
                children: [
                  Expanded(
                    child: Transform.flip(
                      flipX: true,
                      child: CameraPreview(controller!),
                    ),
                  ),
                  const SizedBox(height: 10),
                  ElevatedButton.icon(
                    onPressed: ambilFoto,
                    icon: const Icon(Icons.camera),
                    label: const Text('Ambil Foto'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: pinkSoft,
                      foregroundColor: pinkTua,
                    ),
                  ),
                  const SizedBox(height: 20),
                ],
              )
            : Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  foto == null
                      ? Text(
                          'Belum ada foto',
                          style: TextStyle(color: pinkTua),
                        )
                      : Transform.flip(
                          flipX: true,
                          child: Image.file(File(foto!.path), height: 400),
                        ),
                  const SizedBox(height: 20),
                  ElevatedButton.icon(
                    onPressed: () {
                      setState(() {
                        bukaKamera = true;
                      });
                    },
                    icon: const Icon(Icons.camera_alt),
                    label: const Text('Buka Kamera'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: pinkSoft,
                      foregroundColor: pinkTua,
                    ),
                  ),
                ],
              ),
      ),
    );
  }
}