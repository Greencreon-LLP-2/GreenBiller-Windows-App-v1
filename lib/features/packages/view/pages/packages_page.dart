import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:green_biller/core/constants/colors.dart';
import 'package:green_biller/features/auth/login/model/user_model.dart';
import 'package:green_biller/features/packages/controller/package_controller.dart';
import 'package:green_biller/features/packages/models/package_model.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:hooks_riverpod/legacy.dart';
import 'package:url_launcher/url_launcher.dart';

class CustomizablePackage {
  final String id;
  final String name;
  final String description;
  final double basePrice;
  final double pricePerStore;
  final int minimumStores;
  final int maximumStores;
  final List<String> features;

  CustomizablePackage({
    required this.id,
    required this.name,
    required this.description,
    required this.basePrice,
    required this.pricePerStore,
    required this.minimumStores,
    required this.maximumStores,
    required this.features,
  });

  double calculateTotalPrice(int stores) {
    return basePrice + (stores * pricePerStore);
  }
}

class PackageState {
  final Datum? selectedPackage;
  final CustomizablePackage? selectedCustomPackage;
  final int selectedStoreCount;
  final bool isLoading;
  final String? error;
  final String searchQuery;
  final String selectedFilter;

  PackageState({
    this.selectedPackage,
    this.selectedCustomPackage,
    this.selectedStoreCount = 1,
    this.isLoading = false,
    this.error,
    this.searchQuery = '',
    this.selectedFilter = 'all',
  });

  PackageState copyWith({
    Datum? selectedPackage,
    CustomizablePackage? selectedCustomPackage,
    int? selectedStoreCount,
    bool? isLoading,
    String? error,
    String? searchQuery,
    String? selectedFilter,
    bool clearPackage = false,
    bool clearCustomPackage = false,
  }) {
    return PackageState(
      selectedPackage:
          clearPackage ? null : (selectedPackage ?? this.selectedPackage),
      selectedCustomPackage: clearCustomPackage
          ? null
          : (selectedCustomPackage ?? this.selectedCustomPackage),
      selectedStoreCount: selectedStoreCount ?? this.selectedStoreCount,
      isLoading: isLoading ?? this.isLoading,
      error: error ?? this.error,
      searchQuery: searchQuery ?? this.searchQuery,
      selectedFilter: selectedFilter ?? this.selectedFilter,
    );
  }
}

class PackageNotifier extends StateNotifier<PackageState> {
  final ViewPackageController controller;

  PackageNotifier(this.controller) : super(PackageState());

  Future<void> selectPackage(Datum package) async {
    state =
        state.copyWith(isLoading: true, error: null, clearCustomPackage: true);
    try {
      await Future.delayed(const Duration(milliseconds: 800));
      state = state.copyWith(
        selectedPackage: package,
        isLoading: false,
      );
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: e.toString(),
      );
    }
  }

  Future<void> selectCustomPackage(CustomizablePackage package) async {
    state = state.copyWith(isLoading: true, error: null, clearPackage: true);
    try {
      await Future.delayed(const Duration(milliseconds: 800));
      state = state.copyWith(
        selectedCustomPackage: package,
        isLoading: false,
      );
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: e.toString(),
      );
    }
  }

  void updateStoreCount(int count) {
    if (state.selectedCustomPackage != null) {
      final clampedCount = count.clamp(
        state.selectedCustomPackage!.minimumStores,
        state.selectedCustomPackage!.maximumStores,
      );
      state = state.copyWith(selectedStoreCount: clampedCount);
    }
  }

  void updateSearchQuery(String query) {
    state = state.copyWith(searchQuery: query);
  }

  void updateFilter(String filter) {
    state = state.copyWith(selectedFilter: filter);
  }

  void clearSelection() {
    state = state.copyWith(
      selectedPackage: null,
      selectedCustomPackage: null,
      selectedStoreCount: 1,
      clearPackage: true,
      clearCustomPackage: true,
    );
  }
}

final packageNotifierProvider =
    StateNotifierProvider.family<PackageNotifier, PackageState, String?>(
  (ref, accessToken) => PackageNotifier(
    ViewPackageController(accessToken: accessToken ?? ''),
  ),
);

final packagesProvider = FutureProvider<PackageModel>((ref) {
  final userModel = ref.watch(userProvider);
  final accessToken = userModel?.accessToken;
  final controller = ViewPackageController(accessToken: accessToken ?? '');
  return controller.viewPackageController();
});

final customizablePackageProvider = Provider<CustomizablePackage>((ref) {
  return CustomizablePackage(
    id: 'custom_store_package',
    name: 'Multi-Store Customizable Package',
    description:
        'Perfect for businesses with multiple locations. Choose exactly how many stores you need.',
    basePrice: 2000,
    pricePerStore: 500,
    minimumStores: 1,
    maximumStores: 50,
    features: [
      'Web Panel Access',
      'Android & iOS Apps',
      'Customer Management',
      'Inventory Tracking',
      'Sales Analytics',
      'Multi-Store Dashboard',
      'Centralized Reporting',
      '24/7 Support',
    ],
  );
});

