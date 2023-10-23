part of downloader;

enum DonwloadStatus { pausing, ongoing, finished }

class DownloadCase {
  VoidCallback? _onDataCallback;
  VoidCallback? _onDoneCallback;
  VoidCallback? _onStatusChangeCallback;
  VoidCallback? _onCaseDisposedCallback;

  final progressStreamController = StreamController<double>.broadcast();
  final String url;
  final String _filePath;
  double progress = 0.0;
  DonwloadStatus status = DonwloadStatus.pausing;

  http.Client? _client;
  StreamSubscription? _streamSubscription;
  IOSink? _sink;

  int _bytesDownloaded = 0;

  DownloadCase(this.url, this._filePath);

  void start() {
    if (status == DonwloadStatus.pausing) {
      _startDownload(_filePath);
      _setStatus(DonwloadStatus.ongoing);
    }
  }

  void pause() {
    if (status == DonwloadStatus.ongoing) {
      _releaseSubscription();
      _releaseSink();
      _releaseClient();
      _setStatus(DonwloadStatus.pausing);
    }
  }

  void cancel() {
    _dispose();
  }

  Future<void> _startDownload(String filePath) async {
    _client = http.Client();

    final Uri uri = Uri.parse(url);
    final request = http.Request('GET', uri);

    if (_bytesDownloaded > 0) {
      request.headers['Range'] = 'bytes=$_bytesDownloaded-';
    }

    final response = await _client!.send(request);
    final statusCode = response.statusCode;

    print(statusCode);

    if (statusCode == 200 || statusCode == 206) {
      final totalBytes = response.contentLength ?? 0;
      final file = File(filePath);
      _sink = file.openWrite(mode: FileMode.append);

      void onData(List<int> chunk) {
        _bytesDownloaded += chunk.length;
        _sink!.add(chunk);
        progress = (_bytesDownloaded / totalBytes);
        _onDataCallback?.call();
      }

      void onDone() async {
        await _sink!.close();
        _releaseClient();
        _setStatus(DonwloadStatus.finished);
        _onDoneCallback?.call();
      }

      _streamSubscription = response.stream.listen(onData, onDone: onDone);
    } else {
      throw Exception(
          'Error downloading file: Status code ${response.statusCode}');
    }
  }

  void _releaseSubscription() {
    _streamSubscription?.cancel();
    _streamSubscription = null;
  }

  void _releaseSink() {
    _sink?.close();
    _sink = null;
  }

  void _releaseClient() {
    _client?.close();
    _client = null;
  }

  void _setStatus(DonwloadStatus status) {
    this.status = status;
    _onStatusChangeCallback?.call();
  }

  void _dispose() {
    _releaseSubscription();
    _releaseSink();
    _releaseClient();
    _onCaseDisposedCallback?.call();
  }

  void _setOnDataCallback(VoidCallback callback) {
    _onDataCallback = callback;
  }

  void _setOnDoneCallback(VoidCallback callback) {
    _onDoneCallback = callback;
  }

  void _setOnStatusChangeCallback(VoidCallback callback) {
    _onStatusChangeCallback = callback;
  }

  void _setOnCaseDisposedCallback(VoidCallback callback) {
    _onCaseDisposedCallback = callback;
  }
}
