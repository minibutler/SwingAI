import 'package:flutter/material.dart';
import 'package:swing_ai/screens/club_selection_screen.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  // Mock user data
  final String _name = 'Golf Enthusiast';
  final String _email = 'golf.enthusiast@example.com';
  final double _heightCm = 185;
  final String _subscriptionTier = 'Free';
  final int _swingsAnalyzed = 12;
  final int _remainingToday = 3;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('My Profile')),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Profile header
            Container(
              padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 16),
              decoration: BoxDecoration(color: Theme.of(context).primaryColor),
              child: Column(
                children: [
                  // Profile picture
                  const CircleAvatar(
                    radius: 50,
                    backgroundColor: Colors.white,
                    child: Icon(Icons.person, size: 70, color: Colors.grey),
                  ),
                  const SizedBox(height: 16),

                  // Name
                  Text(
                    _name,
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 4),

                  // Email
                  Text(
                    _email,
                    style: const TextStyle(fontSize: 16, color: Colors.white70),
                  ),
                  const SizedBox(height: 16),

                  // Subscription badge
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 8,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 51),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(Icons.star, size: 16, color: Colors.white),
                        const SizedBox(width: 8),
                        Text(
                          '$_subscriptionTier Plan',
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            // Stats section
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Your Stats',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 16),

                  // Stats cards
                  Row(
                    children: [
                      Expanded(
                        child: _buildStatCard(
                          'Swings Analyzed',
                          _swingsAnalyzed.toString(),
                          Icons.analytics,
                          Colors.blue,
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: _buildStatCard(
                          'Remaining Today',
                          _remainingToday.toString(),
                          Icons.access_time,
                          Colors.orange,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            // Settings section
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Settings',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 16),

                  // Settings list
                  _buildSettingItem(
                    'Personal Information',
                    Icons.person,
                    onTap: () {
                      _showEditProfileDialog();
                    },
                  ),
                  const Divider(),
                  _buildSettingItem(
                    'My Golf Clubs',
                    Icons.golf_course,
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const ClubSelectionScreen(),
                        ),
                      );
                    },
                  ),
                  const Divider(),
                  _buildSettingItem(
                    'Subscription Plan',
                    Icons.card_membership,
                    onTap: () {
                      _showUpgradeDialog();
                    },
                  ),
                  const Divider(),
                  _buildSettingItem(
                    'Notification Settings',
                    Icons.notifications,
                    onTap: () {
                      // Not implemented in MVP
                    },
                  ),
                  const Divider(),
                  _buildSettingItem(
                    'Privacy Policy',
                    Icons.privacy_tip,
                    onTap: () {
                      // Not implemented in MVP
                    },
                  ),
                  const Divider(),
                  _buildSettingItem(
                    'Terms of Service',
                    Icons.description,
                    onTap: () {
                      // Not implemented in MVP
                    },
                  ),
                  const Divider(),
                  _buildSettingItem(
                    'About SwingAI',
                    Icons.info,
                    onTap: () {
                      // Not implemented in MVP
                    },
                  ),
                  const Divider(),
                  _buildSettingItem(
                    'Log Out',
                    Icons.logout,
                    textColor: Colors.red,
                    onTap: () {
                      _confirmLogout();
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Build a stat card
  Widget _buildStatCard(
    String title,
    String value,
    IconData icon,
    Color color,
  ) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(icon, color: color, size: 28),
            const SizedBox(height: 12),
            Text(
              value,
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: color,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              title,
              style: TextStyle(fontSize: 14, color: Colors.grey[600]),
            ),
          ],
        ),
      ),
    );
  }

  // Build a setting item
  Widget _buildSettingItem(
    String title,
    IconData icon, {
    required VoidCallback onTap,
    Color? textColor,
  }) {
    return ListTile(
      leading: Icon(icon),
      title: Text(title, style: TextStyle(color: textColor)),
      trailing: const Icon(Icons.chevron_right),
      onTap: onTap,
    );
  }

  // Show dialog to edit profile
  void _showEditProfileDialog() {
    final nameController = TextEditingController(text: _name);
    final emailController = TextEditingController(text: _email);
    final heightController = TextEditingController(text: _heightCm.toString());

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Edit Profile'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: nameController,
                decoration: const InputDecoration(labelText: 'Name'),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: emailController,
                decoration: const InputDecoration(labelText: 'Email'),
                readOnly: true, // Email is read-only in MVP
              ),
              const SizedBox(height: 16),
              TextField(
                controller: heightController,
                decoration: const InputDecoration(labelText: 'Height (cm)'),
                keyboardType: TextInputType.number,
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              // In a real app, this would update the user profile
              // For MVP, just close the dialog
              Navigator.of(context).pop();

              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Profile updated successfully'),
                ),
              );
            },
            child: const Text('Save'),
          ),
        ],
      ),
    );
  }

  // Show upgrade dialog
  void _showUpgradeDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Upgrade Plan'),
        content: const Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              title: Text('Free'),
              subtitle: Text('3 analyses per day'),
              trailing: Icon(Icons.check_circle, color: Colors.green),
            ),
            ListTile(
              title: Text('Pro - \$9.99/month'),
              subtitle: Text('Unlimited analyses + AR overlay'),
            ),
            ListTile(
              title: Text('Elite - \$29.99/month'),
              subtitle: Text('Live pro reviews + equipment recs'),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              // In a real app, this would initiate the upgrade process
              // For MVP, just close the dialog
              Navigator.of(context).pop();

              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Subscription upgrade coming soon'),
                ),
              );
            },
            child: const Text('Upgrade'),
          ),
        ],
      ),
    );
  }

  // Confirm logout
  void _confirmLogout() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Log Out'),
        content: const Text('Are you sure you want to log out?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              // In a real app, this would perform logout
              // For MVP, navigate to login screen
              Navigator.of(context).pushReplacementNamed('/login');
            },
            child: const Text('Log Out'),
          ),
        ],
      ),
    );
  }
}
