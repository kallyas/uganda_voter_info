// lib/features/home/screens/home_screen.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../widgets/search_form.dart';
import '../widgets/voter_card.dart';
import '../providers/voter_provider.dart';
import '../../history/screens/history_screen.dart';
import '../../../widgets/loading_indicator.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    final voterProvider = Provider.of<VoterProvider>(context);
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    
    return Scaffold(
      appBar: AppBar(
        title: const Text('Uganda Voter Info'),
        backgroundColor: colorScheme.primary,
        foregroundColor: colorScheme.onPrimary,
        elevation: 2,
        actions: [
          IconButton(
            icon: const Icon(Icons.history),
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(builder: (context) => const HistoryScreen()),
              );
            },
            tooltip: 'Search History',
          ),
          IconButton(
            icon: const Icon(Icons.brightness_6),
            onPressed: () {
              // Just a placeholder - in a real app, this would toggle theme mode
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(
                    'Theme switching would be implemented here',
                    style: TextStyle(color: colorScheme.onSurface),
                  ),
                  backgroundColor: colorScheme.surface,
                  duration: const Duration(seconds: 2),
                ),
              );
            },
            tooltip: 'Toggle Theme',
          ),
        ],
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              colorScheme.background,
              colorScheme.background,
              colorScheme.background.withOpacity(0.8),
            ],
          ),
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header
                Card(
                  margin: const EdgeInsets.only(bottom: 24),
                  elevation: 0,
                  color: Colors.transparent,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(5),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Find Your Polling Station',
                        style: theme.textTheme.headlineMedium?.copyWith(
                          color: colorScheme.onBackground,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Enter your voter identification number to find your polling station',
                        style: theme.textTheme.bodyMedium?.copyWith(
                          color: colorScheme.onBackground.withOpacity(0.7),
                        ),
                      ),
                    ],
                  ),
                ),
                
                // Search Form
                Card(
                  elevation: 3,
                  margin: EdgeInsets.zero,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: SearchForm(
                      onSearch: (voterId) async {
                        await voterProvider.searchVoter(voterId);
                      },
                    ),
                  ),
                ),
                
                const SizedBox(height: 24),
                
                // Results area
                Expanded(
                  child: _buildResultsArea(voterProvider, colorScheme, theme),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
  
  Widget _buildResultsArea(
    VoterProvider voterProvider, 
    ColorScheme colorScheme,
    ThemeData theme,
  ) {
    if (voterProvider.isLoading) {
      return const Center(
        child: LoadingIndicator(
          message: 'Searching...',
        ),
      );
    }
    
    if (voterProvider.errorMessage != null) {
      return Center(
        child: Card(
          elevation: 2,
          color: theme.brightness == Brightness.dark 
              ? colorScheme.errorContainer 
              : colorScheme.error.withOpacity(0.1),
          margin: const EdgeInsets.symmetric(horizontal: 24),
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.error_outline,
                  color: colorScheme.error,
                  size: 64,
                ),
                const SizedBox(height: 16),
                Text(
                  voterProvider.errorMessage!,
                  style: theme.textTheme.titleMedium?.copyWith(
                    color: theme.brightness == Brightness.dark
                        ? colorScheme.onErrorContainer
                        : colorScheme.error,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 16),
                ElevatedButton.icon(
                  onPressed: () {
                    // Clear error and let the user try again
                    voterProvider.clearError();
                  },
                  icon: const Icon(Icons.refresh),
                  label: const Text('Try Again'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: colorScheme.primary,
                    foregroundColor: colorScheme.onPrimary,
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    }
    
    if (voterProvider.voter != null) {
      return SingleChildScrollView(
        child: VoterCard(voter: voterProvider.voter!),
      );
    }
    
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.how_to_vote,
            size: 72,
            color: colorScheme.primary.withOpacity(0.5),
          ),
          const SizedBox(height: 16),
          Text(
            'Search for a voter to see their polling station',
            style: theme.textTheme.titleMedium?.copyWith(
              color: colorScheme.onBackground.withOpacity(0.7),
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 16),
          Text(
            'Enter your voter ID in the search field above',
            style: theme.textTheme.bodyMedium?.copyWith(
              color: colorScheme.onBackground.withOpacity(0.5),
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}