import 'package:desktopapp/services.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(home: Home(), debugShowCheckedModeBanner: false);
  }
}

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  List files = [];
  bool loading = false;
  final gdriveServices = GoogleDriveService();

  void loadFiles() async {
    setState(() => loading = true);

    final fileList = await gdriveServices.listDriveFiles();

    setState(() {
      files = fileList;
      loading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: loading
            ? const CircularProgressIndicator()
            : files.isEmpty
            ? TextButton(onPressed: loadFiles, child: const Text("Sign In"))
            : ListView.builder(
                itemCount: files.length,
                itemBuilder: (context, index) {
                  final file = files[index];
                  return ListTile(
                    title: Text(file.name ?? "No Name"),
                    subtitle: Text(file.mimeType ?? "Unknown"),
                  );
                },
              ),
      ),
    );
  }
}
