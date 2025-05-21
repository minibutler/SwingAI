import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:swing_ai/models/golf_club.dart';
import 'package:swing_ai/providers/club_selection_provider.dart';

class ClubSelectionScreen extends StatefulWidget {
  const ClubSelectionScreen({super.key});

  @override
  State<ClubSelectionScreen> createState() => _ClubSelectionScreenState();
}

class _ClubSelectionScreenState extends State<ClubSelectionScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final List<int> _years = [2025, 2023, 2021, 2017, 2013];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(
        length: _years.length + 1, vsync: this); // +1 for My Clubs tab
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Golf Clubs'),
        bottom: TabBar(
          controller: _tabController,
          isScrollable: true,
          tabs: [
            const Tab(text: 'My Clubs'), // First tab for managing current clubs
            ..._years.map((year) => Tab(text: year.toString())).toList(),
          ],
        ),
      ),
      body: Consumer<ClubSelectionProvider>(
        builder: (context, provider, child) {
          if (provider.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          return TabBarView(
            controller: _tabController,
            children: [
              _CurrentClubsTab(), // First tab content
              ..._years.map((year) => _YearClubsTab(year: year)).toList(),
            ],
          );
        },
      ),
    );
  }
}

// New tab to display and manage the currently selected club set
class _CurrentClubsTab extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<ClubSelectionProvider>(context);
    final selectedClubs = provider.selectedClubs;
    final selectedSet = provider.selectedSet;

    if (selectedSet == null) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.golf_course, size: 64, color: Colors.grey),
            const SizedBox(height: 16),
            const Text(
              'No club set selected yet',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            const Text(
              'Select a club set from one of the year tabs',
              style: TextStyle(color: Colors.grey),
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: () {
                // Switch to the first year tab (2025)
                (context
                        .findAncestorStateOfType<_ClubSelectionScreenState>()
                        ?._tabController)
                    ?.animateTo(1);
              },
              child: const Text('Browse Club Sets'),
            ),
          ],
        ),
      );
    }

    return Column(
      children: [
        // Main content in a scrollable area
        Expanded(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Current club set info
                  Card(
                    elevation: 4,
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                '${selectedSet.brand} ${selectedSet.model}',
                                style: const TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Text(
                                '${selectedSet.year}',
                                style: TextStyle(
                                  color: Theme.of(context).colorScheme.primary,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 8),
                          Row(
                            children: [
                              const Icon(Icons.golf_course, size: 16),
                              const SizedBox(width: 4),
                              Text(
                                '${selectedClubs.length} club${selectedClubs.length != 1 ? 's' : ''} selected',
                                style: TextStyle(color: Colors.grey[600]),
                              ),
                            ],
                          ),
                          const SizedBox(height: 16),

                          // Action buttons
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              TextButton.icon(
                                onPressed: () {
                                  // Navigate to club detail selection
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => _ClubDetailScreen(
                                          clubSet: selectedSet),
                                    ),
                                  );
                                },
                                icon: const Icon(Icons.edit),
                                label: const Text('Edit Clubs'),
                              ),
                              TextButton.icon(
                                onPressed: () {
                                  _showChangeClubSetDialog(context);
                                },
                                icon: const Icon(Icons.swap_horiz),
                                label: const Text('Change Set'),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),

                  const SizedBox(height: 24),
                  const Text(
                    'Your Selected Clubs',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),

                  // List of selected clubs
                  if (selectedClubs.isEmpty)
                    const Padding(
                      padding: EdgeInsets.all(16.0),
                      child: Text(
                        'No clubs selected yet. Tap "Edit Clubs" to select the clubs in your bag.',
                        style: TextStyle(
                            fontStyle: FontStyle.italic, color: Colors.grey),
                      ),
                    )
                  else
                    ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: selectedClubs.length,
                      itemBuilder: (context, index) {
                        final club = selectedClubs[index];
                        return Card(
                          margin: const EdgeInsets.only(bottom: 8),
                          child: ListTile(
                            leading: CircleAvatar(
                              backgroundColor: Theme.of(context)
                                  .colorScheme
                                  .primary
                                  .withOpacity(0.2),
                              child: Text(club.type,
                                  style: const TextStyle(
                                      fontWeight: FontWeight.bold)),
                            ),
                            title: Text(club.type),
                            subtitle: Text('Loft: ${club.loft}°'),
                          ),
                        );
                      },
                    ),
                ],
              ),
            ),
          ),
        ),

        // Add New Club Set button at the bottom
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: ElevatedButton.icon(
            onPressed: () {
              // Navigate to the first year tab (2025)
              (context
                      .findAncestorStateOfType<_ClubSelectionScreenState>()
                      ?._tabController)
                  ?.animateTo(1);
            },
            icon: const Icon(Icons.add),
            label: const Text('Add New Club Set'),
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 12),
              minimumSize: const Size.fromHeight(50), // Full width button
            ),
          ),
        ),
      ],
    );
  }

  // Show dialog to change club set
  void _showChangeClubSetDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Change Club Set'),
          content: const Text(
              'Select a year tab to browse and choose a different club set.'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Cancel'),
            ),
            ...List.generate(
                5,
                (index) => TextButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                        // Switch to the selected year tab (index + 1 because tab 0 is "My Clubs")
                        (context
                                .findAncestorStateOfType<
                                    _ClubSelectionScreenState>()
                                ?._tabController)
                            ?.animateTo(index + 1);
                      },
                      child: Text(
                          [2025, 2023, 2021, 2017, 2013][index].toString()),
                    )),
          ],
        );
      },
    );
  }
}

