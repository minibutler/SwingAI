import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../models/club.dart';
import '../models/swing_analysis.dart';

class HistoryScreen extends StatefulWidget {
  const HistoryScreen({super.key});

  @override
  State<HistoryScreen> createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final List<SwingAnalysis> _mockSwingHistory = [];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    _generateMockData();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  // Generate mock data for the history screen
  void _generateMockData() {
    // Add some mock swing analyses
    final now = DateTime.now();

    // Today's swings
    _mockSwingHistory.add(
      SwingAnalysis(
        id: '1',
        timestamp: now.subtract(const Duration(hours: 2)),
        userId: 'user123',
        videoUrl: 'mock_url_1',
        club: Club.driver,
        swingSpeedMph: 97.5,
        ballSpeedMph: 142.2,
        carryDistanceYards: 253.8,
        detectedErrors: [SwingError.overTheTop],
        errorConfidence: {
          'overTheTop': 0.7,
          'earlyExtension': 0.3,
          'casting': 0.2,
        },
        accuracy: 76.0,
      ),
    );

    // Yesterday's swings
    _mockSwingHistory.add(
      SwingAnalysis(
        id: '2',
        timestamp: now.subtract(const Duration(days: 1, hours: 5)),
        userId: 'user123',
        videoUrl: 'mock_url_2',
        club: Club.iron7,
        swingSpeedMph: 83.2,
        ballSpeedMph: 110.7,
        carryDistanceYards: 163.1,
        detectedErrors: [SwingError.none],
        errorConfidence: {
          'overTheTop': 0.1,
          'earlyExtension': 0.2,
          'casting': 0.3,
        },
        accuracy: 89.0,
      ),
    );

    // Older swings
    _mockSwingHistory.add(
      SwingAnalysis(
        id: '3',
        timestamp: now.subtract(const Duration(days: 3, hours: 2)),
        userId: 'user123',
        videoUrl: 'mock_url_3',
        club: Club.pitchingWedge,
        swingSpeedMph: 73.8,
        ballSpeedMph: 92.3,
        carryDistanceYards: 105.6,
        detectedErrors: [SwingError.earlyExtension, SwingError.casting],
        errorConfidence: {
          'overTheTop': 0.2,
          'earlyExtension': 0.8,
          'casting': 0.6,
        },
        accuracy: 64.0,
      ),
    );

    _mockSwingHistory.add(
      SwingAnalysis(
        id: '4',
        timestamp: now.subtract(const Duration(days: 7, hours: 4)),
        userId: 'user123',
        videoUrl: 'mock_url_4',
        club: Club.driver,
        swingSpeedMph: 94.1,
        ballSpeedMph: 137.4,
        carryDistanceYards: 240.3,
        detectedErrors: [SwingError.overTheTop],
        errorConfidence: {
          'overTheTop': 0.6,
          'earlyExtension': 0.2,
          'casting': 0.2,
        },
        accuracy: 79.0,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Swing History'),
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(text: 'All'),
            Tab(text: 'By Club'),
            Tab(text: 'Stats'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          // All swings tab
          _buildSwingHistoryList(),

          // By club tab
          _buildClubFilterView(),

          // Stats tab
          _buildStatsView(),
        ],
      ),
    );
  }

  // Build the list of all swings
  Widget _buildSwingHistoryList({Club? filterClub}) {
    // Apply filter if provided
    final filteredSwings =
        filterClub != null
            ? _mockSwingHistory
                .where((swing) => swing.club.id == filterClub.id)
                .toList()
            : _mockSwingHistory;

    if (filteredSwings.isEmpty) {
      return const Center(child: Text('No swing history found'));
    }

    return ListView.builder(
      itemCount: filteredSwings.length,
      padding: const EdgeInsets.all(16),
      itemBuilder: (context, index) {
        final swing = filteredSwings[index];
        return _buildSwingHistoryCard(swing);
      },
    );
  }

