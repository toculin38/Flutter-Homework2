library downloader;

import 'dart:async';
import 'package:flutter/material.dart';
import 'package:http_downloader/domain/download_repository.dart';
import 'package:http_downloader/domain/history_repository.dart';
import 'package:path/path.dart' as path;
import 'package:http/http.dart' as http;
import 'dart:io';

part 'download_case.dart';

class _Strings {
  static String illegalCharsRegex = r'[\/:*?"<>|]';
  static String directoryPath = '/storage/emulated/0/Download';
}

class DownloadRepositoryImpl implements DownloadRepository {
  final List<DownloadCase> _downloadCases = [];
  final HistoryRepository _historyRepo;

  final _downloadCasesUpdateStreamController =
      StreamController<List<DownloadCase>>.broadcast();

  final _errorMessageStreamController = StreamController<String>.broadcast();

  @override
  Stream<List<DownloadCase>> get onDonwloadCasesUpdateStream =>
      _downloadCasesUpdateStreamController.stream;

  @override
  Stream<String> get errorMessageStream => _errorMessageStreamController.stream;

  DownloadRepositoryImpl(this._historyRepo);

  @override
  void startDownload(String url) async {
    if (await _isValidUrl(url)) {
      final downloadCase = createDownloadCase(url);
      downloadCase.start();
      _addNewDownloadCase(downloadCase);
    }
  }

  DownloadCase createDownloadCase(String url) {
    final uri = Uri.parse(url);
    final filePath = _generateValidFilePath(uri);
    final downloadCase = DownloadCase(url, filePath);
    downloadCase._setOnDataCallback(_notifyDownloadCasesUpdate);
    downloadCase._setOnDoneCallback(() => _onDoneCallback(downloadCase));
    downloadCase._setOnErrorCallback(_onErrorCallback);
    downloadCase._setOnStatusChangeCallback(_notifyDownloadCasesUpdate);
    downloadCase._setOnCaseDisposedCallback(
        () => _onCaseDisposedCallback(downloadCase));
    return downloadCase;
  }

  Future<bool> _isValidUrl(String url) async {
    final client = http.Client();

    try {
      final uri = Uri.parse(url);
      final response = await client.head(uri);

      String? contentType = response.headers['content-type'];

      bool isValidUri = uri.hasAuthority;
      bool isContentTypeLegal = contentType != null &&
          (contentType.contains('image/jpeg') ||
              contentType.contains('image/png'));

      return isValidUri && isContentTypeLegal;
    } catch (e) {
      _errorMessageStreamController.add(e.toString());
    } finally {
      client.close();
    }

    return false;
  }

  String _generateValidFilePath(Uri uri) {
    final RegExp illegalChars = RegExp(_Strings.illegalCharsRegex);
    final String fileName = uri.pathSegments.last.replaceAll(illegalChars, '_');

    String filePath = path.join(_Strings.directoryPath, fileName);

    int duplicateNumber = 1;

    while (File(filePath).existsSync()) {
      duplicateNumber++;
      filePath =
          path.join(_Strings.directoryPath, '($duplicateNumber)$fileName');
    }

    return filePath;
  }

  void _addNewDownloadCase(DownloadCase downloadCase) {
    _downloadCases.add(downloadCase);
    _notifyDownloadCasesUpdate();
  }

  void _deleteDownloadCase(DownloadCase downloadCase) {
    _downloadCases.remove(downloadCase);
    _notifyDownloadCasesUpdate();
  }

  void _notifyDownloadCasesUpdate() {
    _downloadCasesUpdateStreamController.add(_downloadCases);
  }

  void _onDoneCallback(DownloadCase downloadCase) {
    _notifyDownloadCasesUpdate();
    _historyRepo.addNewHistoryItem(downloadCase.url, downloadCase._filePath);
  }

  void _onCaseDisposedCallback(DownloadCase downloadCase) {
    _deleteDownloadCase(downloadCase);
  }

  void _onErrorCallback(String message) {
    _errorMessageStreamController.add(message);
  }
}
