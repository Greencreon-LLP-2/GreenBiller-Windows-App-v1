import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:greenbiller/features/plans/controller/plan_controller.dart';

class PlanPage extends GetView<PlanController> {
  const PlanPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.green.shade50,
      appBar: AppBar(
        backgroundColor: const Color(0xFF4CAF50),
        foregroundColor: Colors.white,
        elevation: 4,
        leading: IconButton(
          onPressed: () => Get.back(),
          icon: Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(borderRadius: BorderRadius.circular(8)),
            child: const Icon(Icons.arrow_back, color: Colors.white, size: 25),
          ),
        ),
        title: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: const Color(0xFF4CAF50).withOpacity(0.2),
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Icon(
                Icons.inventory_2,
                color: Colors.white,
                size: 20,
              ),
            ),
            const SizedBox(width: 12),
            const Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Available Packages',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CircularProgressIndicator(color: Color(0xFF4CAF50)),
                SizedBox(height: 16),
                Text(
                  'Loading packages...',
                  style: TextStyle(color: Colors.grey, fontSize: 16),
                ),
              ],
            ),
          );
        }

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
                              const Color(0xFF4CAF50).withOpacity(0.08),
                              const Color(0xFF4CAF50).withOpacity(0.05),
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
                                color: Colors.black87,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Obx(
                              () => Text(
                                '${controller.filteredPackages.length} package${controller.filteredPackages.length != 1 ? 's' : ''} available',
                                style: const TextStyle(
                                  fontSize: 12,
                                  color: Colors.grey,
                                ),
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
                                onChanged: (value) =>
                                    controller.updateSearchQuery(value),
                                decoration: InputDecoration(
                                  hintText: 'Search packages...',
                                  hintStyle: TextStyle(
                                    color: Colors.grey.withOpacity(0.7),
                                  ),
                                  prefixIcon: Container(
                                    margin: const EdgeInsets.all(8),
                                    decoration: BoxDecoration(
                                      color: const Color(
                                        0xFF4CAF50,
                                      ).withOpacity(0.1),
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    child: const Icon(
                                      Icons.search,
                                      color: Color(0xFF4CAF50),
                                    ),
                                  ),
                                  suffixIcon: Obx(
                                    () =>
                                        controller.searchQuery.value.isNotEmpty
                                        ? IconButton(
                                            icon: const Icon(
                                              Icons.clear,
                                              color: Colors.grey,
                                            ),
                                            onPressed: () => controller
                                                .updateSearchQuery(''),
                                          )
                                        : const SizedBox.shrink(),
                                  ),
                                  filled: true,
                                  fillColor: Colors.white,
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(12),
                                    borderSide: BorderSide.none,
                                  ),
                                  enabledBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(12),
                                    borderSide: BorderSide(
                                      color: Colors.grey.shade200,
                                    ),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(12),
                                    borderSide: const BorderSide(
                                      color: Color(0xFF4CAF50),
                                      width: 2,
                                    ),
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
                                    color: Colors.grey,
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
                                        _buildFilterChip(
                                          'all',
                                          'All',
                                          controller,
                                        ),
                                        const SizedBox(width: 8),
                                        _buildFilterChip(
                                          'web',
                                          'Web',
                                          controller,
                                        ),
                                        const SizedBox(width: 8),
                                        _buildFilterChip(
                                          'mobile',
                                          'Mobile',
                                          controller,
                                        ),
                                        const SizedBox(width: 8),
                                        _buildFilterChip(
                                          'multistore',
                                          'Multi-Store',
                                          controller,
                                        ),
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
                          child: Obx(() => _buildPackageGrid(controller)),
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
                child: Obx(
                  () => controller.selectedPackage.value != null
                      ? _buildPackageDetailsView(
                          controller.selectedPackage.value!,
                          controller,
                        )
                      : _buildEmptySelection(),
                ),
              ),
            ],
          ),
        );
      }),
    );
  }

  Widget _buildFilterChip(
    String value,
    String label,
    PlanController controller,
  ) {
    return Obx(() {
      final isSelected = controller.selectedFilter.value == value;
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
          onSelected: (_) => controller.updateFilter(value),
          backgroundColor: Colors.white,
          selectedColor: const Color(0xFF4CAF50).withOpacity(0.15),
          checkmarkColor: const Color(0xFF4CAF50),
          labelStyle: TextStyle(
            color: isSelected ? const Color(0xFF4CAF50) : Colors.grey,
            fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
          ),
          side: BorderSide(
            color: isSelected
                ? const Color(0xFF4CAF50)
                : Colors.grey.withOpacity(0.5),
            width: isSelected ? 2 : 1,
          ),
          elevation: isSelected ? 2 : 0,
          shadowColor: const Color(0xFF4CAF50).withOpacity(0.3),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
        ),
      );
    });
  }

  Widget _buildPackageGrid(PlanController controller) {
    final filteredPackages = controller.filteredPackages;

    if (filteredPackages.isEmpty) {
      return const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.search_off, size: 48, color: Colors.grey),
            SizedBox(height: 16),
            Text(
              'No packages match your criteria',
              style: TextStyle(color: Colors.grey, fontSize: 16),
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
      itemCount: filteredPackages.length,
      itemBuilder: (context, index) {
        final package = filteredPackages[index];
        return Obx(() {
          final isSelected = controller.selectedPackage.value?.id == package.id;
          return _buildPackageCard(package, isSelected, () {
            controller.selectPackage(package);
          });
        });
      },
    );
  }

  Widget _buildPackageCard(
    Package package,
    bool isSelected,
    VoidCallback onSelect,
  ) {
    return Card(
      elevation: isSelected ? 12 : 3,
      shadowColor: isSelected
          ? const Color(0xFF4CAF50).withOpacity(0.4)
          : Colors.black.withOpacity(0.1),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: isSelected
            ? const BorderSide(color: Color(0xFF4CAF50), width: 2)
            : BorderSide.none,
      ),
      child: InkWell(
        onTap: onSelect,
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
                          const Color(0xFF4CAF50),
                          const Color(0xFF4CAF50).withOpacity(0.8),
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
                  if (isSelected)
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
                              color: const Color(0xFF4CAF50).withOpacity(0.3),
                              blurRadius: 4,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                        child: const Icon(
                          Icons.check,
                          color: Color(0xFF4CAF50),
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
                    Text(
                      package.packageName ?? 'Package',
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 8),
                    RichText(
                      text: TextSpan(
                        children: [
                          const TextSpan(
                            text: '₹',
                            style: TextStyle(
                              fontSize: 12,
                              color: Color(0xFF4CAF50),
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          TextSpan(
                            text: package.price ?? '0',
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF4CAF50),
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
                        color: Colors.grey,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    if (package.ifMultistore == '1' &&
                        package.pricePerStore != null)
                      Text(
                        '₹${package.pricePerStore} per store',
                        style: const TextStyle(
                          fontSize: 11,
                          color: Colors.blue,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    const SizedBox(height: 12),
                    Expanded(
                      child: Column(
                        children: [
                          if (package.ifWebpanel == '1')
                            const Row(
                              children: [
                                Icon(
                                  Icons.web,
                                  size: 12,
                                  color: Color(0xFF4CAF50),
                                ),
                                SizedBox(width: 4),
                                Expanded(
                                  child: Text(
                                    'Web Panel',
                                    style: TextStyle(
                                      fontSize: 10,
                                      color: Color(0xFF4CAF50),
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          if (package.ifAndroid == '1' || package.ifIos == '1')
                            const SizedBox(height: 4),
                          if (package.ifAndroid == '1' || package.ifIos == '1')
                            const Row(
                              children: [
                                Icon(
                                  Icons.phone_android,
                                  size: 12,
                                  color: Color(0xFF4CAF50),
                                ),
                                SizedBox(width: 4),
                                Expanded(
                                  child: Text(
                                    'Mobile Apps',
                                    style: TextStyle(
                                      fontSize: 10,
                                      color: Color(0xFF4CAF50),
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          if (package.ifMultistore == '1')
                            const SizedBox(height: 4),
                          if (package.ifMultistore == '1')
                            Row(
                              children: [
                                Icon(
                                  Icons.store,
                                  size: 12,
                                  color: package.pricePerStore != null
                                      ? Colors.blue
                                      : const Color(0xFF4CAF50),
                                ),
                                const SizedBox(width: 4),
                                Expanded(
                                  child: Text(
                                    package.pricePerStore != null
                                        ? 'Multi-Store (₹${package.pricePerStore}/store)'
                                        : 'Multi-Store',
                                    style: TextStyle(
                                      fontSize: 10,
                                      color: package.pricePerStore != null
                                          ? Colors.blue
                                          : const Color(0xFF4CAF50),
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
    );
  }

  Widget _buildPackageDetailsView(Package package, PlanController controller) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    package.packageName ?? 'Package Details',
                    style: const TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        const Color(0xFF4CAF50),
                        const Color(0xFF4CAF50).withOpacity(0.8),
                      ],
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
            const SizedBox(height: 20),
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
                      color: Colors.black87,
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
            const Text(
              'Package Features',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
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
            Row(
              children: [
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: () {
                      Get.snackbar(
                        'Package Info',
                        'Package details for ${package.packageName}',
                        backgroundColor: const Color(0xFF4CAF50),
                        colorText: Colors.white,
                      );
                    },
                    icon: const Icon(Icons.info_outline, size: 18),
                    label: const Text('More Info'),
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      side: const BorderSide(
                        color: Color(0xFF4CAF50),
                        width: 1.5,
                      ),
                      foregroundColor: const Color(0xFF4CAF50),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  flex: 2,
                  child: Obx(
                    () => ElevatedButton.icon(
                      onPressed: controller.isLoading.value
                          ? null
                          : () => controller.purchasePackage(package),
                      icon: controller.isLoading.value
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
                        controller.isLoading.value
                            ? 'Processing...'
                            : 'Select Package',
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        backgroundColor: const Color(0xFF4CAF50),
                        foregroundColor: Colors.white,
                        elevation: 3,
                        shadowColor: const Color(0xFF4CAF50).withOpacity(0.3),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
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
        border: Border.all(
          color: const Color(0xFF4CAF50).withOpacity(0.2),
          width: 1,
        ),
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
              color: const Color(0xFF4CAF50).withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(icon, color: const Color(0xFF4CAF50), size: 20),
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
                    color: Colors.black87,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  description,
                  style: const TextStyle(
                    fontSize: 12,
                    color: Colors.grey,
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

  Widget _buildEmptySelection() {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Center(
        child: Padding(
          padding: const EdgeInsets.all(32),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: const Color(0xFF4CAF50).withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.touch_app_outlined,
                  size: 48,
                  color: const Color(0xFF4CAF50).withOpacity(0.6),
                ),
              ),
              const SizedBox(height: 16),
              const Text(
                'Select a Package',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                'Choose from our available packages to view detailed information',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 14, color: Colors.grey, height: 1.5),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