class PackageCard extends StatefulWidget {
  final Datum package;
  final bool isSelected;
  final VoidCallback onSelect;

  const PackageCard({
    super.key,
    required this.package,
    required this.isSelected,
    required this.onSelect,
  });

  @override
  State<PackageCard> createState() => _PackageCardState();
}

class _PackageCardState extends State<PackageCard> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        transform: Matrix4.identity()..scale(_isHovered ? 1.02 : 1.0),
        child: Card(
          elevation: widget.isSelected ? 12 : (_isHovered ? 8 : 3),
          shadowColor: widget.isSelected
              ? accentColor.withOpacity(0.4)
              : Colors.black.withOpacity(0.1),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
            side: widget.isSelected
                ? const BorderSide(color: accentColor, width: 2)
                : BorderSide(
                    color: _isHovered
                        ? accentColor.withOpacity(0.3)
                        : Colors.transparent,
                    width: 1,
                  ),
          ),
          child: InkWell(
            onTap: widget.onSelect,
            borderRadius: BorderRadius.circular(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  flex: 2,
                  child: Stack(
                    children: [
                      Container(
                        width: double.infinity,
                        decoration: BoxDecoration(
                          borderRadius: const BorderRadius.only(
                            topLeft: Radius.circular(16),
                            topRight: Radius.circular(16),
                          ),
                          gradient: LinearGradient(
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                            colors: [
                              accentColor,
                              accentColor.withOpacity(0.8),
                            ],
                          ),
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Container(
                              padding: const EdgeInsets.all(12),
                              decoration: BoxDecoration(
                                color: Colors.white.withOpacity(0.2),
                                shape: BoxShape.circle,
                              ),
                              child: const Icon(
                                Icons.local_offer,
                                color: Colors.white,
                                size: 24,
                              ),
                            ),
                            const SizedBox(height: 8),
                            const Text(
                              'PACKAGE',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 10,
                                fontWeight: FontWeight.bold,
                                letterSpacing: 1,
                              ),
                            ),
                          ],
                        ),
                      ),
                      if (widget.isSelected)
                        Positioned(
                          top: 8,
                          right: 8,
                          child: Container(
                            padding: const EdgeInsets.all(4),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              shape: BoxShape.circle,
                              boxShadow: [
                                BoxShadow(
                                  color: accentColor.withOpacity(0.3),
                                  blurRadius: 4,
                                  offset: const Offset(0, 2),
                                ),
                              ],
                            ),
                            child: const Icon(
                              Icons.check,
                              color: accentColor,
                              size: 16,
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
                Expanded(
                  flex: 3,
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Package Name
                        Text(
                          widget.package.packageName ?? 'Package',
                          style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            color: textPrimaryColor,
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 8),
                        // Price
                        RichText(
                          text: TextSpan(
                            children: [
                              const TextSpan(
                                text: '₹',
                                style: TextStyle(
                                  fontSize: 12,
                                  color: accentColor,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              TextSpan(
                                text: widget.package.price ?? '0',
                                style: const TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: accentColor,
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 4),
                        const Text(
                          'One-time payment',
                          style: TextStyle(
                            fontSize: 11,
                            color: textSecondaryColor,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        if (widget.package.ifMultistore == '1' &&
                            widget.package.pricePerStore != null)
                          Text(
                            '₹${widget.package.pricePerStore} per store',
                            style: const TextStyle(
                              fontSize: 11,
                              color:
                                  Colors.blue, // Different color for emphasis
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        const SizedBox(height: 12),
                        // Feature Indicators
                        Expanded(
                          child: Column(
                            children: [
                              if (widget.package.ifWebpanel == '1')
                                const Row(
                                  children: [
                                    Icon(Icons.web,
                                        size: 12, color: accentColor),
                                    SizedBox(width: 4),
                                    Expanded(
                                      child: Text(
                                        'Web Panel',
                                        style: TextStyle(
                                          fontSize: 10,
                                          color: accentColor,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              if (widget.package.ifAndroid == '1' ||
                                  widget.package.ifIos == '1')
                                const SizedBox(height: 4),
                              if (widget.package.ifAndroid == '1' ||
                                  widget.package.ifIos == '1')
                                const Row(
                                  children: [
                                    Icon(Icons.phone_android,
                                        size: 12, color: accentColor),
                                    SizedBox(width: 4),
                                    Expanded(
                                      child: Text(
                                        'Mobile Apps',
                                        style: TextStyle(
                                          fontSize: 10,
                                          color: accentColor,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              // Replace the existing multi-store indicator:
                              if (widget.package.ifMultistore == '1')
                                const SizedBox(height: 4),
                              if (widget.package.ifMultistore == '1')
                                Row(
                                  children: [
                                    Icon(Icons.store,
                                        size: 12,
                                        color: widget.package.pricePerStore !=
                                                null
                                            ? Colors
                                                .blue // Highlight if price exists
                                            : accentColor),
                                    const SizedBox(width: 4),
                                    Expanded(
                                      child: Text(
                                        widget.package.pricePerStore != null
                                            ? 'Multi-Store (₹${widget.package.pricePerStore}/store)'
                                            : 'Multi-Store',
                                        style: TextStyle(
                                          fontSize: 10,
                                          color: widget.package.pricePerStore !=
                                                  null
                                              ? Colors
                                                  .blue // Highlight if price exists
                                              : accentColor,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// Enhanced Package Details View - Converted to ConsumerWidget
class EnhancedPackageDetailsView extends ConsumerWidget {
  final Datum package;
  final bool isLoading;

  const EnhancedPackageDetailsView({
    super.key,
    required this.package,
    required this.isLoading,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userModel = ref.watch(userProvider);

    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Row(
              children: [
                Expanded(
                  child: Text(
                    package.packageName ?? 'Package Details',
                    style: const TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: textPrimaryColor,
                    ),
                  ),
                ),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [accentColor, accentColor.withOpacity(0.8)],
                    ),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Text(
                    'STANDARD',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 10,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            // Text(
            //   package.description ??
            //       'Complete package solution for your business needs.',
            //   style: const TextStyle(
            //     color: textSecondaryColor,
            //     fontSize: 14,
            //     height: 1.4,
            //   ),
            // ),
            const SizedBox(height: 20),

            // Price Section
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.green.withOpacity(0.05),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: Colors.green.withOpacity(0.2),
                  width: 1,
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Package Price:',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: textPrimaryColor,
                    ),
                  ),
                  Text(
                    '₹${package.price ?? '0'}',
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.green,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),

            // Features Section
            const Text(
              'Package Features',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: textPrimaryColor,
              ),
            ),
            const SizedBox(height: 12),

            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    if (package.ifWebpanel == '1')
                      _buildFeatureItem(
                        icon: Icons.web,
                        title: 'Web Panel Access',
                        description: 'Complete web-based management system',
                      ),
                    if (package.ifAndroid == '1')
                      _buildFeatureItem(
                        icon: Icons.android,
                        title: 'Android Application',
                        description: 'Native Android mobile application',
                      ),
                    if (package.ifIos == '1')
                      _buildFeatureItem(
                        icon: Icons.phone_iphone,
                        title: 'iOS Application',
                        description: 'Native iOS mobile application',
                      ),
                    if (package.ifMultistore == '1')
                      _buildFeatureItem(
                        icon: Icons.store,
                        title: 'Multi-Store Support',
                        description: 'Manage multiple store locations',
                      ),
                    _buildFeatureItem(
                      icon: Icons.inventory,
                      title: 'Inventory Management',
                      description: 'Track and manage your inventory',
                    ),
                    _buildFeatureItem(
                      icon: Icons.analytics,
                      title: 'Sales Analytics',
                      description: 'Detailed sales reports and analytics',
                    ),
                    _buildFeatureItem(
                      icon: Icons.support_agent,
                      title: 'Customer Support',
                      description: '24/7 technical support',
                    ),
                    if (package.ifMultistore == '1' &&
                        package.pricePerStore != null)
                      _buildFeatureItem(
                        icon: Icons.attach_money,
                        title: 'Price Per Store',
                        description:
                            '₹${package.pricePerStore} per additional store',
                      ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 20),

            // Action Buttons
            Row(
              children: [
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(
                              'Package details for ${package.packageName}'),
                          backgroundColor: accentColor,
                        ),
                      );
                    },
                    icon: const Icon(Icons.info_outline, size: 18),
                    label: const Text('More Info'),
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      side: const BorderSide(color: accentColor, width: 1.5),
                      foregroundColor: accentColor,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  flex: 2,
                  child: ElevatedButton.icon(
                    onPressed: isLoading
                        ? null
                        : () async {
                            // Get user mobile number
                            final mobile = userModel?.user?.mobile ?? '';

                            // Validate mobile number
                            if (mobile.isEmpty) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text('Mobile number not found'),
                                  backgroundColor: Colors.red,
                                ),
                              );
                              return;
                            }

                            // Construct URL
                            final url =
                                'https://greenbiller.in/paynow/$mobile/${package.id}';

                            // Launch URL
                            if (await canLaunchUrl(Uri.parse(url))) {
                              await launchUrl(Uri.parse(url));
                            } else {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text('Could not launch $url'),
                                  backgroundColor: Colors.red,
                                ),
                              );
                            }
                          },
                    icon: isLoading
                        ? const SizedBox(
                            height: 18,
                            width: 18,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              color: Colors.white,
                            ),
                          )
                        : const Icon(Icons.shopping_cart, size: 18),
                    label: Text(
                      isLoading ? 'Processing...' : 'Select Package',
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      backgroundColor: accentColor,
                      foregroundColor: Colors.white,
                      elevation: 3,
                      shadowColor: accentColor.withOpacity(0.3),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFeatureItem({
    required IconData icon,
    required String title,
    required String description,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: accentColor.withOpacity(0.2), width: 1),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.02),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: accentColor.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(
              icon,
              color: accentColor,
              size: 20,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: textPrimaryColor,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  description,
                  style: const TextStyle(
                    fontSize: 12,
                    color: textSecondaryColor,
                    height: 1.3,
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

class PackagesPage extends HookConsumerWidget {
  const PackagesPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userModel = ref.watch(userProvider);
    final accessToken = userModel?.accessToken;
    final packagesAsync = ref.watch(packagesProvider);
    final packageState = ref.watch(packageNotifierProvider(accessToken));
    final customizablePackage = ref.watch(customizablePackageProvider);

    return Scaffold(
      backgroundColor: Colors.green.shade50,
      appBar: AppBar(
        backgroundColor: backgroundColor,
        elevation: 4,
        shadowColor: primaryColor.withOpacity(0.3),
        leading: IconButton(
          onPressed: () => context.go('/homepage'),
          icon: Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.2),
              borderRadius: BorderRadius.circular(8),
            ),
            child: const Icon(Icons.arrow_back_ios_new,
                color: Colors.black, size: 16),
          ),
        ),
        title: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: accentColor.withOpacity(0.2),
                borderRadius: BorderRadius.circular(8),
              ),
              child:
                  const Icon(Icons.inventory_2, color: accentColor, size: 20),
            ),
            const SizedBox(width: 12),
            const Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Available Packages',
                  style: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                  ),
                ),
                Text(
                  'Choose the perfect plan for you',
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 12,
                    fontWeight: FontWeight.normal,
                  ),
                ),
              ],
            ),
          ],
        ),
        actions: [
          Container(
            margin: const EdgeInsets.only(right: 8),
            child: IconButton(
              onPressed: () {
                ref
                    .read(packageNotifierProvider(accessToken).notifier)
                    .clearSelection();
              },
              icon: Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Icon(Icons.refresh, color: Colors.white, size: 18),
              ),
            ),
          ),
        ],
      ),
      body: packagesAsync.when(
        loading: () => const Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CircularProgressIndicator(color: accentColor),
              SizedBox(height: 16),
              Text(
                'Loading packages...',
                style: TextStyle(color: textSecondaryColor, fontSize: 16),
              ),
            ],
          ),
        ),
        error: (error, stackTrace) => Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.error_outline,
                size: 64,
                color: errorColor.withOpacity(0.6),
              ),
              const SizedBox(height: 16),
              const Text(
                'Oops! Something went wrong',
                style: TextStyle(
                  color: textPrimaryColor,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Error loading packages: $error',
                textAlign: TextAlign.center,
                style: const TextStyle(color: errorColor, fontSize: 14),
              ),
              const SizedBox(height: 24),
              ElevatedButton.icon(
                onPressed: () => ref.refresh(packagesProvider),
                icon: const Icon(Icons.refresh),
                label: const Text('Try Again'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: accentColor,
                  foregroundColor: Colors.white,
                ),
              ),
            ],
          ),
        ),
        data: (packageModel) {
          final packages = packageModel.data ?? [];

          if (packages.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.inventory_outlined,
                    size: 64,
                    color: textSecondaryColor.withOpacity(0.6),
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    'No packages available',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: textPrimaryColor,
                    ),
                  ),
                ],
              ),
            );
          }

          final filteredPackages = packages.where((package) {
            final matchesSearch = packageState.searchQuery.isEmpty ||
                (package.packageName
                        ?.toLowerCase()
                        .contains(packageState.searchQuery.toLowerCase()) ??
                    false);

            bool matchesFilter = true;
            if (packageState.selectedFilter != 'all') {
              switch (packageState.selectedFilter) {
                case 'web':
                  matchesFilter = package.ifWebpanel == '1';
                  break;
                case 'mobile':
                  matchesFilter =
                      package.ifAndroid == '1' || package.ifIos == '1';
                  break;
                case 'multistore':
                  matchesFilter = package.ifMultistore == '1';
                  break;
                case 'custom':
                  matchesFilter = false;
                  break;
              }
            }

            return matchesSearch && matchesFilter;
          }).toList();

          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Left Panel - Package List
                Expanded(
                  flex: 3,
                  child: Card(
                    elevation: 4,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Column(
                      children: [
                        // Search and Filter Header
                        Container(
                          padding: const EdgeInsets.all(20),
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                              colors: [
                                primaryColor.withOpacity(0.08),
                                accentColor.withOpacity(0.05),
                              ],
                            ),
                            borderRadius: const BorderRadius.only(
                              topLeft: Radius.circular(12),
                              topRight: Radius.circular(12),
                            ),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                'Find Your Perfect Package',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: textPrimaryColor,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                '${filteredPackages.length + (packageState.selectedFilter == 'all' || packageState.selectedFilter == 'custom' ? 1 : 0)} package${(filteredPackages.length + (packageState.selectedFilter == 'all' || packageState.selectedFilter == 'custom' ? 1 : 0)) != 1 ? 's' : ''} available',
                                style: const TextStyle(
                                  fontSize: 12,
                                  color: textSecondaryColor,
                                ),
                              ),
                              const SizedBox(height: 16),
                              // Search Bar
                              Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(12),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black.withOpacity(0.05),
                                      blurRadius: 8,
                                      offset: const Offset(0, 2),
                                    ),
                                  ],
                                ),
                                child: TextField(
                                  onChanged: (value) => ref
                                      .read(packageNotifierProvider(accessToken)
                                          .notifier)
                                      .updateSearchQuery(value),
                                  decoration: InputDecoration(
                                    hintText: 'Search packages...',
                                    hintStyle: TextStyle(
                                        color: textSecondaryColor
                                            .withOpacity(0.7)),
                                    prefixIcon: Container(
                                      margin: const EdgeInsets.all(8),
                                      decoration: BoxDecoration(
                                        color: accentColor.withOpacity(0.1),
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                      child: const Icon(Icons.search,
                                          color: accentColor),
                                    ),
                                    suffixIcon: packageState
                                            .searchQuery.isNotEmpty
                                        ? IconButton(
                                            icon: const Icon(Icons.clear,
                                                color: textSecondaryColor),
                                            onPressed: () => ref
                                                .read(packageNotifierProvider(
                                                        accessToken)
                                                    .notifier)
                                                .updateSearchQuery(''),
                                          )
                                        : null,
                                    filled: true,
                                    fillColor: Colors.white,
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(12),
                                      borderSide: BorderSide.none,
                                    ),
                                    enabledBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(12),
                                      borderSide: BorderSide(
                                          color: Colors.grey.shade200),
                                    ),
                                    focusedBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(12),
                                      borderSide: const BorderSide(
                                          color: accentColor, width: 2),
                                    ),
                                    contentPadding: const EdgeInsets.symmetric(
                                      horizontal: 16,
                                      vertical: 16,
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(height: 16),
                              // Filter Chips
                              Row(
                                children: [
                                  const Text(
                                    'Filter:',
                                    style: TextStyle(
                                      color: textSecondaryColor,
                                      fontWeight: FontWeight.w600,
                                      fontSize: 14,
                                    ),
                                  ),
                                  const SizedBox(width: 12),
                                  Expanded(
                                    child: SizedBox(
                                      height: 36,
                                      child: ListView(
                                        scrollDirection: Axis.horizontal,
                                        children: [
                                          _buildFilterChip('all', 'All', ref,
                                              accessToken, packageState),
                                          const SizedBox(width: 8),
                                          _buildFilterChip('web', 'Web', ref,
                                              accessToken, packageState),
                                          const SizedBox(width: 8),
                                          _buildFilterChip('mobile', 'Mobile',
                                              ref, accessToken, packageState),
                                          const SizedBox(width: 8),
                                          _buildFilterChip(
                                              'multistore',
                                              'Multi-Store',
                                              ref,
                                              accessToken,
                                              packageState),
                                          const SizedBox(width: 8),
                                          _buildFilterChip(
                                              'custom',
                                              'Customizable',
                                              ref,
                                              accessToken,
                                              packageState),
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                        // Package Grid
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.all(16),
                            child: _buildPackageGrid(
                              filteredPackages,
                              customizablePackage,
                              packageState,
                              ref,
                              accessToken,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                // Right Panel - Package Details
                Expanded(
                  flex: 2,
                  child: packageState.selectedPackage != null
                      ? EnhancedPackageDetailsView(
                          package: packageState.selectedPackage!,
                          isLoading: packageState.isLoading,
                        )
                      : packageState.selectedCustomPackage != null
                          ? CustomizablePackageDetailsView(
                              package: packageState.selectedCustomPackage!,
                              storeCount: packageState.selectedStoreCount,
                              isLoading: packageState.isLoading,
                              onStoreCountChanged: (count) => ref
                                  .read(packageNotifierProvider(accessToken)
                                      .notifier)
                                  .updateStoreCount(count),
                            )
                          : Card(
                              elevation: 4,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Center(
                                child: Padding(
                                  padding: const EdgeInsets.all(32),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Container(
                                        padding: const EdgeInsets.all(24),
                                        decoration: BoxDecoration(
                                          color: accentColor.withOpacity(0.1),
                                          shape: BoxShape.circle,
                                        ),
                                        child: Icon(
                                          Icons.touch_app_outlined,
                                          size: 48,
                                          color: accentColor.withOpacity(0.6),
                                        ),
                                      ),
                                      const SizedBox(height: 16),
                                      const Text(
                                        'Select a Package',
                                        style: TextStyle(
                                          fontSize: 20,
                                          fontWeight: FontWeight.bold,
                                          color: textPrimaryColor,
                                        ),
                                      ),
                                      const SizedBox(height: 8),
                                      const Text(
                                        'Choose from our available packages to view detailed information',
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                          fontSize: 14,
                                          color: textSecondaryColor,
                                          height: 1.5,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildPackageGrid(
    List<Datum> filteredPackages,
    CustomizablePackage customizablePackage,
    PackageState packageState,
    WidgetRef ref,
    String? accessToken,
  ) {
    final showCustomPackage = packageState.selectedFilter == 'all' ||
        packageState.selectedFilter == 'custom';

    final shouldShowCustom = showCustomPackage &&
        (packageState.searchQuery.isEmpty ||
            customizablePackage.name
                .toLowerCase()
                .contains(packageState.searchQuery.toLowerCase()));

    if (filteredPackages.isEmpty && !shouldShowCustom) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.search_off,
              size: 48,
              color: textSecondaryColor.withOpacity(0.6),
            ),
            const SizedBox(height: 16),
            const Text(
              'No packages match your criteria',
              style: TextStyle(
                color: textSecondaryColor,
                fontSize: 16,
              ),
            ),
          ],
        ),
      );
    }

    return GridView.builder(
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 0.8,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
      ),
      itemCount: filteredPackages.length + (shouldShowCustom ? 1 : 0),
      itemBuilder: (context, index) {
        if (shouldShowCustom && index == 0) {
          // Show customizable package first
          final isSelected =
              packageState.selectedCustomPackage?.id == customizablePackage.id;
          return CustomizablePackageCard(
            package: customizablePackage,
            isSelected: isSelected,
            onSelect: () => ref
                .read(packageNotifierProvider(accessToken).notifier)
                .selectCustomPackage(customizablePackage),
          );
        }

        final packageIndex = shouldShowCustom ? index - 1 : index;
        final package = filteredPackages[packageIndex];
        final isSelected = packageState.selectedPackage?.id == package.id;

        return PackageCard(
          package: package,
          isSelected: isSelected,
          onSelect: () => ref
              .read(packageNotifierProvider(accessToken).notifier)
              .selectPackage(package),
        );
      },
    );
  }

  Widget _buildFilterChip(String value, String label, WidgetRef ref,
      String? accessToken, PackageState packageState) {
    final isSelected = packageState.selectedFilter == value;
    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      child: FilterChip(
        label: Text(
          label,
          style: TextStyle(
            fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
          ),
        ),
        selected: isSelected,
        onSelected: (_) => ref
            .read(packageNotifierProvider(accessToken).notifier)
            .updateFilter(value),
        backgroundColor: Colors.white,
        selectedColor: accentColor.withOpacity(0.15),
        checkmarkColor: accentColor,
        labelStyle: TextStyle(
          color: isSelected ? accentColor : textSecondaryColor,
          fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
        ),
        side: BorderSide(
          color: isSelected ? accentColor : textLightColor.withOpacity(0.5),
          width: isSelected ? 2 : 1,
        ),
        elevation: isSelected ? 2 : 0,
        shadowColor: accentColor.withOpacity(0.3),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
      ),
    );
  }
}

class CustomizablePackageCard extends StatefulWidget {
  final CustomizablePackage package;
  final bool isSelected;
  final VoidCallback onSelect;

  const CustomizablePackageCard({
    super.key,
    required this.package,
    required this.isSelected,
    required this.onSelect,
  });

  @override
  State<CustomizablePackageCard> createState() =>
      _CustomizablePackageCardState();
}

class _CustomizablePackageCardState extends State<CustomizablePackageCard> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        transform: Matrix4.identity()..scale(_isHovered ? 1.02 : 1.0),
        child: Card(
          elevation: widget.isSelected ? 12 : (_isHovered ? 8 : 3),
          shadowColor: widget.isSelected
              ? Colors.purple.withOpacity(0.4)
              : Colors.black.withOpacity(0.1),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
            side: widget.isSelected
                ? const BorderSide(color: Colors.purple, width: 2)
                : BorderSide(
                    color: _isHovered
                        ? Colors.purple.withOpacity(0.3)
                        : Colors.transparent,
                    width: 1,
                  ),
          ),
          child: InkWell(
            onTap: widget.onSelect,
            borderRadius: BorderRadius.circular(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header Section with Gradient
                Expanded(
                  flex: 2,
                  child: Stack(
                    children: [
                      Container(
                        width: double.infinity,
                        decoration: const BoxDecoration(
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(16),
                            topRight: Radius.circular(16),
                          ),
                          gradient: LinearGradient(
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                            colors: [
                              Colors.purple,
                              Colors.deepPurple,
                            ],
                          ),
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Container(
                              padding: const EdgeInsets.all(12),
                              decoration: BoxDecoration(
                                color: Colors.white.withOpacity(0.2),
                                shape: BoxShape.circle,
                              ),
                              child: const Icon(
                                Icons.tune,
                                color: Colors.white,
                                size: 24,
                              ),
                            ),
                            const SizedBox(height: 8),
                            const Text(
                              'CUSTOMIZABLE',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 10,
                                fontWeight: FontWeight.bold,
                                letterSpacing: 1,
                              ),
                            ),
                          ],
                        ),
                      ),
                      // Selection Indicator
                      if (widget.isSelected)
                        Positioned(
                          top: 8,
                          right: 8,
                          child: Container(
                            padding: const EdgeInsets.all(4),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              shape: BoxShape.circle,
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.purple.withOpacity(0.3),
                                  blurRadius: 4,
                                  offset: const Offset(0, 2),
                                ),
                              ],
                            ),
                            child: const Icon(
                              Icons.check,
                              color: Colors.purple,
                              size: 16,
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
                // Content Section
                Expanded(
                  flex: 3,
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Package Name
                        Text(
                          widget.package.name,
                          style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            color: textPrimaryColor,
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 8),
                        // Price Range
                        RichText(
                          text: TextSpan(
                            children: [
                              const TextSpan(
                                text: 'From ₹',
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Colors.purple,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              TextSpan(
                                text:
                                    '${widget.package.calculateTotalPrice(1).toInt()}',
                                style: const TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.purple,
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          '₹${widget.package.pricePerStore.toInt()} per store',
                          style: const TextStyle(
                            fontSize: 11,
                            color: textSecondaryColor,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        const SizedBox(height: 12),
                        // Feature Indicators
                        Expanded(
                          child: Column(
                            children: [
                              Row(
                                children: [
                                  Icon(Icons.storefront,
                                      size: 12, color: Colors.purple.shade600),
                                  const SizedBox(width: 4),
                                  Expanded(
                                    child: Text(
                                      '${widget.package.minimumStores}-${widget.package.maximumStores} stores',
                                      style: TextStyle(
                                        fontSize: 10,
                                        color: Colors.purple.shade600,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 4),
                              Row(
                                children: [
                                  Icon(Icons.apps,
                                      size: 12, color: Colors.purple.shade600),
                                  const SizedBox(width: 4),
                                  const Expanded(
                                    child: Text(
                                      'All platforms',
                                      style: TextStyle(
                                        fontSize: 10,
                                        color: Colors.purple,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class CustomizablePackageDetailsView extends ConsumerWidget {
  final CustomizablePackage package;
  final int storeCount;
  final bool isLoading;
  final Function(int) onStoreCountChanged;

  const CustomizablePackageDetailsView({
    super.key,
    required this.package,
    required this.storeCount,
    required this.isLoading,
    required this.onStoreCountChanged,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userModel = ref.watch(userProvider);
    final totalPrice = package.calculateTotalPrice(storeCount);

    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header with Custom Badge
            Row(
              children: [
                Expanded(
                  child: Text(
                    package.name,
                    style: const TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: textPrimaryColor,
                    ),
                  ),
                ),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [Colors.purple, Colors.deepPurple],
                    ),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Text(
                    'CUSTOMIZABLE',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 10,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              package.description,
              style: const TextStyle(
                color: textSecondaryColor,
                fontSize: 14,
                height: 1.4,
              ),
            ),
            const SizedBox(height: 20),

            // Store Count Selector
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    Colors.purple.withOpacity(0.08),
                    Colors.deepPurple.withOpacity(0.05),
                  ],
                ),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: Colors.purple.withOpacity(0.2),
                  width: 1,
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Select Number of Stores',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: textPrimaryColor,
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Store Count Controls
                  Row(
                    children: [
                      // Decrease Button
                      Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(8),
                          border:
                              Border.all(color: Colors.purple.withOpacity(0.3)),
                        ),
                        child: IconButton(
                          onPressed: storeCount > package.minimumStores
                              ? () => onStoreCountChanged(storeCount - 1)
                              : null,
                          icon: const Icon(Icons.remove),
                          color: Colors.purple,
                          iconSize: 20,
                        ),
                      ),

                      // Store Count Display
                      Expanded(
                        child: Container(
                          margin: const EdgeInsets.symmetric(horizontal: 16),
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(
                                color: Colors.purple.withOpacity(0.3)),
                          ),
                          child: Column(
                            children: [
                              Text(
                                '$storeCount',
                                style: const TextStyle(
                                  fontSize: 28,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.purple,
                                ),
                              ),
                              Text(
                                storeCount == 1 ? 'Store' : 'Stores',
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Colors.purple.shade600,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),

                      // Increase Button
                      Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(8),
                          border:
                              Border.all(color: Colors.purple.withOpacity(0.3)),
                        ),
                        child: IconButton(
                          onPressed: storeCount < package.maximumStores
                              ? () => onStoreCountChanged(storeCount + 1)
                              : null,
                          icon: const Icon(Icons.add),
                          color: Colors.purple,
                          iconSize: 20,
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 16),

                  // Store Range Info
                  Text(
                    'Range: ${package.minimumStores} - ${package.maximumStores} stores',
                    style: const TextStyle(
                      fontSize: 12,
                      color: textSecondaryColor,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),

            // Price Breakdown
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.green.withOpacity(0.05),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: Colors.green.withOpacity(0.2),
                  width: 1,
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Price Breakdown',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: textPrimaryColor,
                    ),
                  ),
                  const SizedBox(height: 12),

                  // Base Price
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Base Package:',
                        style:
                            TextStyle(fontSize: 14, color: textSecondaryColor),
                      ),
                      Text(
                        '₹${package.basePrice.toInt()}',
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: textPrimaryColor,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),

                  // Store Cost
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        '$storeCount store${storeCount != 1 ? 's' : ''} × ₹${package.pricePerStore.toInt()}:',
                        style: const TextStyle(
                            fontSize: 14, color: textSecondaryColor),
                      ),
                      Text(
                        '₹${(storeCount * package.pricePerStore).toInt()}',
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: textPrimaryColor,
                        ),
                      ),
                    ],
                  ),

                  const Divider(height: 20),

                  // Total Price
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Total Price:',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: textPrimaryColor,
                        ),
                      ),
                      Text(
                        '₹${totalPrice.toInt()}',
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.green,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),

            // Features Section
            const Text(
              'Included Features',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: textPrimaryColor,
              ),
            ),
            const SizedBox(height: 12),

            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  children: package.features
                      .map(
                        (feature) => Container(
                          margin: const EdgeInsets.only(bottom: 8),
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(
                                color: Colors.purple.withOpacity(0.2),
                                width: 1),
                          ),
                          child: Row(
                            children: [
                              Container(
                                padding: const EdgeInsets.all(4),
                                decoration: BoxDecoration(
                                  color: Colors.purple.withOpacity(0.1),
                                  borderRadius: BorderRadius.circular(4),
                                ),
                                child: const Icon(
                                  Icons.check,
                                  color: Colors.purple,
                                  size: 14,
                                ),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Text(
                                  feature,
                                  style: const TextStyle(
                                    fontSize: 13,
                                    color: textPrimaryColor,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      )
                      .toList(),
                ),
              ),
            ),

            const SizedBox(height: 20),

            // Action Buttons
            Row(
              children: [
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('Package details for ${package.name}'),
                          backgroundColor: Colors.purple,
                        ),
                      );
                    },
                    icon: const Icon(Icons.info_outline, size: 18),
                    label: const Text('Details'),
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      side: const BorderSide(color: Colors.purple, width: 1.5),
                      foregroundColor: Colors.purple,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  flex: 2,
                  child: ElevatedButton.icon(
                    onPressed: isLoading
                        ? null
                        : () async {
                            final mobile = userModel?.user?.mobile ?? '';

                            if (mobile.isEmpty) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text('Mobile number not found'),
                                  backgroundColor: Colors.red,
                                ),
                              );
                              return;
                            }

                            final url =
                                'https://greenbiller.in/paynow/$mobile/${package.id}';

                            if (await canLaunchUrl(Uri.parse(url))) {
                              await launchUrl(Uri.parse(url));
                            } else {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text('Could not launch $url'),
                                  backgroundColor: Colors.red,
                                ),
                              );
                            }
                          },
                    icon: isLoading
                        ? const SizedBox(
                            height: 18,
                            width: 18,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              color: Colors.white,
                            ),
                          )
                        : const Icon(Icons.shopping_cart, size: 18),
                    label: Text(
                      isLoading ? 'Processing...' : 'Select Package',
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      backgroundColor: Colors.purple,
                      foregroundColor: Colors.white,
                      elevation: 3,
                      shadowColor: Colors.purple.withOpacity(0.3),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
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
