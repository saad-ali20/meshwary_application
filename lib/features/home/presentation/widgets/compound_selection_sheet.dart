import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/models/compound.dart';
import '../../../../core/theme/app_colors.dart';
import '../cubit/compound_cubit.dart';

/// Modal bottom sheet allowing riders to view and select an active compound.
class CompoundSelectionSheet extends StatefulWidget {
  const CompoundSelectionSheet({
    super.key,
    this.currentCompound,
  });

  final Compound? currentCompound;

  static Future<Compound?> show(
    BuildContext context, {
    Compound? currentCompound,
  }) {
    return showModalBottomSheet<Compound>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => CompoundSelectionSheet(currentCompound: currentCompound),
    );
  }

  @override
  State<CompoundSelectionSheet> createState() => _CompoundSelectionSheetState();
}

class _CompoundSelectionSheetState extends State<CompoundSelectionSheet> {
  final TextEditingController _searchController = TextEditingController();
  List<Compound> _allCompounds = [];
  List<Compound> _filteredCompounds = [];
  bool _isLoading = true;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _fetchCompounds();
    _searchController.addListener(_onSearchChanged);
  }

  @override
  void dispose() {
    _searchController.removeListener(_onSearchChanged);
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _fetchCompounds() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final compounds = await context.read<CompoundCubit>().loadAvailableCompounds();
      if (!mounted) return;
      setState(() {
        _allCompounds = compounds;
        _filteredCompounds = compounds;
        _isLoading = false;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _isLoading = false;
        _errorMessage = 'تعذر تحميل قائمة المجمعات. يرجى المحاولة مجدداً.';
      });
    }
  }

  void _onSearchChanged() {
    final query = _searchController.text.trim().toLowerCase();
    setState(() {
      if (query.isEmpty) {
        _filteredCompounds = _allCompounds;
      } else {
        _filteredCompounds = _allCompounds
            .where((c) => c.name.toLowerCase().contains(query))
            .toList();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final sh = MediaQuery.sizeOf(context).height;
    final bottomInset = MediaQuery.viewInsetsOf(context).bottom;

    return Container(
      constraints: BoxConstraints(maxHeight: sh * 0.75),
      decoration: const BoxDecoration(
        color: Color(0xFF0D1B1E),
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
        border: Border(
          top: BorderSide(color: Color(0xFF1E3A40), width: 1.5),
        ),
      ),
      padding: EdgeInsets.only(bottom: bottomInset),
      child: SafeArea(
        top: false,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Handle bar
            Center(
              child: Container(
                margin: const EdgeInsets.only(top: 12, bottom: 8),
                width: 48,
                height: 5,
                decoration: BoxDecoration(
                  color: const Color(0xFF2A4850),
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),

            // Header title & close
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
              child: Row(
                children: [
                  const Icon(
                    Icons.location_city_rounded,
                    color: AppColors.primary,
                    size: 26,
                  ),
                  const SizedBox(width: 10),
                  const Expanded(
                    child: Text(
                      'اختر المجمع السكني (Compound)',
                      style: TextStyle(
                        fontFamily: 'Cairo',
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.close_rounded, color: Colors.white70),
                    onPressed: () => Navigator.of(context).pop(),
                  ),
                ],
              ),
            ),

            // Description
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: Text(
                'اختر المجمع لعرض السكوترات المتاحة وحساب تكلفة الرحلة داخل نطاقه.',
                style: TextStyle(
                  fontFamily: 'Cairo',
                  fontSize: 13,
                  color: Color(0xFF8CA5AA),
                ),
              ),
            ),

            const SizedBox(height: 12),

            // Search bar
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Container(
                height: 46,
                decoration: BoxDecoration(
                  color: const Color(0xFF13262A),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: const Color(0xFF1E3A40)),
                ),
                child: TextField(
                  controller: _searchController,
                  textAlign: TextAlign.right,
                  style: const TextStyle(
                    fontFamily: 'Cairo',
                    fontSize: 14,
                    color: Colors.white,
                  ),
                  decoration: const InputDecoration(
                    hintText: 'ابحث عن اسم المجمع...',
                    hintStyle: TextStyle(
                      fontFamily: 'Cairo',
                      fontSize: 13,
                      color: Color(0xFF4A7A84),
                    ),
                    prefixIcon: Icon(
                      Icons.search_rounded,
                      color: AppColors.primary,
                      size: 20,
                    ),
                    border: InputBorder.none,
                    contentPadding: EdgeInsets.symmetric(vertical: 12, horizontal: 12),
                  ),
                ),
              ),
            ),

            const SizedBox(height: 12),

            // Content list / states
            Flexible(
              child: _buildBody(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBody() {
    if (_isLoading) {
      return const Center(
        child: Padding(
          padding: EdgeInsets.all(32.0),
          child: CircularProgressIndicator(color: AppColors.primary),
        ),
      );
    }

    if (_errorMessage != null) {
      return Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.error_outline_rounded, color: AppColors.error, size: 36),
            const SizedBox(height: 10),
            Text(
              _errorMessage!,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontFamily: 'Cairo',
                fontSize: 14,
                color: Colors.white70,
              ),
            ),
            const SizedBox(height: 16),
            ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                foregroundColor: Colors.black,
              ),
              onPressed: _fetchCompounds,
              icon: const Icon(Icons.refresh_rounded, size: 18),
              label: const Text('إعادة المحاولة', style: TextStyle(fontFamily: 'Cairo')),
            ),
          ],
        ),
      );
    }

    if (_filteredCompounds.isEmpty) {
      return Padding(
        padding: const EdgeInsets.all(32.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(
              Icons.location_off_rounded,
              color: Color(0xFF4A7A84),
              size: 40,
            ),
            const SizedBox(height: 12),
            const Text(
              'لا توجد مجمعات مطابقة للبحث.',
              style: TextStyle(
                fontFamily: 'Cairo',
                fontSize: 14,
                color: Color(0xFF8CA5AA),
              ),
            ),
          ],
        ),
      );
    }

    return ListView.separated(
      shrinkWrap: true,
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
      itemCount: _filteredCompounds.length,
      separatorBuilder: (_, index) => const Divider(
        color: Color(0xFF1E3A40),
        height: 1,
      ),
      itemBuilder: (context, index) {
        final compound = _filteredCompounds[index];
        final isSelected = widget.currentCompound?.id == compound.id;

        return ListTile(
          contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
          leading: Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: isSelected
                  ? AppColors.primary.withAlpha(40)
                  : const Color(0xFF13262A),
              borderRadius: BorderRadius.circular(10),
              border: Border.all(
                color: isSelected ? AppColors.primary : const Color(0xFF1E3A40),
              ),
            ),
            child: Icon(
              Icons.apartment_rounded,
              color: isSelected ? AppColors.primary : const Color(0xFF8CA5AA),
              size: 22,
            ),
          ),
          title: Text(
            compound.name,
            style: TextStyle(
              fontFamily: 'Cairo',
              fontSize: 15,
              fontWeight: isSelected ? FontWeight.w700 : FontWeight.w600,
              color: isSelected ? AppColors.primary : Colors.white,
            ),
          ),
          trailing: isSelected
              ? const Icon(
                  Icons.check_circle_rounded,
                  color: AppColors.primary,
                  size: 22,
                )
              : const Icon(
                  Icons.arrow_forward_ios_rounded,
                  color: Color(0xFF4A7A84),
                  size: 14,
                ),
          onTap: () {
            context.read<CompoundCubit>().selectCompound(compound);
            Navigator.of(context).pop(compound);
          },
        );
      },
    );
  }
}
