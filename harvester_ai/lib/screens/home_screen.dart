import 'package:flutter/material.dart';
import 'dart:ui';
import 'package:firebase_auth/firebase_auth.dart';
import '../services/firestore_service.dart';
import '../models/user_model.dart';
import '../models/recommendation_model.dart';
import '../models/weather_alert_model.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedNavIndex = 0;
  UserModel? _user;

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    try {
      final currentUser = FirebaseAuth.instance.currentUser;
      if (currentUser != null) {
        final userModel = await FirestoreService().getUser(currentUser.uid);
        setState(() {
          _user = userModel;
        });
      }
    } catch (e) {
      // Silently handle error - user can still use app
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  const Color(0xCC8BBD6C).withValues(alpha: 0.8),
                  const Color(0x99556B2F).withValues(alpha: 0.8),
                ],
              ),
            ),
          ),
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  const Color(0x00000000),
                  const Color(0x1A000000),
                  const Color(0x4D000000),
                  const Color(0xCC000000),
                ],
                stops: const [0.0, 0.3, 0.6, 1.0],
              ),
            ),
          ),
          if (_selectedNavIndex == 0)
            _HomeTabContent(user: _user)
          else if (_selectedNavIndex == 1)
            _DiscoverTabContent(user: _user)
          else if (_selectedNavIndex == 2)
            _PlanTabContent(user: _user)
          else if (_selectedNavIndex == 3)
            _AlertsTabContent(user: _user)
          else
            _MeTabContent(user: _user),
        ],
      ),
      bottomNavigationBar: _BottomNavBar(
        selectedIndex: _selectedNavIndex,
        onTap: (index) {
          setState(() => _selectedNavIndex = index);
        },
      ),
    );
  }
}

