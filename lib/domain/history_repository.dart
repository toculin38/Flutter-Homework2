import 'package:http_downloader/data/history_repository/history_item.dart';

abstract class HistoryRepository {
  List<HistoryItem> getHistoryItems();
  void addNewHistoryItem(String url, String filePath);
  void deleteHistoryItem(String id);
}
