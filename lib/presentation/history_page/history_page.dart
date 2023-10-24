import 'dart:io';
import 'package:flutter/material.dart';
import 'package:http_downloader/data/history_repository/history_item.dart';
import 'package:http_downloader/domain/history_repository.dart';
import 'package:http_downloader/presentation/gallery_page/gallery_page.dart';
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

    return Builder(
      builder: (innerContext) {
        return historyItems.isEmpty
            ? _buildEmptyBody()
            : _buildValidBody(historyItems, innerContext);
      },
    );
  }

  Widget _buildEmptyBody() {
    return const Center(child: Text('No photos available'));
  }

  Widget _buildValidBody(List<HistoryItem> historyItems, BuildContext context) {
    const gridDelegate = SliverGridDelegateWithFixedCrossAxisCount(
      crossAxisCount: 2,
      mainAxisSpacing: 4.0,
      crossAxisSpacing: 4.0,
    );

    List<Widget> children = [];

    for (HistoryItem historyItem in historyItems) {
      children.add(_buildHistoryItemChild(historyItem, context));
    }

    return GridView(
      gridDelegate: gridDelegate,
      children: children,
    );
  }

  Widget _buildHistoryItemChild(HistoryItem historyItem, BuildContext context) {
    File imageFile = File(historyItem.filePath);

    Widget imageWidget;
    if (imageFile.existsSync()) {
      imageWidget = AspectRatio(
        aspectRatio: 1.0, // for square
        child: Image.file(imageFile, fit: BoxFit.cover),
      );
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

    final stack = Stack(
      children: [
        imageWidget,
        Positioned(
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
        ),
      ],
    );

    return GestureDetector(
      onTap: () => _navigateToGalleryPage(context, historyItem),
      child: stack,
    );
  }

  void _navigateToGalleryPage(BuildContext context, HistoryItem historyItem) {
    int page = _historyRepo.getHistoryItems().indexOf(historyItem);

    Navigator.of(context).push(
      MaterialPageRoute(builder: (context) => GalleryPage(_historyRepo, page)),
    );
  }
}