// ============= TAB: HOME =============
class _HomeTabContent extends StatelessWidget {
  final UserModel? user;
  const _HomeTabContent({required this.user});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SingleChildScrollView(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 600),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Column(
                children: [
                  const SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Text(
                                'Morning ${user?.name ?? 'Farm Owner'} ',
                                style: const TextStyle(
                                  fontSize: 24,
                                  fontWeight: FontWeight.w700,
                                  color: Colors.white,
                                ),
                              ),
                              const Text('✨', style: TextStyle(fontSize: 24)),
                            ],
                          ),
                          const SizedBox(height: 4),
                          Text(
                            user?.location ?? 'Western Cape, 22°C',
                            style: const TextStyle(
                              fontSize: 14,
                              color: Color(0xFF1DC578),
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                      ClipRRect(
                        borderRadius: BorderRadius.circular(12),
                        child: BackdropFilter(
                          filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                            decoration: BoxDecoration(
                              color: Colors.white.withValues(alpha: 0.1),
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(color: Colors.white.withValues(alpha: 0.2)),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                const Icon(Icons.check_circle, color: Color(0xFF22C55E), size: 14),
                                const SizedBox(width: 6),
                                Text(
                                  'Online',
                                  style: TextStyle(fontSize: 12, color: Colors.white.withValues(alpha: 0.7)),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),
                  _TopRecommendationCard(
                    recommendation: RecommendationModel(
                      cropName: 'Pinotage',
                      matchPercentage: 92,
                      yieldIncrease: 28,
                      profitIncrease: 142000,
                      reason: 'Perfect soil and climate match',
                    ),
                  ),
                  const SizedBox(height: 32),
                  const Align(
                    alignment: Alignment.centerLeft,
                    child: Text('Your Crops', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600, color: Colors.white)),
                  ),
                  const SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      _CropYieldCard(name: 'Chenin\nBlanc', yieldValue: 0.65),
                      _CropYieldCard(name: 'Cabernet\nSauvignon', yieldValue: 0.45),
                      _CropYieldCard(name: 'Vegetables', yieldValue: 0.80),
                    ],
                  ),
                  const SizedBox(height: 32),
                  _WeatherAlertCard(
                    alert: WeatherAlertModel(
                      alertType: 'Heat Wave',
                      description: 'High temperatures expected in the next 9 days',
                      severity: 'High',
                      daysUntil: 9,
                    ),
                  ),
                  const SizedBox(height: 120),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

// ============= TAB: DISCOVER =============
class _DiscoverTabContent extends StatelessWidget {
  final UserModel? user;
  const _DiscoverTabContent({required this.user});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SingleChildScrollView(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 600),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Discover New Crops', style: TextStyle(fontSize: 28, fontWeight: FontWeight.w700, color: Colors.white)),
                  const SizedBox(height: 24),
                  _DiscoverCard(
                    icon: '🍇',
                    name: 'Merlot Grapes',
                    match: 88,
                    yield: '+35%',
                    info: 'Premium wine variety\nHigh demand market',
                  ),
                  const SizedBox(height: 12),
                  _DiscoverCard(
                    icon: '🍏',
                    name: 'Honeycrisp Apples',
                    match: 79,
                    yield: '+22%',
                    info: 'Sweet & crispy\nExport grade quality',
                  ),
                  const SizedBox(height: 12),
                  _DiscoverCard(
                    icon: '🫒',
                    name: 'Olive Trees',
                    match: 85,
                    yield: '+18%',
                    info: 'Oil production\nLow maintenance crop',
                  ),
                  const SizedBox(height: 12),
                  _DiscoverCard(
                    icon: '🥕',
                    name: 'Heritage Carrots',
                    match: 92,
                    yield: '+40%',
                    info: 'Organic certified\nPremium pricing',
                  ),
                  const SizedBox(height: 120),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

// ============= TAB: PLAN =============
class _PlanTabContent extends StatelessWidget {
  final UserModel? user;
  const _PlanTabContent({required this.user});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SingleChildScrollView(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 600),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Crop Schedule', style: TextStyle(fontSize: 28, fontWeight: FontWeight.w700, color: Colors.white)),
                  const SizedBox(height: 24),
                  _ScheduleCard(
                    month: 'April',
                    crops: ['Plant Pinotage', 'Prepare irrigation', 'Soil testing'],
                    stage: 'Preparation',
                  ),
                  const SizedBox(height: 12),
                  _ScheduleCard(
                    month: 'May - June',
                    crops: ['Growth monitoring', 'Pest management', 'Pruning'],
                    stage: 'Growing',
                  ),
                  const SizedBox(height: 12),
                  _ScheduleCard(
                    month: 'July - August',
                    crops: ['Flowering phase', 'Nutrient boost', 'Weather watch'],
                    stage: 'Blooming',
                  ),
                  const SizedBox(height: 12),
                  _ScheduleCard(
                    month: 'September',
                    crops: ['Harvest preparation', 'Equipment check', 'Labor planning'],
                    stage: 'Pre-Harvest',
                  ),
                  const SizedBox(height: 120),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

// ============= TAB: ALERTS =============
class _AlertsTabContent extends StatelessWidget {
  final UserModel? user;
  const _AlertsTabContent({required this.user});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SingleChildScrollView(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 600),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Active Alerts', style: TextStyle(fontSize: 28, fontWeight: FontWeight.w700, color: Colors.white)),
                  const SizedBox(height: 24),
                  _AlertTile(icon: '🌡️', type: 'Temperature', message: 'High heat expected (35°C)', severity: 'Critical'),
                  const SizedBox(height: 12),
                  _AlertTile(icon: '🐛', type: 'Pest Alert', message: 'Whitefly detected on Chenin Blanc', severity: 'High'),
                  const SizedBox(height: 12),
                  _AlertTile(icon: '💧', type: 'Water Level', message: 'Irrigation recommended tomorrow', severity: 'Medium'),
                  const SizedBox(height: 12),
                  _AlertTile(icon: '📊', type: 'Soil pH', message: 'pH level optimal (6.8)', severity: 'Good'),
                  const SizedBox(height: 12),
                  _AlertTile(icon: '☁️', type: 'Rain Forecast', message: '60% chance of rain Friday', severity: 'Info'),
                  const SizedBox(height: 120),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

// ============= TAB: ME =============
class _MeTabContent extends StatelessWidget {
  final UserModel? user;
  const _MeTabContent({required this.user});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SingleChildScrollView(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 600),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Profile', style: TextStyle(fontSize: 28, fontWeight: FontWeight.w700, color: Colors.white)),
                  const SizedBox(height: 24),
                  Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: Colors.white.withValues(alpha: 0.2)),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(user?.name ?? 'Farm Owner', style: const TextStyle(fontSize: 24, fontWeight: FontWeight.w700, color: Colors.white)),
                        const SizedBox(height: 12),
                        Text('📍 ${user?.location ?? 'Stellenbosch, Western Cape'}', style: TextStyle(fontSize: 14, color: Colors.white.withValues(alpha: 0.8))),
                        const SizedBox(height: 8),
                        Text('📧 ${user?.email ?? 'email@farm.com'}', style: TextStyle(fontSize: 14, color: Colors.white.withValues(alpha: 0.8))),
                        const SizedBox(height: 8),
                        Text('🏞️ Land: ${user?.landSize?.toStringAsFixed(1) ?? '15'} hectares', style: TextStyle(fontSize: 14, color: Colors.white.withValues(alpha: 0.8))),
                        const SizedBox(height: 8),
                        Text('🌱 Soil: ${user?.soilType ?? 'Clay Loam'}', style: TextStyle(fontSize: 14, color: Colors.white.withValues(alpha: 0.8))),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),
                  _SettingsTile(icon: Icons.settings_rounded, title: 'Settings', subtitle: 'App preferences'),
                  const SizedBox(height: 12),
                  _SettingsTile(icon: Icons.help_rounded, title: 'Help & Support', subtitle: 'Get assistance'),
                  const SizedBox(height: 12),
                  _SettingsTile(icon: Icons.logout_rounded, title: 'Log Out', subtitle: 'Sign out from account'),
                  const SizedBox(height: 120),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

// ============= COMPONENT WIDGETS =============

class _DiscoverCard extends StatelessWidget {
  final String icon, name, info;
  final int match;
  final String yield;

  const _DiscoverCard({
    required this.icon,
    required this.name,
    required this.match,
    required this.yield,
    required this.info,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.white.withValues(alpha: 0.2)),
      ),
      child: Row(
        children: [
          Text(icon, style: const TextStyle(fontSize: 32)),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(name, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: Colors.white)),
                Text(info, style: TextStyle(fontSize: 12, color: Colors.white.withValues(alpha: 0.6)), maxLines: 2),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: const Color(0xFF1DC578).withValues(alpha: 0.3),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text('$match%', style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: Color(0xFF1DC578))),
              ),
              Text(yield, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w700, color: Colors.white)),
            ],
          ),
        ],
      ),
    );
  }
}

