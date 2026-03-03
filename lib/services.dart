import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:googleapis/drive/v3.dart' as drive;
import 'package:googleapis_auth/auth_io.dart';

class GoogleDriveService {
  Future<drive.DriveApi?> getDriveApi() async {
    try {
      // Load json file
      final secretJson = await rootBundle.loadString(
        "assets/client_secret.json",
      );
      final Map<String, dynamic> jsonMap = json.decode(secretJson);

      final clientIdMap = jsonMap['installed'];
      if (clientIdMap == null) {
        throw Exception("Invalid client_secret.json");
      }

      final clientId = ClientId(
        clientIdMap['client_id'] ?? '',
        clientIdMap['client_secret'] ?? '',
      );

      // Validate values
      if (clientId.identifier.isEmpty || clientId.secret!.isEmpty) {
        throw Exception("Invalid client_secret.json");
      }

      // permission for reading gdrive files
      const scopes = [drive.DriveApi.driveReadonlyScope];

      // show signin url
      final authClient = await clientViaUserConsent(clientId, scopes, (url) {
        print("signin url: $url");
      });

      return drive.DriveApi(authClient);
    } catch (e) {
      print("Error: $e");
      return null;
    }
  }

  Future<List<drive.File>> listDriveFiles() async {
    final driveApi = await getDriveApi();
    final fileList = await driveApi!.files.list();

    return fileList.files ?? [];
  }
}
