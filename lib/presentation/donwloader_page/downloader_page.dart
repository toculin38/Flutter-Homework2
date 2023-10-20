library downloader_page_view;

import 'package:flutter/material.dart';
import 'package:http_downloader/domain/downloader_api.dart';
import 'package:marquee/marquee.dart';

part 'components/download_url_text_field.dart';
part 'components/download_case_list_view.dart';
part 'components/download_case_container.dart';

class DownloaderPage extends StatefulWidget {
  final String title;

  //injection fields
  final DownloaderAPI _downloaderAPI;

  const DownloaderPage(
      {super.key, required this.title, required DownloaderAPI downloaderAPI})
      : _downloaderAPI = downloaderAPI;

  @override
  State<DownloaderPage> createState() => _DownloaderPageState();
}

class _DownloaderPageState extends State<DownloaderPage> {
  late final _DownloadCaseListView _downloadCaseListView;
  late final _DownloadUrlTextField _downloadUrlTextField;

  @override
  void initState() {
    _downloadCaseListView =
        _DownloadCaseListView(downloaderAPI: widget._downloaderAPI);

    _downloadUrlTextField =
        _DownloadUrlTextField(downloaderAPI: widget._downloaderAPI);

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(),
      body: _buildBody(),
    );
  }

  AppBar _buildAppBar() {
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
}
