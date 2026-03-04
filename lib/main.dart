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
  bool isSignedIn = false;
  bool loading = false;
  final gdriveServices = GoogleDriveService();

  void loadFiles() async {
    setState(() => loading = true);

    final fileList = await gdriveServices.listDriveFiles();

    setState(() {
      isSignedIn = true;
      files = fileList;
      loading = false;
    });
  }

  @override
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: loading
            ? const CircularProgressIndicator()
            : !isSignedIn
            ? TextButton(
                onPressed: loadFiles,
                child: const Text("Sign In with Google"),
              )
            : files.isEmpty
            ? const Text("No files found in Drive")
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
