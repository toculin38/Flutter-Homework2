import 'dart:io';
import 'package:flutter/material.dart';
import 'package:http_downloader/data/history_repository/history_item.dart';
import 'package:http_downloader/domain/history_repository.dart';
import 'package:path/path.dart';

class HistoryPage extends StatelessWidget {
  final HistoryRepository _historyRepo;

  const HistoryPage(this._historyRepo, {super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(),
      body: _buildBody(),
    );
  }

  AppBar _buildAppBar() {
    const title = Text('History Page');
    final appBar = AppBar(title: title);
    return appBar;
  }

  Widget _buildBody() {
    List<HistoryItem> historyItems = _historyRepo.getHistoryItems();
    return historyItems.isEmpty
        ? _buildEmptyBody()
        : _buildValidBody(historyItems);
  }

  Widget _buildEmptyBody() {
    return const Center(child: Text('No photos available'));
  }

  Widget _buildValidBody(List<HistoryItem> historyItems) {
    const gridDelegate = SliverGridDelegateWithFixedCrossAxisCount(
      crossAxisCount: 2,
      mainAxisSpacing: 4.0,
      crossAxisSpacing: 4.0,
    );

    List<Widget> children = [];

    for (HistoryItem historyItem in historyItems) {
      children.add(_buildHistoryItemChild(historyItem));
    }

    return GridView(
      gridDelegate: gridDelegate,
      children: children,
    );
  }

  Widget _buildHistoryItemChild(HistoryItem historyItem) {
    File imageFile = File(historyItem.filePath);

    Widget imageWidget;
    if (imageFile.existsSync()) {
      imageWidget = Image.file(imageFile, fit: BoxFit.cover);
    } else {
      imageWidget = Container(
        color: Colors.grey,
        child: const Center(
          child: Icon(Icons.close, size: 50, color: Colors.red),
        ),
      );
    }

    final fileText = Text(basename(historyItem.filePath),
        style: const TextStyle(color: Colors.white, fontSize: 12),
        overflow: TextOverflow.ellipsis);

    final urlText = Text(historyItem.url,
        style: const TextStyle(color: Colors.white, fontSize: 10),
        overflow: TextOverflow.ellipsis);

    return GestureDetector(
      onTap: () {},
      child: Stack(
        children: [
          imageWidget,
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              color: Colors.black.withOpacity(0.5),
              padding:
                  const EdgeInsets.symmetric(horizontal: 4.0, vertical: 2.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  fileText,
                  urlText,
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
