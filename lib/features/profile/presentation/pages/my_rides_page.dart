import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../app/router/routes.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/widgets/app_bottom_nav_bar.dart';

class MyRidesPage extends StatefulWidget {
  const MyRidesPage({super.key});

  @override
  State<MyRidesPage> createState() => _MyRidesPageState();
}

class _MyRidesPageState extends State<MyRidesPage> {
  int _activeFilter = 0; // 0: الكل, 1: مكتملة, 2: ملغاة

  final List<Map<String, dynamic>> _rides = [
    {
      'id': 'SC-1024',
      'date': '7 أكتوبر 2026',
      'duration': '10 دقيقة',
      'distance': '3.4 كم',
      'cost': '30 جنيه',
      'status': 'مكتملة',
      'isCompleted': true,
    },
    {
      'id': 'SC-1024',
      'date': '7 أكتوبر 2026',
      'duration': '12 دقيقة',
      'distance': '3.4 كم',
      'cost': '31 جنيه',
      'status': 'مكتملة',
      'isCompleted': true,
    },
    {
      'id': 'SC-1024',
      'date': '7 أكتوبر 2026',
      'duration': '10 دقيقة',
      'distance': '3.4 كم',
      'cost': '30 جنيه',
      'status': 'مكتملة',
      'isCompleted': true,
    },
    {
      'id': 'SC-1024',
      'date': '7 أكتوبر 2026',
      'duration': '10 دقيقة',
      'distance': '3.4 كم',
      'cost': '31 جنيه',
      'status': 'مكتملة',
      'isCompleted': true,
    },
  ];

