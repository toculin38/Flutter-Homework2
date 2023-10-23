import 'package:http_downloader/data/history_repository/history_item.dart';
import 'package:http_downloader/domain/history_repository.dart';

class HistoryRepositoryImpl implements HistoryRepository {
  final List<HistoryItem> _historyItems = [];

  @override
  List<HistoryItem> getHistoryItems() {
    return List<HistoryItem>.unmodifiable(_historyItems);
  }

  @override
  void addNewHistoryItem(String url, String filePath) {
    final historyItem = HistoryItem(url: url, filePath: filePath);

    _historyItems.add(historyItem);
  }
}
