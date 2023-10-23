import 'package:flutter/material.dart';
import 'package:http_downloader/data/downloader/download_repository_impl.dart';
import 'package:http_downloader/data/history_repository/history_repository_impl.dart';
import 'package:http_downloader/domain/download_repository.dart';
import 'package:http_downloader/domain/history_repository.dart';
import 'package:http_downloader/presentation/donwloader_page/downloader_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    final HistoryRepository historyRepo = HistoryRepositoryImpl();
    final DownloadRepository downloadRepo = DownloadRepositoryImpl(historyRepo);

    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: DownloaderPage(
          title: 'Http Downloader',
          downloadRepo: downloadRepo,
          historyRepo: historyRepo),
    );
  }
}
