import 'dart:convert';

import 'package:diet_lenz/core/providers/storage_providers.dart';
import 'package:diet_lenz/core/repositories/storage_repository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:openapi/api.dart';

const int _maxDatabaseHistoryItems = 10;

final databaseLoggedHistoryProvider =
    StateNotifierProvider<DatabaseLoggedHistoryNotifier, List<FoodAnalysisDto>>(
        (ref) {
  final storageRepository = ref.watch(storageRepositoryProvider);
  return DatabaseLoggedHistoryNotifier(storageRepository);
});

class DatabaseLoggedHistoryNotifier
    extends StateNotifier<List<FoodAnalysisDto>> {
  DatabaseLoggedHistoryNotifier(this._storageRepository) : super([]) {
    _loadHistory();
  }

  final StorageRepository _storageRepository;

  void _loadHistory() {
    final historyJson = _storageRepository.getDatabaseLoggedHistory();
    if (historyJson == null || historyJson.isEmpty) return;

    try {
      final decoded = jsonDecode(historyJson);
      state = FoodAnalysisDto.listFromJson(decoded, growable: false);
    } catch (_) {
      state = [];
    }
  }

  Future<void> saveLoggedFood(FoodAnalysisDto food) async {
    final normalizedName = _normalizeFoodName(food.foodName);
    if (normalizedName.isEmpty) return;

    final updatedHistory = [
      food,
      ...state.where(
        (item) => _normalizeFoodName(item.foodName) != normalizedName,
      ),
    ].take(_maxDatabaseHistoryItems).toList(growable: false);

    state = updatedHistory;
    await _storageRepository.saveDatabaseLoggedHistory(
      jsonEncode(updatedHistory.map((item) => item.toJson()).toList()),
    );
  }

  Future<void> clearHistory() async {
    state = [];
    await _storageRepository.clearDatabaseLoggedHistory();
  }

  String _normalizeFoodName(String? foodName) {
    return foodName?.trim().toLowerCase() ?? '';
  }
}
