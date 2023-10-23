library downloader_page_view;

import 'package:flutter/material.dart';
import 'package:http_downloader/data/downloader/download_repository_impl.dart';
import 'package:http_downloader/domain/download_repository.dart';
import 'package:http_downloader/domain/history_repository.dart';
import 'package:http_downloader/presentation/history_page/history_page.dart';
import 'package:marquee/marquee.dart';

part 'components/download_url_text_field.dart';
part 'components/download_case_list_view.dart';
part 'components/download_case_container.dart';

class DownloaderPage extends StatefulWidget {
  final String title;

  //injection fields
  final DownloadRepository _downloadRepo;
  final HistoryRepository _historyRepo;

  const DownloaderPage(
      {super.key,
      required this.title,
      required DownloadRepository downloadRepo,
      required HistoryRepository historyRepo})
      : _downloadRepo = downloadRepo,
        _historyRepo = historyRepo;

  @override
  State<DownloaderPage> createState() => _DownloaderPageState();
}

class _DownloaderPageState extends State<DownloaderPage> {
  late final _DownloadCaseListView _downloadCaseListView;
  late final _DownloadUrlTextField _downloadUrlTextField;

  @override
  void initState() {
    _downloadCaseListView =
        _DownloadCaseListView(downloaderAPI: widget._downloadRepo);

    _downloadUrlTextField =
        _DownloadUrlTextField(downloaderAPI: widget._downloadRepo);

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(context),
      body: _buildBody(),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: _buildFloatingActionButton(),
    );
  }

  AppBar _buildAppBar(BuildContext context) {
    final backgroundColor = Theme.of(context).colorScheme.inversePrimary;
    final title = Text(widget.title);
    return AppBar(backgroundColor: backgroundColor, title: title);
  }

  Widget _buildBody() {
    List<Widget> children = [
      _downloadUrlTextField,
      _downloadCaseListView,
    ];

    final child = Column(
      children: children,
    );

    return Padding(padding: const EdgeInsets.all(20.0), child: child);
  }

  Widget _buildFloatingActionButton() {
    return Container(
        height: 50,
        margin: const EdgeInsets.all(10),
        child: ElevatedButton(
          onPressed: _navigateToHistoryPage,
          child: const Center(
            child: Text('History Page'),
          ),
        ));
  }

  void _navigateToHistoryPage() {
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => HistoryPage(widget._historyRepo)));
  }
}