class _YearClubsTab extends StatelessWidget {
  final int year;

  const _YearClubsTab({required this.year});

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<ClubSelectionProvider>(context);
    final clubSets = provider.getClubSetsByYear(year);

    if (clubSets.isEmpty) {
      return const Center(child: Text('No club sets available for this year'));
    }

    return ListView.builder(
      itemCount: clubSets.length,
      itemBuilder: (context, index) {
        final clubSet = clubSets[index];
        return _ClubSetCard(clubSet: clubSet);
      },
    );
  }
}

class _ClubSetCard extends StatelessWidget {
  final ClubSet clubSet;

  const _ClubSetCard({required this.clubSet});

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<ClubSelectionProvider>(context);
    final isSelected = provider.selectedSetId == clubSet.id;

    return Card(
      margin: const EdgeInsets.all(8.0),
      elevation: isSelected ? 4 : 1,
      color: isSelected ? Theme.of(context).colorScheme.primaryContainer : null,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ListTile(
            title: Text(
              '${clubSet.brand} ${clubSet.model}',
              style: TextStyle(
                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
              ),
            ),
            subtitle: Text('${clubSet.year}'),
            trailing: isSelected
                ? Icon(Icons.check_circle,
                    color: Theme.of(context).colorScheme.primary)
                : const Icon(Icons.arrow_forward_ios, size: 16),
            onTap: () {
              if (isSelected) {
                // Navigate to club detail selection
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => _ClubDetailScreen(clubSet: clubSet),
                  ),
                );
              } else {
                // Select this club set
                provider.selectClubSet(clubSet.id);

                // Automatically navigate to detail selection
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => _ClubDetailScreen(clubSet: clubSet),
                  ),
                );
              }
            },
          ),
          if (isSelected)
            Padding(
              padding:
                  const EdgeInsets.only(left: 16.0, right: 16.0, bottom: 16.0),
              child: Wrap(
                spacing: 8.0,
                runSpacing: 8.0,
                children: [
                  for (final club in provider.selectedClubs)
                    Chip(
                      label: Text('${club.type} (${club.loft}°)'),
                      backgroundColor: Theme.of(context)
                          .colorScheme
                          .primary
                          .withOpacity(0.2),
                    ),
                  if (provider.selectedClubs.isEmpty)
                    const Text('No clubs selected. Tap to select clubs.'),
                ],
              ),
            ),
        ],
      ),
    );
  }
}

class _ClubDetailScreen extends StatefulWidget {
  final ClubSet clubSet;

  const _ClubDetailScreen({required this.clubSet});

  @override
  State<_ClubDetailScreen> createState() => _ClubDetailScreenState();
}

class _ClubDetailScreenState extends State<_ClubDetailScreen> {
  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<ClubSelectionProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text('${widget.clubSet.brand} ${widget.clubSet.model}'),
        actions: [
          TextButton.icon(
            onPressed: () {
              provider.clearSelectedClubs();
            },
            icon: const Icon(Icons.clear_all),
            label: const Text('Clear All'),
            style: TextButton.styleFrom(foregroundColor: Colors.white),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text(
                'Select the clubs in your bag:',
                style: Theme.of(context).textTheme.titleMedium,
              ),
            ),
            const Divider(),
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: widget.clubSet.clubs.length,
              itemBuilder: (context, index) {
                final club = widget.clubSet.clubs[index];
                final isSelected = provider.isClubSelected(club.id);

                return ListTile(
                  title: Text(club.type),
                  subtitle: Text('Loft: ${club.loft}°'),
                  trailing: isSelected
                      ? Icon(Icons.check_circle,
                          color: Theme.of(context).colorScheme.primary)
                      : const Icon(Icons.circle_outlined),
                  onTap: () {
                    provider.toggleClub(club.id);
                  },
                );
              },
            ),
          ],
        ),
      ),
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: ElevatedButton(
            onPressed: () {
              Navigator.pop(context);

              // If coming from year tabs, also go back to the my clubs tab
              if (provider.selectedClubs.isNotEmpty) {
                Future.delayed(const Duration(milliseconds: 300), () {
                  final state = context
                      .findAncestorStateOfType<_ClubSelectionScreenState>();
                  if (state != null && state.mounted) {
                    state._tabController
                        .animateTo(0); // Switch to "My Clubs" tab
                  }
                });
              }
            },
            child: const Text('Save Selection'),
          ),
        ),
      ),
    );
  }
}
