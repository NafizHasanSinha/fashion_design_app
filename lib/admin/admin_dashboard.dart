import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class AdminDashboardScreen extends StatefulWidget {
  const AdminDashboardScreen({super.key});

  @override
  State<AdminDashboardScreen> createState() => _AdminDashboardScreenState();
}

class _AdminDashboardScreenState extends State<AdminDashboardScreen> {
  // --- Color Palette ---
  final Color backgroundBg = const Color(0xFFF1F5F9);
  final Color cardBg = Colors.white;
  final Color textDark = const Color(0xFF0F172A);
  final Color textMuted = const Color(0xFF64748B);
  final Color trendGreen = const Color(0xFF10B981);

  // Stat Icon Colors
  final Color userBlue = const Color(0xFF0091FF);
  final Color designPurple = const Color(0xFFB512E0);
  final Color exportOrange = const Color(0xFFF97316);
  final Color revenueGreen = const Color(0xFF10B981);

  final Map<String, bool> _hoverStates = {};
  final _supabase = Supabase.instance.client;

  // 🔥 ১. লাইভ কানেকশন ধরে রাখার জন্য পারসিস্টেন্ট স্ট্রিম ভেরিয়েবল
  late final Stream<List<Map<String, dynamic>>> _usersStream;
  late final Stream<List<Map<String, dynamic>>> _designsStatsStream;
  late final Stream<List<Map<String, dynamic>>> _exportsStream;
  late final Stream<List<Map<String, dynamic>>> _revenueStream;
  late final Stream<List<Map<String, dynamic>>> _recentDesignsStream;

  @override
  void initState() {
    super.initState();
    // 🔥 ২. initState-এ স্ট্রিমগুলো ডিফাইন করায় বারবার রিলোড হওয়া বন্ধ হবে
    _usersStream = _supabase.from('consumers').stream(primaryKey: ['id']);
    _designsStatsStream = _supabase
        .from('dress_designs')
        .stream(primaryKey: ['id']);
    _exportsStream = _supabase.from('exports').stream(primaryKey: ['id']);
    _revenueStream = _supabase.from('revenue').stream(primaryKey: ['id']);

    _recentDesignsStream = _supabase
        .from('dress_designs')
        .stream(primaryKey: ['id'])
        .order('created_at', ascending: false)
        .limit(4);
  }