class _ScheduleCard extends StatelessWidget {
  final String month, stage;
  final List<String> crops;

  const _ScheduleCard({
    required this.month,
    required this.crops,
    required this.stage,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.white.withValues(alpha: 0.2)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(month, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: Colors.white)),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: const Color(0xFF1DC578).withValues(alpha: 0.3),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(stage, style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: Color(0xFF1DC578))),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: crops.map((crop) => Padding(
              padding: const EdgeInsets.only(bottom: 6),
              child: Text('✓ $crop', style: TextStyle(fontSize: 12, color: Colors.white.withValues(alpha: 0.7))),
            )).toList(),
          ),
        ],
      ),
    );
  }
}

class _AlertTile extends StatelessWidget {
  final String icon, type, message, severity;

  const _AlertTile({
    required this.icon,
    required this.type,
    required this.message,
    required this.severity,
  });

  @override
  Widget build(BuildContext context) {
    final color = severity == 'Critical' ? Colors.red : severity == 'High' ? Colors.orange : severity == 'Good' ? const Color(0xFF1DC578) : Colors.blue;

    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withValues(alpha: 0.3)),
      ),
      child: Row(
        children: [
          Text(icon, style: const TextStyle(fontSize: 24)),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(type, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: Colors.white)),
                Text(message, style: TextStyle(fontSize: 12, color: Colors.white.withValues(alpha: 0.7))),
              ],
            ),
          ),
          Text(severity, style: TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: color)),
        ],
      ),
    );
  }
}

class _SettingsTile extends StatelessWidget {
  final IconData icon;
  final String title, subtitle;

  const _SettingsTile({
    required this.icon,
    required this.title,
    required this.subtitle,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.white.withValues(alpha: 0.2)),
      ),
      child: Row(
        children: [
          Icon(icon, color: const Color(0xFF1DC578), size: 24),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: Colors.white)),
                Text(subtitle, style: TextStyle(fontSize: 12, color: Colors.white.withValues(alpha: 0.6))),
              ],
            ),
          ),
          Icon(Icons.arrow_forward_rounded, color: Colors.white.withValues(alpha: 0.4), size: 20),
        ],
      ),
    );
  }
}

class _TopRecommendationCard extends StatelessWidget {
  final RecommendationModel recommendation;

