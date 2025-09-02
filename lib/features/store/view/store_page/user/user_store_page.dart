// lib/features/store/view/user/user_store_page.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:green_biller/core/constants/colors.dart';
import 'package:green_biller/features/auth/login/model/user_model.dart';
import 'package:green_biller/features/store/model/user_role_model.dart';
import 'package:green_biller/features/store/view/store_page/shared/store_card.dart';
import 'package:green_biller/features/store/view/store_page/shared/ware_house_card.dart';

class UserStorePage extends ConsumerWidget {
  const UserStorePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(userProvider);

    if (user == null ||
        user.user?.userLevel == null ||
        user.user?.storeId == null) {
      return const Scaffold(
        body: Center(child: Text('Store information not available')),
      );
    }

    // We'll implement data fetching later
    const store = null; // Fetch single store based on user.storeId
    final warehouses = []; // Fetch warehouses for user.storeId

    if (store == null) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: Text(store.name),
          backgroundColor: cardColor,
          foregroundColor: textPrimaryColor,
          bottom: const TabBar(
            tabs: [
              Tab(text: 'Details'),
              Tab(text: 'Warehouses'),
            ],
            labelColor: accentColor,
            unselectedLabelColor: textSecondaryColor,
            indicatorColor: accentColor,
          ),
          actions: [
            // Only show edit button if user has permission
            if (user.user?.userLevel == UserRoleModel.storeAdmin.level)
              IconButton(
                icon: const Icon(Icons.edit),
                onPressed: () {
                  // Edit store
                },
              ),
          ],
        ),
        body: TabBarView(
          children: [
            // Store Details Tab
            const SingleChildScrollView(
              padding: EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  StoreCard(store: store),
                  SizedBox(height: 16),
                  // Add more store details here
                ],
              ),
            ),

            // Warehouses Tab
            warehouses.isEmpty
                ? const Center(child: Text('No warehouses found'))
                : ListView.builder(
                    itemCount: warehouses.length,
                    itemBuilder: (context, index) {
                      return WarehouseCard(
                        warehouse: warehouses[index],
                        onTap: () {},
                        canEdit: user.user?.userLevel ==
                            UserRoleModel.storeAdmin.level,
                      );
                    },
                  ),
          ],
        ),
      ),
    );
  }
}
