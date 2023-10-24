part of downloader;

enum DownloadStatus { pausing, ongoing, finished }

class DownloadCase {
  VoidCallback? _onDone;
  VoidCallback? _onStatusChange;
  VoidCallback? _onDisposed;
  void Function(String data)? _onError;

  final _progressSubject = BehaviorSubject<double>.seeded(0.0);
  Stream<double> get progressStream => _progressSubject.stream;

  final String url;
  final String _filePath;
  DownloadStatus status = DownloadStatus.pausing;

  http.Client? _client;
  StreamSubscription? _streamSubscription;
  IOSink? _sink;
  int _bytesDownloaded = 0;

  DownloadCase(this.url, this._filePath);

  void start() {
    if (status == DownloadStatus.pausing) {
      _download();
      _updateStatus(DownloadStatus.ongoing);
    }
  }

  void pause() {
    if (status == DownloadStatus.ongoing) {
      _releaseDownloadResources();
      _updateStatus(DownloadStatus.pausing);
    }
  }

  void cancel() => _dispose();

  Future<void> _download() async {
    try {
      final response = await _fetchResponse();
      _processResponse(response);
    } catch (e) {
      _reportError(e);
    }
  }

  Future<http.StreamedResponse> _fetchResponse() async {
    _client = http.Client();
    final request = _createRequest();
    return await _client!.send(request);
  }

  http.Request _createRequest() {
    final Uri uri = Uri.parse(url);
    final request = http.Request('GET', uri);

    if (_bytesDownloaded > 0) {
      request.headers['Range'] = 'bytes=$_bytesDownloaded-';
    }

    return request;
  }

  void _processResponse(http.StreamedResponse response) {
    if (_isValidResponse(response)) {
      _streamToFile(response);
    } else {
      throw Exception('Error downloading: Status ${response.statusCode}');
    }
  }

  bool _isValidResponse(http.StreamedResponse response) {
    return response.statusCode == 200 || response.statusCode == 206;
  }

  void _streamToFile(http.StreamedResponse response) {
    final totalBytes = response.contentLength ?? 0;
    _sink = File(_filePath).openWrite(mode: FileMode.append);

    _streamSubscription = response.stream.listen(
      (chunk) => _onDataReceived(chunk, totalBytes),
      onDone: _finalizeDownload,
      onError: _reportError,
    );
  }

  void _onDataReceived(List<int> chunk, int totalBytes) {
    _bytesDownloaded += chunk.length;
    _sink!.add(chunk);
    _progressSubject.value = (_bytesDownloaded / totalBytes);
  }

  Future<void> _finalizeDownload() async {
    await _closeSink();
    _releaseClient();
    _updateStatus(DownloadStatus.finished);
    _onDone?.call();
  }

  Future<void> _closeSink() async {
    await _sink!.close();
  }

  void _releaseDownloadResources() {
    _streamSubscription?.cancel();
    _streamSubscription = null;
    _closeSink();
    _releaseClient();
  }

  void _releaseClient() {
    _client?.close();
    _client = null;
  }

  void _updateStatus(DownloadStatus newStatus) {
    status = newStatus;
    _onStatusChange?.call();
  }

  void _reportError(Object error) {
    _onError?.call(error.toString());
    _dispose();
  }

  void _dispose() {
    _releaseDownloadResources();
    _progressSubject.close();
    _onDisposed?.call();
  }

  // Setters for callbacks
  void setOnDone(VoidCallback callback) => _onDone = callback;
  void setOnStatusChange(VoidCallback callback) => _onStatusChange = callback;
  void setOnDisposed(VoidCallback callback) => _onDisposed = callback;
  void setOnError(void Function(String) callback) => _onError = callback;
}
