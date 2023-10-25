import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:http_downloader/data/downloader/download_repository_impl.dart';
import 'package:http_downloader/data/history_repository/history_item.dart';
import 'package:http_downloader/data/history_repository/history_repository_impl.dart';
import 'package:http_downloader/domain/download_repository.dart';
import 'package:http_downloader/domain/history_repository.dart';
import 'package:http_downloader/presentation/donwloader_page/downloader_page.dart';

void main() async {
  await Hive.initFlutter();
  Hive.registerAdapter(HistoryItemAdapter());
  final HistoryRepository historyRepo = HistoryRepositoryImpl();
  final DownloadRepository downloadRepo = DownloadRepositoryImpl(historyRepo);
  runApp(MyApp(historyRepo, downloadRepo));
  Hive.close();
}

class MyApp extends StatelessWidget {
  const MyApp(this._historyRepo, this._downloadRepo, {super.key});
  final HistoryRepository _historyRepo;
  final DownloadRepository _downloadRepo;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: DownloaderPage(
          title: 'Http Downloader',
          downloadRepo: _downloadRepo,
          historyRepo: _historyRepo),
    );
  }
}
