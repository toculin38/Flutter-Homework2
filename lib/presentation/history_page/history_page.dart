import 'dart:io';
import 'package:flutter/material.dart';
import 'package:http_downloader/data/history_repository/history_item.dart';
import 'package:http_downloader/domain/history_repository.dart';

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
      crossAxisCount: 3,
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

    GestureDetector gestureDetector =
        GestureDetector(onTap: () {}, child: imageWidget);

    return gestureDetector;
  }
}
