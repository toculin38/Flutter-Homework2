import 'package:http_downloader/data/downloader/download_repository_impl.dart';

abstract class DownloadRepository {
  Stream<List<DownloadCase>> get onDownloadCasesUpdateStream;
  Stream<String> get errorMessageStream;
  void startDownload(String url);
}
