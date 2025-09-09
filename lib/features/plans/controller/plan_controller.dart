import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:greenbiller/features/auth/controller/auth_controller.dart';

class PlanController extends GetxController {
  // Observable variables
  var isLoading = false.obs;
  var selectedPackage = Rxn<Package>();
  var searchQuery = ''.obs;
  var selectedFilter = 'all'.obs;
  var packages = <Package>[].obs;

  @override
  void onInit() {
    super.onInit();
    loadPackages();
  }

  void loadPackages() {
    isLoading.value = true;

    packages.value = [
      Package(
        id: '1',
        packageName: 'Starter Plan',
        price: '2999',
        ifWebpanel: '1',
        ifAndroid: '1',
        ifIos: '0',
        ifMultistore: '0',
        description: 'Perfect for small businesses getting started with digital billing',
      ),
      Package(
        id: '2',
        packageName: 'Professional Plan',
        price: '5999',
        ifWebpanel: '1',
        ifAndroid: '1',
        ifIos: '1',
        ifMultistore: '1',
        pricePerStore: '500',
        description: 'Comprehensive solution for growing businesses with multiple platforms',
      ),
      Package(
        id: '3',
        packageName: 'Enterprise Plan',
        price: '9999',
        ifWebpanel: '1',
        ifAndroid: '1',
        ifIos: '1',
        ifMultistore: '1',
        pricePerStore: '300',
        description: 'Full-featured package for large enterprises with advanced multi-store management',
      ),
      Package(
        id: '4',
        packageName: 'Basic Plan',
        price: '1499',
        ifWebpanel: '1',
        ifAndroid: '0',
        ifIos: '0',
        ifMultistore: '0',
        description: 'Web-only solution for businesses starting their digital journey',
      ),
      Package(
        id: '5',
        packageName: 'Premium Multi-Store',
        price: '12999',
        ifWebpanel: '1',
        ifAndroid: '1',
        ifIos: '1',
        ifMultistore: '1',
        pricePerStore: '250',
        description: 'Premium package with advanced features and cost-effective multi-store pricing',
      ),
    ];
    
    isLoading.value = false;
  }

  void selectPackage(Package package) {
    selectedPackage.value = package;
  }

  void updateSearchQuery(String query) {
    searchQuery.value = query;
  }

  void updateFilter(String filter) {
    selectedFilter.value = filter;
  }

  void clearSelection() {
    selectedPackage.value = null;
  }

  List<Package> get filteredPackages {
    var filtered = packages.where((package) {
      final matchesSearch = searchQuery.value.isEmpty ||
          (package.packageName
                  ?.toLowerCase()
                  .contains(searchQuery.value.toLowerCase()) ??
              false);

      bool matchesFilter = true;
      if (selectedFilter.value != 'all') {
        switch (selectedFilter.value) {
          case 'web':
            matchesFilter = package.ifWebpanel == '1';
            break;
          case 'mobile':
            matchesFilter = package.ifAndroid == '1' || package.ifIos == '1';
            break;
          case 'multistore':
            matchesFilter = package.ifMultistore == '1';
            break;
        }
      }

      return matchesSearch && matchesFilter;
    }).toList();

    return filtered;
  }

  Future<void> purchasePackage(Package package) async {
    try {
      isLoading.value = true;
      
      final authController = Get.find<AuthController>();
      final mobile = authController.user.value?.phone ?? '';

      if (mobile.isEmpty) {
        Get.snackbar(
          'Error', 
          'Mobile number not found',
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
        return;
      }

      final url = 'https://greenbiller.in/paynow/$mobile/${package.id}';
      
      // For now, show success message with URL info
      Get.snackbar(
        'Package Selected',
        'Payment URL: $url\n\nPackage: ${package.packageName}\nPrice: ${package.displayPrice}',
        backgroundColor: Colors.green,
        colorText: Colors.white,
        duration: const Duration(seconds: 5),
      );
      
    } catch (e) {
      Get.snackbar(
        'Error', 
        'Something went wrong: $e',
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } finally {
      isLoading.value = false;
    }
  }
}

class Package {
  final String id;
  final String? packageName;
  final String? price;
  final String? ifWebpanel;
  final String? ifAndroid;
  final String? ifIos;
  final String? ifMultistore;
  final String? pricePerStore;
  final String? description;

  Package({
    required this.id,
    this.packageName,
    this.price,
    this.ifWebpanel,
    this.ifAndroid,
    this.ifIos,
    this.ifMultistore,
    this.pricePerStore,
    this.description,
  });

  // Helper methods for UI
  bool get hasWebPanel => ifWebpanel == '1';
  bool get hasAndroid => ifAndroid == '1';
  bool get hasIos => ifIos == '1';
  bool get hasMultistore => ifMultistore == '1';
  bool get hasMobileApps => hasAndroid || hasIos;
  
  String get displayPrice => price != null ? '₹$price' : 'Contact for price';
  
  String get pricePerStoreDisplay => 
      pricePerStore != null ? '₹$pricePerStore per store' : '';

  List<String> get features {
    List<String> featureList = [];
    
    if (hasWebPanel) featureList.add('Web Panel Access');
    if (hasAndroid) featureList.add('Android Application');
    if (hasIos) featureList.add('iOS Application');
    if (hasMultistore) featureList.add('Multi-Store Support');
    
    // Add common features
    featureList.addAll([
      'Inventory Management',
      'Sales Analytics',
      'Customer Management',
      'Invoice Generation',
      'Reports & Analytics',
      '24/7 Support',
    ]);
    
    return featureList;
  }
}
