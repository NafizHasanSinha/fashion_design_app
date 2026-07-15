import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../screens/login.dart';

class ConsumerProfileScreen extends StatefulWidget {
  const ConsumerProfileScreen({super.key});

  @override
  State<ConsumerProfileScreen> createState() => _ConsumerProfileScreenState();
}

class _ConsumerProfileScreenState extends State<ConsumerProfileScreen> {
  final SupabaseClient _supabase = Supabase.instance.client;

  User? _currentUser;
  Map<String, dynamic>? _consumerDetails;

  int _totalScansCount = 0;
  int _totalDesignsCount = 0;
  bool _isLoading = true;

  // --- Color Palette matching premium fashion vibe ---
  final Color backgroundBg = const Color(0xFF0F172A); // Deep Slate Dark
  final Color cardBg = const Color(0xFF1E293B); // Lighter Slate for Cards
  final Color primaryIndigo = const Color(0xFF6366F1); // Indigo Accent
  final Color textLight = const Color(0xFFF8FAFC);
  final Color textMuted = const Color(0xFF94A3B8);
  final Color dangerRed = const Color(0xFFEF4444);

  @override
  void initState() {
    super.initState();
    _loadCompleteUserProfile();
  }

  Future<void> _loadCompleteUserProfile() async {
    try {
      final user = _supabase.auth.currentUser;
      if (user != null) {
        _currentUser = user;

        final consumerRes = await _supabase
            .from('consumers')
            .select()
            .eq('id', user.id)
            .maybeSingle();

        if (consumerRes != null) {
          _consumerDetails = consumerRes;
        }

        final scansRes = await _supabase
            .from('body_scans')
            .select('id')
            .eq('user_id', user.id);
        _totalScansCount = scansRes.length;

        final designsRes = await _supabase
            .from('dress_designs')
            .select('id')
            .eq('user_id', user.id);
        _totalDesignsCount = designsRes.length;
      }
    } catch (e) {
      debugPrint("Error loading profile details: $e");
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  Future<void> _handleLogout() async {
    try {
      await _supabase.auth.signOut();
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Logged out successfully! See you again.'),
            backgroundColor: Colors.green,
            behavior: SnackBarBehavior.floating,
          ),
        );

        Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(builder: (context) => const LoginSelectionScreen()),
          (route) => false,
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Logout failed: $e'),
            backgroundColor: dangerRed,
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    }
  }