  // Build a card for each swing analysis
  Widget _buildSwingHistoryCard(SwingAnalysis swing) {
    final dateFormat = DateFormat('MMM d, yyyy • h:mm a');
    final formattedDate = dateFormat.format(swing.timestamp);

    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      child: InkWell(
        onTap: () {
          // Navigate to the result screen with this analysis
          Navigator.of(context).pushNamed('/results', arguments: swing);
        },
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Date and club
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    formattedDate,
                    style: TextStyle(color: Colors.grey[600], fontSize: 14),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: Theme.of(
                        context,
                      ).primaryColor.withValues(alpha: 26),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Text(
                      swing.club.name,
                      style: TextStyle(
                        color: Theme.of(context).primaryColor,
                        fontWeight: FontWeight.bold,
                        fontSize: 12,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),

              // Key metrics
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _buildMetricColumn('Speed', '${swing.swingSpeedMph}', 'mph'),
                  _buildMetricColumn(
                    'Distance',
                    '${swing.carryDistanceYards.round()}',
                    'yds',
                  ),
                  _buildMetricColumn(
                    'Accuracy',
                    '${swing.accuracy.round()}',
                    '%',
                  ),
                ],
              ),
              const SizedBox(height: 16),

              // Errors
              if (swing.detectedErrors.contains(SwingError.none))
                const Text(
                  'No major errors detected',
                  style: TextStyle(color: Colors.green),
                )
              else
                Text(
                  swing.getErrorsDescription(),
                  style: const TextStyle(color: Colors.orange),
                ),

              // View details button
              Align(
                alignment: Alignment.centerRight,
                child: TextButton.icon(
                  icon: const Icon(Icons.arrow_forward),
                  label: const Text('View Details'),
                  onPressed: () {
                    Navigator.of(
                      context,
                    ).pushNamed('/results', arguments: swing);
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Build a column for displaying a metric
  Widget _buildMetricColumn(String label, String value, String unit) {
    return Column(
      children: [
        Text(label, style: TextStyle(color: Colors.grey[600], fontSize: 12)),
        const SizedBox(height: 4),
        Row(
          crossAxisAlignment: CrossAxisAlignment.baseline,
          textBaseline: TextBaseline.alphabetic,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              value,
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(width: 2),
            Text(unit, style: TextStyle(fontSize: 12, color: Colors.grey[600])),
          ],
        ),
      ],
    );
  }

  // Build the club filter view
  Widget _buildClubFilterView() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Select Club',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),

          // Club selection
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children:
                Club.availableClubs.map((club) {
                  return ElevatedButton(
                    onPressed: () {
                      setState(() {
                        _tabController.animateTo(0);
                        // This would filter the list in a full implementation
                      });
                    },
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 12,
                      ),
                    ),
                    child: Text(club.name),
                  );
                }).toList(),
          ),

          const SizedBox(height: 24),
          const Divider(),
          const SizedBox(height: 16),

          // Club stats sections - this would show club-specific stats in a full implementation
          Expanded(
            child: Center(
              child: Text(
                'Club statistics coming soon',
                style: TextStyle(color: Colors.grey[400], fontSize: 16),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Build the statistics view
  Widget _buildStatsView() {
    // This would show statistics in a full implementation
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.bar_chart, size: 80, color: Colors.grey[300]),
          const SizedBox(height: 16),
          Text(
            'Detailed statistics coming soon',
            style: TextStyle(color: Colors.grey[400], fontSize: 16),
          ),
          const SizedBox(height: 8),
          Text(
            'Upgrade to Pro to unlock advanced statistics',
            style: TextStyle(color: Colors.grey[600], fontSize: 14),
          ),
          const SizedBox(height: 24),
          ElevatedButton(
            onPressed: () {
              // Upgrade action not implemented in MVP
            },
            child: const Text('Upgrade to Pro'),
          ),
        ],
      ),
    );
  }
}
