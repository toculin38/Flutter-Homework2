import 'package:hive/hive.dart';

part 'history_item.g.dart'; // Hive 生成的代碼的名稱

@HiveType(typeId: 0)
class HistoryItem {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final String url;

  @HiveField(2)
  final String filePath;

  HistoryItem({required this.id, required this.url, required this.filePath});
}
