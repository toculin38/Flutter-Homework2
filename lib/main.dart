import 'package:flutter/material.dart';
import 'package:http_downloader/data/downloader.dart';
import 'package:http_downloader/domain/downloader_api.dart';
import 'package:http_downloader/presentation/donwloader_page/downloader_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    final DownloaderAPI downloader = Downloader();

    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: DownloaderPage(title: 'Http Downloader', downloaderAPI: downloader),
    );
  }
}