  // Relative Time Helper
  String _getRelativeTime(String? createdAtString) {
    if (createdAtString == null) return "Just now";
    final DateTime dateTime = DateTime.parse(createdAtString);
    final Duration diff = DateTime.now().difference(dateTime);

    if (diff.inMinutes < 60) return "${diff.inMinutes} minutes ago";
    if (diff.inHours < 24) return "${diff.inHours} hours ago";
    return "${diff.inDays} days ago";
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundBg,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 48.0, vertical: 36.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildTopHeader(),
              const SizedBox(height: 36),
              _buildStatCardsGrid(),
              const SizedBox(height: 36),
              LayoutBuilder(
                builder: (context, constraints) {
                  if (constraints.maxWidth > 1100) {
                    return Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(flex: 6, child: _buildRecentDesignsCard()),
                        const SizedBox(width: 32),
                        Expanded(
                          flex: 4,
                          child: Column(
                            children: [
                              _buildQuickActionsCard(),
                              const SizedBox(height: 32),
                              _buildSystemStatusCard(),
                            ],
                          ),
                        ),
                      ],
                    );
                  } else {
                    return Column(
                      children: [
                        _buildRecentDesignsCard(),
                        const SizedBox(height: 32),
                        _buildQuickActionsCard(),
                        const SizedBox(height: 32),
                        _buildSystemStatusCard(),
                      ],
                    );
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  // --- 1. Main Dashboard Header ---
  Widget _buildTopHeader() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Admin Dashboard',
                style: TextStyle(
                  color: textDark,
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  letterSpacing: -0.5,
                ),
              ),
              const SizedBox(height: 6),
              Text(
                'Welcome back, nafizhasansinha',
                style: TextStyle(color: textMuted, fontSize: 15),
              ),
            ],
          ),
        ),
        Row(
          children: [
            _buildHeaderIconButton(Icons.settings_outlined, 'header_settings'),
            const SizedBox(width: 16),
            _buildHeaderLogoutButton(),
          ],
        ),
      ],
    );
  }

  // --- 2. Live Stat Cards Section ---
  Widget _buildStatCardsGrid() {
    return LayoutBuilder(
      builder: (context, constraints) {
        double cardWidth = (constraints.maxWidth - (3 * 24)) / 4;
        if (constraints.maxWidth < 900) {
          cardWidth = (constraints.maxWidth - 24) / 2;
        }
        if (constraints.maxWidth < 550) cardWidth = constraints.maxWidth;

        return Wrap(
          spacing: 24,
          runSpacing: 24,
          children: [
            _buildLiveStatCard(
              title: 'Total Users',
              stream: _usersStream, // 🔥 প্রাক-সংজ্ঞায়িত স্ট্রিম পাস করা হচ্ছে
              icon: Icons.people_alt_outlined,
              themeColor: userBlue,
              cardWidth: cardWidth,
              id: 'card_users',
            ),
            _buildLiveStatCard(
              title: 'Designs Created',
              stream: _designsStatsStream,
              icon: Icons.layers_outlined,
              themeColor: designPurple,
              cardWidth: cardWidth,
              id: 'card_designs',
            ),
            _buildLiveStatCard(
              title: 'Exports',
              stream: _exportsStream,
              icon: Icons.vertical_align_bottom_sharp,
              themeColor: exportOrange,
              cardWidth: cardWidth,
              id: 'card_exports',
            ),
            _buildLiveStatCard(
              title: 'Revenue',
              stream: _revenueStream,
              icon: Icons.trending_up_rounded,
              themeColor: revenueGreen,
              cardWidth: cardWidth,
              id: 'card_revenue',
              isRevenue: true,
            ),
          ],
        );
      },
    );
  }

  Widget _buildLiveStatCard({
    required String title,
    required Stream<List<Map<String, dynamic>>> stream,
    required IconData icon,
    required Color themeColor,
    required double cardWidth,
    required String id,
    bool isRevenue = false,
  }) {
    return StreamBuilder<List<Map<String, dynamic>>>(
      stream: stream,
      builder: (context, snapshot) {
        String displayValue = '0';

        if (snapshot.hasData && snapshot.data != null) {
          if (isRevenue) {
            double total = 0;
            for (var row in snapshot.data!) {
              total += (row['amount'] ?? 0).toDouble();
            }
            displayValue = total >= 1000
                ? '\$${(total / 1000).toStringAsFixed(1)}K'
                : '\$${total.toStringAsFixed(2)}';
          } else {
            displayValue = snapshot.data!.length.toString();
          }
        } else if (snapshot.hasError) {
          displayValue = 'Error';
        }

        return _buildStatCard(
          title,
          displayValue,
          '+12.5%',
          icon,
          themeColor,
          cardWidth,
          id,
        );
      },
    );
  }

  Widget _buildStatCard(
    String title,
    String value,
    String percentage,
    IconData icon,
    Color themeColor,
    double width,
    String id,
  ) {
    return _buildHoverableWidget(
      id: id,
      builder: (isHovered) {
        return AnimatedContainer(
          duration: const Duration(milliseconds: 250),
          curve: Curves.easeOutCubic,
          width: width,
          padding: const EdgeInsets.all(24),
          transform: isHovered
              ? (Matrix4.identity()..translate(0, -8, 0))
              : Matrix4.identity(),
          decoration: BoxDecoration(
            color: cardBg,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: isHovered
                    ? themeColor.withValues(alpha: 0.25)
                    : Colors.black.withValues(alpha: 0.03),
                blurRadius: isHovered ? 24 : 12,
                offset: isHovered ? const Offset(0, 8) : const Offset(0, 4),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: isHovered
                          ? themeColor
                          : themeColor.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Icon(
                      icon,
                      color: isHovered ? Colors.white : themeColor,
                      size: 24,
                    ),
                  ),
                  Text(
                    percentage,
                    style: TextStyle(
                      color: trendGreen,
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              Text(
                title,
                style: TextStyle(
                  color: textMuted,
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 6),
              Text(
                value,
                style: TextStyle(
                  color: textDark,
                  fontSize: 26,
                  fontWeight: FontWeight.bold,
                  letterSpacing: -0.5,
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  // --- 3. Live Recent Designs List ---
  Widget _buildRecentDesignsCard() {
    return Container(
      padding: const EdgeInsets.all(28),
      decoration: BoxDecoration(
        color: cardBg,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.02),
            blurRadius: 16,
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Recent Designs',
                style: TextStyle(
                  color: textDark,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              InkWell(
                onTap: () {},
                child: Text(
                  'View All',
                  style: TextStyle(
                    color: textMuted,
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),

          StreamBuilder<List<Map<String, dynamic>>>(
            stream: _recentDesignsStream, // 🔥 পারসিস্টেন্ট স্ট্রিম
            builder: (context, snapshot) {
              // 🔥 ৩. স্মার্ট চেকিং: কানেকশন ওয়েটিং কিন্তু কোনো ডাটা ক্যাশে নাই, শুধু তখনই লোডার দেখাবে।
              // একবার ডাটা চলে আসলে ব্যাকগ্রাউন্ড আপডেটের সময় কোনো লোডার দেখাবে না।
              if (snapshot.connectionState == ConnectionState.waiting &&
                  !snapshot.hasData) {
                return const Center(
                  child: Padding(
                    padding: EdgeInsets.all(20.0),
                    child: CircularProgressIndicator(),
                  ),
                );
              }

              if (!snapshot.hasData || snapshot.data!.isEmpty) {
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 30),
                  child: Center(
                    child: Text(
                      'No designs created yet.',
                      style: TextStyle(color: textMuted),
                    ),
                  ),
                );
              }

              final list = snapshot.data!;

              return Column(
                children: list.map((row) {
                  final String title = row['title'] ?? 'Untitled Design';
                  final String author = row['created_by'] ?? 'Unknown Client';
                  final String status = row['status'] ?? 'Completed';
                  final String? createdAt = row['created_at'];

                  Color tagBg = const Color(0xFFDBEAFE);
                  Color tagText = const Color(0xFF1D4ED8);
                  if (status == 'Exported') {
                    tagBg = const Color(0xFFDCFCE7);
                    tagText = const Color(0xFF15803D);
                  } else if (status == 'In Review') {
                    tagBg = const Color(0xFFFEF9C3);
                    tagText = const Color(0xFF854D0E);
                  }

                  final String initials = title.isNotEmpty
                      ? title.substring(0, 2).toUpperCase()
                      : 'DS';

                  return _buildRecentDesignRow(
                    initials,
                    title,
                    'by $author',
                    status,
                    tagBg,
                    tagText,
                    _getRelativeTime(createdAt),
                    'row_design_${row['id']}',
                  );
                }).toList(),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildRecentDesignRow(
    String avatarText,
    String title,
    String author,
    String status,
    Color tagBg,
    Color tagText,
    String time,
    String id,
  ) {
    return _buildHoverableWidget(
      id: id,
      builder: (isHovered) {
        return AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 12),
          margin: const EdgeInsets.only(bottom: 8),
          transform: isHovered
              ? (Matrix4.identity()..translate(8, 0, 0))
              : Matrix4.identity(),
          decoration: BoxDecoration(
            color: isHovered
                ? backgroundBg.withValues(alpha: 0.5)
                : Colors.transparent,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Row(
            children: [
              CircleAvatar(
                radius: 22,
                backgroundColor: const Color(0xFF6366F1),
                child: Text(
                  avatarText,
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                  ),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        color: textDark,
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      author,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(color: textMuted, fontSize: 13),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 12),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: tagBg,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      status,
                      style: TextStyle(
                        color: tagText,
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(time, style: TextStyle(color: textMuted, fontSize: 12)),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  // --- 4. Quick Actions Section ---
  Widget _buildQuickActionsCard() {
    return Container(
      padding: const EdgeInsets.all(28),
      decoration: BoxDecoration(
        color: cardBg,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.02),
            blurRadius: 16,
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Quick Actions',
            style: TextStyle(
              color: textDark,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 24),
          _buildQuickActionItem(
            Icons.person_search_outlined,
            'Manage Users',
            'qa_manage',
          ),
          _buildQuickActionItem(
            Icons.bar_chart_outlined,
            'View Analytics',
            'qa_analytics',
          ),
          _buildQuickActionItem(
            Icons.description_outlined,
            'Generate Report',
            'qa_report',
          ),
          _buildQuickActionItem(
            Icons.settings_suggest_outlined,
            'System Settings',
            'qa_settings',
          ),
        ],
      ),
    );
  }

  Widget _buildQuickActionItem(IconData icon, String title, String id) {
    return _buildHoverableWidget(
      id: id,
      builder: (isHovered) {
        return AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          margin: const EdgeInsets.only(bottom: 12),
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
          decoration: BoxDecoration(
            color: isHovered ? const Color(0xFFF8FAFC) : Colors.transparent,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: isHovered ? textDark : const Color(0xFFE2E8F0),
              width: isHovered ? 1.5 : 1,
            ),
            boxShadow: isHovered
                ? [
                    BoxShadow(
                      color: textDark.withValues(alpha: 0.05),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                  ]
                : [],
          ),
          child: Row(
            children: [
              Icon(icon, color: textDark, size: 20),
              const SizedBox(width: 14),
              Expanded(
                child: Text(
                  title,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    color: textDark,
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              AnimatedOpacity(
                opacity: isHovered ? 1.0 : 0.0,
                duration: const Duration(milliseconds: 150),
                child: Icon(
                  Icons.arrow_forward_ios_rounded,
                  color: textDark,
                  size: 14,
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  // --- 5. System Status Card ---
  Widget _buildSystemStatusCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(28),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        gradient: const LinearGradient(
          begin: Alignment.bottomLeft,
          end: Alignment.topRight,
          colors: [Color(0xFF4F46E5), Color(0xFF3B82F6)],
        ),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF4F46E5).withValues(alpha: 0.2),
            blurRadius: 16,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'System Status',
            style: TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            'All systems operational',
            style: TextStyle(
              color: Colors.white.withValues(alpha: 0.7),
              fontSize: 13,
            ),
          ),
          const SizedBox(height: 24),
          _buildStatusRow('API Server'),
          const SizedBox(height: 12),
          _buildStatusRow('Database'),
          const SizedBox(height: 12),
          _buildStatusRow('AI Service'),
          const SizedBox(height: 12),
          _buildStatusRow('Storage'),
        ],
      ),
    );
  }

  Widget _buildStatusRow(String name) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          name,
          style: TextStyle(
            color: Colors.white.withValues(alpha: 0.9),
            fontSize: 14,
            fontWeight: FontWeight.w500,
          ),
        ),
        Row(
          children: [
            Container(
              width: 6,
              height: 6,
              decoration: const BoxDecoration(
                color: Color(0xFF10B981),
                shape: BoxShape.circle,
              ),
            ),
            const SizedBox(width: 6),
            const Text(
              'Online',
              style: TextStyle(
                color: Color(0xFF10B981),
                fontSize: 14,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ],
    );
  }

  // --- 6. Extra Utility Buttons ---
  Widget _buildHeaderIconButton(IconData icon, String id) {
    return _buildHoverableWidget(
      id: id,
      builder: (isHovered) {
        return AnimatedContainer(
          duration: const Duration(milliseconds: 150),
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: isHovered ? Colors.white : Colors.transparent,
            borderRadius: BorderRadius.circular(10),
            border: Border.all(
              color: isHovered ? const Color(0xFFCBD5E1) : Colors.transparent,
            ),
          ),
          child: Icon(icon, color: textDark, size: 22),
        );
      },
    );
  }

  Widget _buildHeaderLogoutButton() {
    return _buildHoverableWidget(
      id: 'btn_logout',
      builder: (isHovered) {
        return AnimatedContainer(
          duration: const Duration(milliseconds: 150),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          decoration: BoxDecoration(
            color: isHovered ? textDark : Colors.white,
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: const Color(0xFFE2E8F0)),
          ),
          child: Row(
            children: [
              Icon(
                Icons.logout_rounded,
                color: isHovered ? Colors.white : textDark,
                size: 18,
              ),
              const SizedBox(width: 8),
              Text(
                'Logout',
                style: TextStyle(
                  color: isHovered ? Colors.white : textDark,
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildHoverableWidget({
    required String id,
    required Widget Function(bool isHovered) builder,
  }) {
    return MouseRegion(
      onEnter: (_) => setState(() => _hoverStates[id] = true),
      onExit: (_) => setState(() => _hoverStates[id] = false),
      child: builder(_hoverStates[id] ?? false),
    );
  }
}
