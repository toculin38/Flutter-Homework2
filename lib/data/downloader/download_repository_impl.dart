library downloader;

import 'dart:async';
import 'package:flutter/material.dart';
import 'package:http_downloader/domain/download_repository.dart';
import 'package:http_downloader/domain/history_repository.dart';
import 'package:path/path.dart' as path;
import 'package:http/http.dart' as http;
import 'dart:io';

import 'package:rxdart/subjects.dart';

part 'download_case.dart';

class _Strings {
  static const String illegalCharsRegex = r'[\/:*?"<>|]';
  static const String directoryPath = '/storage/emulated/0/Download';
}

class DownloadRepositoryImpl implements DownloadRepository {
  final List<DownloadCase> _downloadCases = [];
  final HistoryRepository _historyRepo;
  final _downloadCasesUpdateStreamController =
      StreamController<List<DownloadCase>>.broadcast();
  final _errorMessageStreamController = StreamController<String>.broadcast();

  DownloadRepositoryImpl(this._historyRepo);

  @override
  Stream<List<DownloadCase>> get onDownloadCasesUpdateStream =>
      _downloadCasesUpdateStreamController.stream;

  @override
  Stream<String> get errorMessageStream => _errorMessageStreamController.stream;

  @override
  void startDownload(String url) async {
    if (await _isValidUrl(url)) {
      final downloadCase = _createDownloadCase(url);
      _startCase(downloadCase);
    } else {
      _reportError("Invalid URL: $url");
    }
  }

  DownloadCase _createDownloadCase(String url) {
    final uri = Uri.parse(url);
    final filePath = _generateValidFilePath(uri);
    final downloadCase = DownloadCase(url, filePath);

    // Set callbacks
    downloadCase
      ..setOnDone(() => _handleDownloadCompletion(downloadCase))
      ..setOnError(_reportError)
      ..setOnDisposed(() => _removeDownloadCase(downloadCase));

    return downloadCase;
  }

  Future<bool> _isValidUrl(String url) async {
    try {
      final uri = Uri.parse(url);
      final response = await http.Client().head(uri);

      return _isUriValid(uri) &&
          _isContentTypeValid(response.headers['content-type']);
    } catch (e) {
      _reportError(e.toString());
      return false;
    }
  }

  bool _isUriValid(Uri uri) => uri.hasAuthority;

  bool _isContentTypeValid(String? contentType) {
    const List<String> validContentTypes = [
      'image/jpeg',
      'image/png',
    ];

    return contentType != null && validContentTypes.contains(contentType);
  }

  String _generateValidFilePath(Uri uri) {
    final illegalChars = RegExp(_Strings.illegalCharsRegex);
    final fileName = uri.pathSegments.last.replaceAll(illegalChars, '_');
    return _findUniqueFilePath(fileName);
  }

  String _findUniqueFilePath(String fileName) {
    String filePath = path.join(_Strings.directoryPath, fileName);
    int duplicateNumber = 1;

    while (File(filePath).existsSync()) {
      duplicateNumber++;
      filePath =
          path.join(_Strings.directoryPath, '($duplicateNumber)$fileName');
    }

    return filePath;
  }

  void _startCase(DownloadCase downloadCase) {
    downloadCase.start();
    _downloadCases.add(downloadCase);
    _updateDownloadCases();
  }

  void _handleDownloadCompletion(DownloadCase downloadCase) {
    _historyRepo.addNewHistoryItem(downloadCase.url, downloadCase._filePath);
  }

  void _removeDownloadCase(DownloadCase downloadCase) {
    _downloadCases.remove(downloadCase);
    _updateDownloadCases();
  }

  void _updateDownloadCases() {
    _downloadCasesUpdateStreamController.add(_downloadCases);
  }

  void _reportError(String message) {
    _errorMessageStreamController.add(message);
  }
}