  String _getInitials() {
    final String? fullName = _consumerDetails?['full_name'];
    if (fullName != null && fullName.trim().isNotEmpty) {
      List<String> names = fullName.trim().split(' ');
      if (names.length >= 2) {
        return (names[0][0] + names[1][0]).toUpperCase();
      }
      return names[0][0].toUpperCase();
    }
    final String? email = _currentUser?.email;
    if (email != null && email.isNotEmpty) {
      return email.substring(0, 2).toUpperCase();
    }
    return 'US';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundBg,
      appBar: AppBar(
        title: const Text(
          'Profile Hub',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.white,
            fontSize: 20,
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh_rounded, color: Colors.white),
            onPressed: () {
              setState(() => _isLoading = true);
              _loadCompleteUserProfile();
            },
            tooltip: 'Refresh Profile',
          ),
        ],
      ),
      body: _isLoading
          ? Center(child: CircularProgressIndicator(color: primaryIndigo))
          : SingleChildScrollView(
              padding: const EdgeInsets.all(24.0),
              physics: const BouncingScrollPhysics(),
              child: Column(
                children: [
                  Center(
                    child: Stack(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(4),
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            gradient: LinearGradient(
                              colors: [
                                primaryIndigo,
                                const Color(0xFFEC4899),
                              ], // Indigo to Pink
                            ),
                          ),
                          child: CircleAvatar(
                            radius: 54,
                            backgroundColor: cardBg,
                            child: Text(
                              _getInitials(),
                              style: TextStyle(
                                color: textLight,
                                fontSize: 32,
                                fontWeight: FontWeight.bold,
                                letterSpacing: 1,
                              ),
                            ),
                          ),
                        ),
                        Positioned(
                          bottom: 2,
                          right: 2,
                          child: Container(
                            padding: const EdgeInsets.all(6),
                            decoration: const BoxDecoration(
                              color: Color(0xFF10B981), // Active Status Green
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(
                              Icons.bolt,
                              color: Colors.white,
                              size: 16,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),

                  // ইউজারের নাম
                  Text(
                    _consumerDetails?['full_name'] ??
                        _currentUser?.email?.split('@')[0] ??
                        'Premium User',
                    style: TextStyle(
                      color: textLight,
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      letterSpacing: -0.5,
                    ),
                  ),
                  const SizedBox(height: 4),

                  // ইউজারের ট্যাগ/রোল
                  Text(
                    'Elite Designer Creator',
                    style: TextStyle(
                      color: primaryIndigo.withValues(alpha: 0.9),
                      fontSize: 13,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 1,
                    ),
                  ),
                  const SizedBox(height: 28),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      _buildStatItem(
                        'Saved Designs',
                        _totalDesignsCount.toString(),
                        Icons.brush_outlined,
                      ),
                      _buildStatItem(
                        'Body Scans',
                        _totalScansCount.toString(),
                        Icons.accessibility_new_outlined,
                      ),
                      _buildStatItem(
                        'Status',
                        'Active Pro',
                        Icons.workspace_premium_outlined,
                      ),
                    ],
                  ),
                  const SizedBox(height: 32),

                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(24),
                    decoration: BoxDecoration(
                      color: cardBg,
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(
                        color: Colors.white.withValues(alpha: 0.05),
                      ),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Primary Account Info',
                          style: TextStyle(
                            color: textLight,
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                        const SizedBox(height: 16),
                        _buildInfoRow(
                          icon: Icons.alternate_email_rounded,
                          label: 'Email Identity',
                          value: _currentUser?.email ?? 'N/A',
                        ),
                        _buildInfoRow(
                          icon: Icons.phone_android_rounded,
                          label: 'Linked Phone',
                          value:
                              _consumerDetails?['phone'] ?? 'No phone linked',
                        ),
                        _buildInfoRow(
                          icon: Icons.shield_outlined,
                          label: 'Account Reference UID',
                          value:
                              _currentUser?.id.substring(0, 12).toUpperCase() ??
                              'N/A',
                        ),
                        _buildInfoRow(
                          icon: Icons.event_available_rounded,
                          label: 'Active Member Since',
                          value: _currentUser?.createdAt != null
                              ? _currentUser!.createdAt.substring(0, 10)
                              : 'N/A',
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 36),

                  InkWell(
                    onTap: _handleLogout,
                    borderRadius: BorderRadius.circular(16),
                    child: Container(
                      width: double.infinity,
                      height: 56,
                      decoration: BoxDecoration(
                        color: dangerRed.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(
                          color: dangerRed.withValues(alpha: 0.3),
                          width: 1.5,
                        ),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.power_settings_new_rounded,
                            color: dangerRed,
                            size: 22,
                          ),
                          const SizedBox(width: 12),
                          Text(
                            'Logout Securely',
                            style: TextStyle(
                              color: dangerRed,
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),
                ],
              ),
            ),
    );
  }

  Widget _buildStatItem(String label, String value, IconData icon) {
    return Column(
      children: [
        Icon(icon, color: textMuted, size: 20),
        const SizedBox(height: 6),
        Text(
          value,
          style: TextStyle(
            color: textLight,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 2),
        Text(label, style: TextStyle(color: textMuted, fontSize: 12)),
      ],
    );
  }

  Widget _buildInfoRow({
    required IconData icon,
    required String label,
    required String value,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20.0),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: backgroundBg,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: primaryIndigo, size: 20),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: TextStyle(
                    color: textMuted,
                    fontSize: 11,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  value,
                  style: TextStyle(
                    color: textLight,
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
