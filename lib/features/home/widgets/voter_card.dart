import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:share_plus/share_plus.dart';
import '../../../core/models/voter_model.dart';

class VoterCard extends StatelessWidget {
  final VoterModel voter;

  const VoterCard({
    super.key,
    required this.voter,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8),
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                CircleAvatar(
                  backgroundColor: colorScheme.primary,
                  radius: 28,
                  child: Text(
                    voter.names.isNotEmpty ? voter.names[0] : '?',
                    style: TextStyle(
                      color: colorScheme.onPrimary,
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        voter.names,
                        style: theme.textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: colorScheme.onSurface,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Voter ID: ${voter.voterIdentificationNumber}',
                        style: theme.textTheme.bodyMedium?.copyWith(
                          color: colorScheme.secondary,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'DOB: ${voter.dateOfBirth} | Gender: ${voter.gender}',
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: colorScheme.onSurface.withOpacity(0.7),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            
            Divider(
              height: 32,
              color: colorScheme.onSurface.withOpacity(0.2),
            ),
            
            // Polling Information Section
            _buildInfoSection(
              context,
              title: 'Polling Station',
              value: voter.pollingStation,
              icon: Icons.location_on,
              isHighlighted: true,
            ),
            
            _buildInfoSection(
              context,
              title: 'District',
              value: voter.district,
              icon: Icons.location_city,
            ),
            
            _buildInfoSection(
              context,
              title: 'Electoral Area',
              value: voter.electoralArea,
              icon: Icons.map,
            ),
            
            Row(
              children: [
                Expanded(
                  child: _buildInfoSection(
                    context,
                    title: 'Sub County',
                    value: voter.subCounty,
                    icon: Icons.business,
                    isCompact: true,
                  ),
                ),
                Expanded(
                  child: _buildInfoSection(
                    context,
                    title: 'Parish',
                    value: voter.parish,
                    icon: Icons.home_work,
                    isCompact: true,
                  ),
                ),
              ],
            ),
            
            _buildInfoSection(
              context,
              title: 'Village',
              value: voter.village,
              icon: Icons.house,
            ),
            
            const SizedBox(height: 16),
            
            // Action buttons
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton.icon(
                  icon: const Icon(Icons.share),
                  label: const Text('Share'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: colorScheme.secondary,
                    foregroundColor: colorScheme.onSecondary,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 12,
                    ),
                  ),
                  onPressed: () {
                    _shareVoterInfo(context);
                  },
                ),
                ElevatedButton.icon(
                  icon: const Icon(Icons.copy),
                  label: const Text('Copy'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: colorScheme.surface,
                    foregroundColor: colorScheme.primary,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 12,
                    ),
                    side: BorderSide(color: colorScheme.primary),
                  ),
                  onPressed: () {
                    _copyVoterInfo(context);
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoSection(
    BuildContext context, {
    required String title,
    required String value,
    required IconData icon,
    bool isHighlighted = false,
    bool isCompact = false,
  }) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    
    return Padding(
      padding: EdgeInsets.symmetric(vertical: isCompact ? 4.0 : 8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            icon,
            size: 20,
            color: isHighlighted
                ? colorScheme.secondary
                : colorScheme.onSurface.withOpacity(0.6),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: colorScheme.onSurface.withOpacity(0.7),
                    fontWeight: isHighlighted ? FontWeight.bold : FontWeight.normal,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  value,
                  style: theme.textTheme.bodyLarge?.copyWith(
                    fontSize: isHighlighted ? 18 : 16,
                    fontWeight: isHighlighted ? FontWeight.bold : FontWeight.normal,
                    color: isHighlighted
                        ? colorScheme.secondary
                        : colorScheme.onSurface,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // Share voter information using share_plus package
  void _shareVoterInfo(BuildContext context) async {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    
    final String info = '''
🗳️ VOTER INFORMATION 🗳️

Voter: ${voter.names}
ID: ${voter.voterIdentificationNumber}
Date of Birth: ${voter.dateOfBirth}
Gender: ${voter.gender}

🏢 POLLING STATION:
${voter.pollingStation}
District: ${voter.district}
Electoral Area: ${voter.electoralArea}
Sub County: ${voter.subCounty}
Parish: ${voter.parish}
Village: ${voter.village}

Shared via Uganda Voter Info App
''';

    try {
      // Using share_plus to share text
      await Share.share(
        info,
        subject: 'Voter Information for ${voter.names}',
      );
    } catch (e) {
      // Handle any errors with sharing
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'Could not share information: ${e.toString()}',
              style: TextStyle(color: colorScheme.onError),
            ),
            backgroundColor: colorScheme.error,
            duration: const Duration(seconds: 3),
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
        );
      }
    }
  }

  void _copyVoterInfo(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    
    final String info = '''
Voter: ${voter.names}
ID: ${voter.voterIdentificationNumber}
Polling Station: ${voter.pollingStation}
District: ${voter.district}
Electoral Area: ${voter.electoralArea}
Sub County: ${voter.subCounty}
Parish: ${voter.parish}
Village: ${voter.village}
''';

    Clipboard.setData(ClipboardData(text: info));
    
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            Icon(
              Icons.check_circle,
              color: colorScheme.secondary,
              size: 20,
            ),
            const SizedBox(width: 8),
            Text(
              'Voter information copied to clipboard',
              style: TextStyle(color: colorScheme.onSurface),
            ),
          ],
        ),
        backgroundColor: colorScheme.surface,
        duration: const Duration(seconds: 2),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ),
    );
  }
}