import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:calculadora_polias/core/utils/unit_converter.dart';
import 'package:calculadora_polias/data/datasources/history_local_datasource.dart';
import 'package:calculadora_polias/domain/usecases/calculations_usecases.dart';

final sharedPreferencesProvider = FutureProvider<SharedPreferences>((ref) async {
  return await SharedPreferences.getInstance();
});

final historyRepositoryProvider = Provider<HistoryRepository?>((ref) {
  final prefsAsync = ref.watch(sharedPreferencesProvider);
  return prefsAsync.when(
    data: (prefs) => HistoryRepositoryImpl(prefs),
    loading: () => null,
    error: (_, _) => null,
  );
});

final unitProvider = Provider<MeasurementUnit>((ref) => MeasurementUnit.mm);

class HistoryNotifier extends AsyncNotifier<List<HistoryItem>> {
  @override
  Future<List<HistoryItem>> build() async {
    final repo = ref.watch(historyRepositoryProvider);
    if (repo == null) return [];
    return await repo.getHistory();
  }

  Future<void> addHistoryItem(HistoryItem item) async {
    final repo = ref.read(historyRepositoryProvider);
    if (repo == null) return;
    state = const AsyncValue.loading();
    try {
      await repo.saveHistoryItem(item);
      final list = await repo.getHistory();
      state = AsyncValue.data(list);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }

  Future<void> clearAll() async {
    final repo = ref.read(historyRepositoryProvider);
    if (repo == null) return;
    state = const AsyncValue.loading();
    try {
      await repo.clearHistory();
      final list = await repo.getHistory();
      state = AsyncValue.data(list);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }
}

final historyProvider = AsyncNotifierProvider<HistoryNotifier, List<HistoryItem>>(HistoryNotifier.new);
