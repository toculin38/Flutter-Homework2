import 'dart:io';

import 'package:http_downloader/data/history_repository/history_item.dart';
import 'package:http_downloader/domain/history_repository.dart';
import 'package:hive/hive.dart';

class HistoryRepositoryImpl implements HistoryRepository {
  late Box<HistoryItem> _historyBox;

  HistoryRepositoryImpl() {
    _openBoxThenDeleteNonExistItems();
  }

  _openBoxThenDeleteNonExistItems() async {
    _historyBox = await Hive.openBox<HistoryItem>('historyRepo');
    _deleteNonExistItems();
  }

  _deleteNonExistItems() {
    List<HistoryItem> historyItems = getHistoryItems();

    for (HistoryItem historyItem in historyItems) {
      File imageFile = File(historyItem.filePath);

      if (imageFile.existsSync() == false) {
        deleteHistoryItem(historyItem.id);
      }
    }
  }

  @override
  List<HistoryItem> getHistoryItems() {
    return List<HistoryItem>.unmodifiable(_historyBox.values.toList());
  }

  @override
  void addNewHistoryItem(String url, String filePath) {
    final historyItem =
        HistoryItem(id: _generateId(), url: url, filePath: filePath);
    _historyBox.put(historyItem.id, historyItem);
  }

  @override
  void deleteHistoryItem(String id) {
    _historyBox.delete(id);
  }

  String _generateId() {
    return DateTime.now().millisecondsSinceEpoch.toString();
  }
}
