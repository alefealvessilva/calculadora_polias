import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../../domain/usecases/calculations_usecases.dart';

abstract class HistoryRepository {
  Future<List<HistoryItem>> getHistory();
  Future<void> saveHistoryItem(HistoryItem item);
  Future<void> clearHistory();
}

class HistoryRepositoryImpl implements HistoryRepository {
  static const String _historyKey = 'POLIAS_PRO_HISTORY';
  static const int _maxItems = 10;
  final SharedPreferences prefs;

  HistoryRepositoryImpl(this.prefs);

  @override
  Future<List<HistoryItem>> getHistory() async {
    final List<String>? jsonList = prefs.getStringList(_historyKey);
    if (jsonList == null || jsonList.isEmpty) return [];

    return jsonList
        .map((jsonStr) => HistoryItem.fromJson(jsonDecode(jsonStr)))
        .toList()
      // Sort by date descending (newest first)
      ..sort((a, b) => b.date.compareTo(a.date));
  }

  @override
  Future<void> saveHistoryItem(HistoryItem item) async {
    final history = await getHistory();
    
    // Add new item to the beginning
    history.insert(0, item);

    // Keep only the last _maxItems
    if (history.length > _maxItems) {
      history.removeRange(_maxItems, history.length);
    }

    final List<String> jsonList = history
        .map((e) => jsonEncode(e.toJson()))
        .toList();

    await prefs.setStringList(_historyKey, jsonList);
  }

  @override
  Future<void> clearHistory() async {
    await prefs.remove(_historyKey);
  }
}