  @override
  Widget build(BuildContext context) {
    final sh = MediaQuery.sizeOf(context).height;

    final filteredRides = _rides.where((r) {
      if (_activeFilter == 1) return r['isCompleted'] == true;
      if (_activeFilter == 2) return r['isCompleted'] == false;
      return true;
    }).toList();

    return Scaffold(
      backgroundColor: AppColors.background,
      bottomNavigationBar: const AppBottomNavBar(currentIndex: 1),
      body: SafeArea(
        child: Column(
          children: [
            // Top Bar
            Padding(
              padding: EdgeInsets.symmetric(
                horizontal: sh * 0.024,
                vertical: sh * 0.012,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  GestureDetector(
                    onTap: () {
                      if (context.canPop()) {
                        context.pop();
                      } else {
                        context.go(AppRoutes.home);
                      }
                    },
                    child: Container(
                      width: sh * 0.048,
                      height: sh * 0.048,
                      decoration: BoxDecoration(
                        color: const Color(0xFF132225),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: AppColors.border, width: 1),
                      ),
                      child: Icon(
                        Icons.chevron_left_rounded,
                        color: AppColors.textPrimary,
                        size: sh * 0.028,
                      ),
                    ),
                  ),
                  Text(
                    'رحلاتي',
                    style: TextStyle(
                      fontFamily: 'Cairo',
                      fontSize: sh * 0.024,
                      fontWeight: FontWeight.w800,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  SizedBox(width: sh * 0.048),
                ],
              ),
            ),

            // Filter Tabs Row
            Padding(
              padding: EdgeInsets.symmetric(
                horizontal: sh * 0.024,
                vertical: sh * 0.010,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  _FilterTab(
                    label: 'ملغاة',
                    isActive: _activeFilter == 2,
                    onTap: () => setState(() => _activeFilter = 2),
                    sh: sh,
                  ),
                  const SizedBox(width: 8),
                  _FilterTab(
                    label: 'مكتملة',
                    isActive: _activeFilter == 1,
                    onTap: () => setState(() => _activeFilter = 1),
                    sh: sh,
                  ),
                  const SizedBox(width: 8),
                  _FilterTab(
                    label: 'الكل',
                    isActive: _activeFilter == 0,
                    onTap: () => setState(() => _activeFilter = 0),
                    sh: sh,
                  ),
                ],
              ),
            ),

            // Rides List
            Expanded(
              child: ListView.builder(
                padding: EdgeInsets.symmetric(horizontal: sh * 0.024),
                physics: const BouncingScrollPhysics(),
                itemCount: filteredRides.length,
                itemBuilder: (context, index) {
                  final ride = filteredRides[index];

                  return Container(
                    margin: const EdgeInsets.only(bottom: 12),
                    padding: EdgeInsets.all(sh * 0.018),
                    decoration: BoxDecoration(
                      color: const Color(0xFF132225),
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: AppColors.border),
                    ),
                    child: Row(
                      children: [
                        // Scooter Mini Preview
                        Container(
                          width: sh * 0.065,
                          height: sh * 0.065,
                          decoration: BoxDecoration(
                            color: const Color(0xFF192D31),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Icon(
                            Icons.electric_scooter_rounded,
                            color: AppColors.primary,
                            size: sh * 0.040,
                          ),
                        ),
                        SizedBox(width: sh * 0.016),

                        // Center Ride Stats
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  // Status Badge
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 10,
                                      vertical: 3,
                                    ),
                                    decoration: BoxDecoration(
                                      color: AppColors.primary.withAlpha(25),
                                      borderRadius: BorderRadius.circular(8),
                                      border: Border.all(
                                        color: AppColors.primary.withAlpha(80),
                                      ),
                                    ),
                                    child: Text(
                                      ride['status'] as String,
                                      style: TextStyle(
                                        fontFamily: 'Cairo',
                                        fontSize: sh * 0.013,
                                        fontWeight: FontWeight.w700,
                                        color: AppColors.primary,
                                      ),
                                    ),
                                  ),
                                  Text(
                                    ride['id'] as String,
                                    style: TextStyle(
                                      fontFamily: 'Cairo',
                                      fontSize: sh * 0.018,
                                      fontWeight: FontWeight.w700,
                                      color: AppColors.textPrimary,
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(height: sh * 0.004),
                              Text(
                                ride['date'] as String,
                                style: TextStyle(
                                  fontFamily: 'Cairo',
                                  fontSize: sh * 0.014,
                                  color: AppColors.textSecondary,
                                ),
                              ),
                              SizedBox(height: sh * 0.008),

                              // Duration & Distance & Price Row
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    ride['cost'] as String,
                                    style: TextStyle(
                                      fontFamily: 'Cairo',
                                      fontSize: sh * 0.018,
                                      fontWeight: FontWeight.w800,
                                      color: AppColors.primary,
                                    ),
                                  ),
                                  Row(
                                    children: [
                                      Text(
                                        ride['distance'] as String,
                                        style: TextStyle(
                                          fontFamily: 'Cairo',
                                          fontSize: sh * 0.014,
                                          color: AppColors.textSecondary,
                                        ),
                                      ),
                                      const SizedBox(width: 6),
                                      const Icon(
                                        Icons.route_rounded,
                                        size: 15,
                                        color: AppColors.textSecondary,
                                      ),
                                      const SizedBox(width: 14),
                                      Text(
                                        ride['duration'] as String,
                                        style: TextStyle(
                                          fontFamily: 'Cairo',
                                          fontSize: sh * 0.014,
                                          color: AppColors.textSecondary,
                                        ),
                                      ),
                                      const SizedBox(width: 6),
                                      const Icon(
                                        Icons.access_time_rounded,
                                        size: 15,
                                        color: AppColors.textSecondary,
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _FilterTab extends StatelessWidget {
  const _FilterTab({
    required this.label,
    required this.isActive,
    required this.onTap,
    required this.sh,
  });

  final String label;
  final bool isActive;
  final VoidCallback onTap;
  final double sh;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: EdgeInsets.symmetric(
          horizontal: sh * 0.024,
          vertical: sh * 0.008,
        ),
        decoration: BoxDecoration(
          color: isActive ? AppColors.primary : const Color(0xFF132225),
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            color: isActive ? AppColors.primary : AppColors.border,
          ),
        ),
        child: Text(
          label,
          style: TextStyle(
            fontFamily: 'Cairo',
            fontSize: sh * 0.015,
            fontWeight: FontWeight.w700,
            color: isActive ? AppColors.textOnPrimary : AppColors.textSecondary,
          ),
        ),
      ),
    );
  }
}

