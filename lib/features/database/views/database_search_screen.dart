import 'dart:async';

import 'package:diet_lenz/component/custom_textfield.dart';
import 'package:diet_lenz/constants/app_colors.dart';
import 'package:diet_lenz/features/database/controller/database_history_provider.dart';
import 'package:diet_lenz/features/database/views/manual_log_screen.dart';
import 'package:diet_lenz/features/database/widgets/database_message_state.dart';
import 'package:diet_lenz/features/database/widgets/food_search_result_tile.dart';
import 'package:diet_lenz/features/database/widgets/history_header.dart';
import 'package:diet_lenz/features/database/widgets/manual_add_bar.dart';
import 'package:diet_lenz/features/recipe/controller/recipe_viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class DatabaseSearchScreen extends ConsumerStatefulWidget {
  const DatabaseSearchScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _DatabaseSearchScreenState();
}

class _DatabaseSearchScreenState extends ConsumerState<DatabaseSearchScreen> {
  final TextEditingController _searchController = TextEditingController();
  Timer? _debounce;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(recipeViewModelProvider.notifier).clearSearchResults();
    });
  }

  @override
  void dispose() {
    _debounce?.cancel();
    _searchController.dispose();
    super.dispose();
  }

  void _onSearchChanged(String value) {
    _debounce?.cancel();

    final query = value.trim();
    if (query.isEmpty) {
      ref.read(recipeViewModelProvider.notifier).clearSearchResults();
      return;
    }

    _debounce = Timer(const Duration(milliseconds: 500), () {
      ref.read(recipeViewModelProvider.notifier).searchFood(query);
    });
  }

  void _searchNow() {
    _debounce?.cancel();
    ref
        .read(recipeViewModelProvider.notifier)
        .searchFood(_searchController.text);
    FocusScope.of(context).unfocus();
  }

  void _openManualAdd() {
    FocusScope.of(context).unfocus();
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => const ManualLogScreen(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final recipeState = ref.watch(recipeViewModelProvider);

    return Scaffold(
      appBar: AppBar(
        centerTitle: false,
        title: const Text('Database'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            LabelTextFormField(
              controller: _searchController,
              hintText: 'Search Meal',
              textInputAction: TextInputAction.search,
              onChanged: _onSearchChanged,
              onEditingComplete: _searchNow,
              suffixIcon: IconButton(
                onPressed: _searchNow,
                icon: const Icon(Icons.search),
              ),
            ),
            const SizedBox(height: 20),
            Expanded(child: _buildSearchBody(recipeState)),
          ],
        ),
      ),
      bottomNavigationBar: ManualAddBar(onTap: _openManualAdd),
    );
  }

  Widget _buildSearchBody(RecipeState recipeState) {
    final loggedHistory = ref.watch(databaseLoggedHistoryProvider);
    final results = recipeState.searchResults ?? [];
    final query = recipeState.searchQuery;

    if (recipeState.isLoading && query.isNotEmpty) {
      return const Center(
        child: CircularProgressIndicator(color: AppColors.primaryColor),
      );
    }

    if (recipeState.errorMessage != null &&
        recipeState.errorMessage!.isNotEmpty &&
        query.isNotEmpty) {
      return DatabaseMessageState(
        icon: Icons.error_outline,
        title: 'Search failed',
        message: recipeState.errorMessage!,
      );
    }

    if (query.isEmpty) {
      if (loggedHistory.isEmpty) {
        return const DatabaseMessageState(
          icon: Icons.search_rounded,
          title: 'Search the food database',
          message: 'Find meals and ingredients by name.',
        );
      }

      return ListView.separated(
        keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
        itemCount: loggedHistory.length + 1,
        separatorBuilder: (_, index) => index == 0
            ? const SizedBox(height: 16)
            : const SizedBox(height: 12),
        itemBuilder: (context, index) {
          if (index == 0) {
            return const HistoryHeader();
          }

          return FoodSearchResultTile(
            food: loggedHistory[index - 1],
            fromDatabaseSearch: true,
          );
        },
      );
    }

    if (results.isEmpty) {
      return DatabaseMessageState(
        icon: Icons.manage_search_rounded,
        title: 'No results found',
        message: 'Try a different search for "$query".',
      );
    }

    return ListView.separated(
      keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
      itemCount: results.length,
      separatorBuilder: (_, __) => const SizedBox(height: 12),
      itemBuilder: (context, index) {
        return FoodSearchResultTile(
          food: results[index],
          fromDatabaseSearch: true,
        );
      },
    );
  }
}
