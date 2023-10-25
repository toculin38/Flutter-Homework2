import 'dart:io';

import 'package:flutter/material.dart';
import 'package:http_downloader/data/history_repository/history_item.dart';
import 'package:path/path.dart';

class GalleryPage extends StatefulWidget {
  const GalleryPage(this._historyItems, this._startPage, {super.key});

  final int _startPage;
  final List<HistoryItem> _historyItems;

  @override
  State<StatefulWidget> createState() => _GalleryPageState();
}

class _GalleryPageState extends State<GalleryPage> {
  List<HistoryItem> get _historyItems => widget._historyItems;
  late PageController _pageController;
  int _activePage = 0;

  @override
  void initState() {
    _activePage = widget._startPage;
    _pageController = PageController(initialPage: _activePage);
    super.initState();
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return _buildScaffold();
  }

  Widget _buildScaffold() {
    return Scaffold(appBar: _buildAppBar(), body: _buildBody());
  }

  AppBar _buildAppBar() {
    const title = Text('Gallery Page');
    return AppBar(title: title);
  }

  Widget _buildBody() {
    return Stack(children: [_buildPageView(), _buildImageProperties()]);
  }

  Widget _buildPageView() {
    itemBuilder(BuildContext context, int index) {
      HistoryItem historyItem = _historyItems[index % _historyItems.length];
      File imageFile = File(historyItem.filePath);

      Widget toReturn;

      if (imageFile.existsSync()) {
        toReturn = Image.file(imageFile, fit: BoxFit.contain);
      } else {
        toReturn = const Center(child: Text('File not found!'));
      }

      return toReturn;
    }

    final pageView = PageView.builder(
      controller: _pageController,
      onPageChanged: (page) {
        setState(() => _activePage = page);
      },
      itemCount: _historyItems.length,
      itemBuilder: itemBuilder,
    );

    return pageView;
  }

  Widget _buildImageProperties() {
    HistoryItem historyItem = _historyItems[_activePage];

    final fileText = Text(basename(historyItem.filePath),
        style: const TextStyle(color: Colors.white, fontSize: 12),
        overflow: TextOverflow.ellipsis);

    final urlText = Text(historyItem.url,
        style: const TextStyle(color: Colors.white, fontSize: 10),
        overflow: TextOverflow.ellipsis);

    return Positioned(
      bottom: 0,
      left: 0,
      right: 0,
      child: Container(
        color: Colors.black.withOpacity(0.5),
        padding: const EdgeInsets.symmetric(horizontal: 4.0, vertical: 2.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            fileText,
            urlText,
          ],
        ),
      ),
    );
  }
}