  const _TopRecommendationCard({
    required this.recommendation,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            const Color(0xFF1DC578).withValues(alpha: 0.9),
            const Color(0xFF0F6B4D).withValues(alpha: 0.7),
          ],
        ),
      ),
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Your top\nrecommendation\nthis season: ${recommendation.cropName}',
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w700,
                        color: Colors.white,
                        height: 1.3,
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 8,
                ),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: Colors.white.withValues(alpha: 0.3),
                  ),
                ),
                child: Column(
                  children: [
                    Text(
                      '${recommendation.matchPercentage}%',
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                        color: Colors.white,
                      ),
                    ),
                    const Text(
                      'match',
                      style: TextStyle(
                        fontSize: 10,
                        color: Colors.white,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          Row(
            children: [
              Expanded(
                child: _StatPill(
                  icon: '📈',
                  label: '+${recommendation.yieldIncrease}% yield',
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _StatPill(
                  icon: '💰',
                  label: 'R${(recommendation.profitIncrease / 1000).toStringAsFixed(0)}k profit',
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _StatPill extends StatelessWidget {
  final String icon;
  final String label;

  const _StatPill({
    required this.icon,
    required this.label,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: Colors.white.withValues(alpha: 0.2),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            icon,
            style: const TextStyle(fontSize: 16),
          ),
          const SizedBox(width: 6),
          Text(
            label,
            style: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: Colors.white,
            ),
          ),
        ],
      ),
    );
  }
}

class _CropYieldCard extends StatelessWidget {
  final String name;
  final double yieldValue;

  const _CropYieldCard({
    required this.name,
    required this.yieldValue,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: Colors.white.withValues(alpha: 0.2),
          ),
          color: Colors.white.withValues(alpha: 0.05),
        ),
        padding: const EdgeInsets.all(12),
        child: Column(
          children: [
            Text(
              name,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: Colors.white,
                height: 1.4,
              ),
            ),
            const SizedBox(height: 12),
            SizedBox(
              height: 60,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Container(
                    width: 6,
                    height: 60 * yieldValue,
                    decoration: BoxDecoration(
                      color: const Color(0xFF1DC578),
                      borderRadius: BorderRadius.circular(3),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  '1w',
                  style: TextStyle(
                    fontSize: 10,
                    color: Colors.white.withValues(alpha: 0.5),
                  ),
                ),
                const SizedBox(width: 4),
                Text(
                  'Mo',
                  style: TextStyle(
                    fontSize: 10,
                    color: Colors.white.withValues(alpha: 0.5),
                  ),
                ),
                const SizedBox(width: 4),
                Text(
                  '2tb',
                  style: TextStyle(
                    fontSize: 10,
                    color: Colors.white.withValues(alpha: 0.5),
                  ),
                ),
                const SizedBox(width: 4),
                Text(
                  'Yiele',
                  style: TextStyle(
                    fontSize: 10,
                    color: Colors.white.withValues(alpha: 0.5),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _WeatherAlertCard extends StatelessWidget {
  final WeatherAlertModel alert;

  const _WeatherAlertCard({
    required this.alert,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        color: const Color(0xFFEAB308).withValues(alpha: 0.15),
        border: Border.all(
          color: const Color(0xFFEAB308).withValues(alpha: 0.3),
        ),
      ),
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          const Text(
            '☀️',
            style: TextStyle(fontSize: 24),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '${alert.alertType} expected in ${alert.daysUntil} days',
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  alert.description,
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.white.withValues(alpha: 0.6),
                  ),
                ),
              ],
            ),
          ),
          Icon(
            Icons.arrow_forward_rounded,
            color: Colors.white.withValues(alpha: 0.6),
            size: 20,
          ),
        ],
      ),
    );
  }
}

class _BottomNavBar extends StatelessWidget {
  final int selectedIndex;
  final Function(int) onTap;

  const _BottomNavBar({
    required this.selectedIndex,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final navItems = [
      ('Home', Icons.home_rounded),
      ('Discover', Icons.auto_awesome_rounded),
      ('Plan', Icons.calendar_today_rounded),
      ('Alerts', Icons.notifications_rounded),
      ('Me', Icons.person_rounded),
    ];

    return Container(
      decoration: BoxDecoration(
        border: Border(
          top: BorderSide(
            color: Colors.white.withValues(alpha: 0.1),
          ),
        ),
        color: const Color(0xFF0A1F15).withValues(alpha: 0.8),
      ),
      child: SafeArea(
        top: false,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 12),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: List.generate(
              navItems.length,
              (index) {
                final isSelected = index == selectedIndex;
                return GestureDetector(
                  onTap: () => onTap(index),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        navItems[index].$2,
                        color: isSelected
                            ? const Color(0xFF1DC578)
                            : Colors.white.withValues(alpha: 0.5),
                        size: 24,
                      ),
                      const SizedBox(height: 4),
                      Text(
                        navItems[index].$1,
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w500,
                          color: isSelected
                              ? const Color(0xFF1DC578)
                              : Colors.white.withValues(alpha: 0.5),
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}
