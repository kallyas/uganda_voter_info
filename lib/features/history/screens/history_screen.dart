import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../core/theme/app_theme.dart';
import '../../../widgets/animated_list_item.dart';
import '../../home/providers/voter_provider.dart';
import '../widgets/history_item.dart';

class HistoryScreen extends StatelessWidget {
  const HistoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Correctly access the StorageService from the VoterProvider instead
    final voterProvider = Provider.of<VoterProvider>(context, listen: false);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Search History'),
        actions: [
          IconButton(
            icon: const Icon(Icons.delete_sweep),
            onPressed: () {
              _showClearHistoryDialog(context);
            },
          ),
        ],
      ),
      body: Consumer<VoterProvider>(
        builder: (context, provider, child) {
          // Get the history directly from the provider's storageService
          final history = provider.getSearchHistory();

          if (history.isEmpty) {
            return const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.history,
                    size: 72,
                    color: AppTheme.textSecondaryColor,
                  ),
                  SizedBox(height: 16),
                  Text(
                    'Your search history is empty',
                    style: AppTheme.headlineSmall,
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: 8),
                  Text(
                    'Searched voters will appear here',
                    style: AppTheme.bodyMedium,
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            );
          }

          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: history.length,
            itemBuilder: (context, index) {
              final voter = history[index];
              return AnimatedListItem(
                index: index,
                child: HistoryItem(
                  voter: voter,
                  onTap: () {
                    // Update the selected voter in the provider
                    provider.setSelectedVoter(voter);

                    // Go back to home screen
                    Navigator.of(context).pop();
                  },
                ),
              );
            },
          );
        },
      ),
    );
  }

  void _showClearHistoryDialog(BuildContext context) {
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: const Text('Clear History'),
            content: const Text(
              'Are you sure you want to clear your search history? This action cannot be undone.',
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: const Text('CANCEL'),
              ),
              TextButton(
                onPressed: () {
                  final voterProvider = Provider.of<VoterProvider>(
                    context,
                    listen: false,
                  );
                  voterProvider.clearSearchHistory();
                  Navigator.of(context).pop();
                },
                child: const Text(
                  'CLEAR',
                  style: TextStyle(color: AppTheme.errorColor),
                ),
              ),
            ],
          ),
    );
  }
}
