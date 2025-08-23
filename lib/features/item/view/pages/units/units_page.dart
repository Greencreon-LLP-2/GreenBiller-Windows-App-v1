import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:green_biller/core/constants/colors.dart';
import 'package:green_biller/core/theme/text_styles.dart';
import 'package:green_biller/features/auth/login/model/user_model.dart';
import 'package:green_biller/features/item/controller/unit_controller.dart';
import 'package:green_biller/features/item/model/unit/unit_model.dart';
import 'package:green_biller/features/item/services/unit/view_unit_service.dart';
import 'package:green_biller/features/store/controllers/view_store_controller.dart';
import 'package:green_biller/features/store/model/store_model/store_model.dart'
    as store_model;
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:hooks_riverpod/legacy.dart';

final refreshTriggerProvider = StateProvider<int>((ref) => 0);

class UnitsPage extends HookConsumerWidget {
  const UnitsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(userProvider);
    final accessToken = user?.accessToken;
    final isLoading = useState(false);

    if (accessToken == null) {
      return const Scaffold(
        body: Center(
          child: Text(
            'Please login to view units',
            style: TextStyle(
              color: textSecondaryColor,
              fontSize: 16,
            ),
          ),
        ),
      );
    }

    final viewUnitController = UnitController(accessToken: accessToken);

    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        title: const Text('Units'),
        backgroundColor: accentColor,
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header Section
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: cardColor,
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
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
                    child: const Icon(
                      Icons.straighten,
                      color: accentColor,
                      size: 24,
                    ),
                  ),
                  const SizedBox(width: 16),
                  const Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Units',
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: textPrimaryColor,
                        ),
                      ),
                      SizedBox(height: 4),
                      Text(
                        'Manage your measurement units',
                        style: TextStyle(
                          fontSize: 14,
                          color: textSecondaryColor,
                        ),
                      ),
                    ],
                  ),
                  const Spacer(),
                  // TextButton(
                  //   onPressed: () => _showAddUnitDialog(context, ref),
                  //   style: TextButton.styleFrom(
                  //     backgroundColor: accentColor,
                  //     padding: const EdgeInsets.symmetric(
                  //         horizontal: 24, vertical: 12),
                  //     shape: RoundedRectangleBorder(
                  //       borderRadius: BorderRadius.circular(30),
                  //     ),
                  //   ),
                  //   child: Text(
                  //     "Add New Unit",
                  //     style: AppTextStyles.labelMedium.copyWith(
                  //       fontWeight: FontWeight.bold,
                  //       color: Colors.white,
                  //       fontSize: 20,
                  //     ),
                  //   ),
                  // ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // Units Table
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  color: cardColor,
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.05),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    // Table Header
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: const BoxDecoration(
                        color: backgroundColor,
                        borderRadius: BorderRadius.vertical(
                          top: Radius.circular(12),
                        ),
                      ),
                      child: const Row(
                        children: [
                          SizedBox(width: 48), // Icon space
                          Expanded(
                            flex: 2,
                            child: Text(
                              'Unit Name',
                              style: TextStyle(
                                fontWeight: FontWeight.w600,
                                color: textPrimaryColor,
                              ),
                            ),
                          ),
                          Expanded(
                            flex: 2,
                            child: Text(
                              'Unit Value',
                              style: TextStyle(
                                fontWeight: FontWeight.w600,
                                color: textPrimaryColor,
                              ),
                            ),
                          ),
                          Expanded(
                            flex: 3,
                            child: Text(
                              'Description',
                              style: TextStyle(
                                fontWeight: FontWeight.w600,
                                color: textPrimaryColor,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),

                    // Table Content
                    Expanded(
                      child: Consumer(builder: (context, ref, _) {
                        final refreshTrigger =
                            ref.watch(refreshTriggerProvider);
                        return FutureBuilder<UnitModel>(
                          future: viewUnitController.getUnitData(),
                          builder: (context, snapshot) {
                            if (snapshot.connectionState ==
                                ConnectionState.waiting) {
                              return const Center(
                                child: CircularProgressIndicator(
                                  color: accentColor,
                                ),
                              );
                            }

                            if (snapshot.hasError) {
                              return Center(
                                child: Text(
                                  'Error: ${snapshot.error}',
                                  style: const TextStyle(color: Colors.red),
                                ),
                              );
                            }

                            if (!snapshot.hasData ||
                                snapshot.data?.data == null ||
                                snapshot.data!.data!.isEmpty) {
                              return const Center(
                                child: Text(
                                  'No units found',
                                  style: TextStyle(
                                    color: textSecondaryColor,
                                    fontSize: 16,
                                  ),
                                ),
                              );
                            }

                            return ListView.builder(
                              itemCount: snapshot.data!.data!.length,
                              itemBuilder: (context, index) {
                                final unit = snapshot.data!.data![index];
                                const unitStatus = true;
                                return Container(
                                  padding: const EdgeInsets.all(16),
                                  decoration: const BoxDecoration(
                                    border: Border(
                                      bottom: BorderSide(
                                        color: textLightColor,
                                        width: 1,
                                      ),
                                    ),
                                  ),
                                  child: Row(
                                    children: [
                                      Container(
                                        padding: const EdgeInsets.all(8),
                                        decoration: BoxDecoration(
                                          color:
                                              textPrimaryColor.withOpacity(0.1),
                                          borderRadius:
                                              BorderRadius.circular(8),
                                        ),
                                        child: const Icon(
                                          Icons.straighten,
                                          color: accentColor,
                                          size: 24,
                                        ),
                                      ),
                                      const SizedBox(width: 16),
                                      Expanded(
                                        flex: 2,
                                        child: Text(
                                          unit.unitName ?? 'N/A',
                                          style: const TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.w500,
                                            color: textPrimaryColor,
                                          ),
                                        ),
                                      ),
                                      Expanded(
                                        flex: 2,
                                        child: Text(
                                          unit.unitValue ?? 'N/A',
                                          style: const TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.w500,
                                            color: textPrimaryColor,
                                          ),
                                        ),
                                      ),
                                      Expanded(
                                        flex: 3,
                                        child: Text(
                                          unit.description ??
                                              'No description available',
                                          style: const TextStyle(
                                            color: textSecondaryColor,
                                            fontSize: 14,
                                          ),
                                          textAlign: TextAlign.start,
                                        ),
                                      ),
                                      Row(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          // Status container
                                          Container(
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: 8, vertical: 4),
                                            decoration: BoxDecoration(
                                              color: unit.status == '1'
                                                  ? Colors.green
                                                      .withOpacity(0.1)
                                                  : Colors.red.withOpacity(0.1),
                                              borderRadius:
                                                  BorderRadius.circular(12),
                                            ),
                                            child: Row(
                                              mainAxisSize: MainAxisSize.min,
                                              children: [
                                                Container(
                                                  height: 6,
                                                  width: 6,
                                                  decoration: BoxDecoration(
                                                    color: unitStatus == true
                                                        ? Colors.green
                                                        : Colors.red,
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            3),
                                                  ),
                                                ),
                                                const SizedBox(width: 4),
                                                Text(
                                                  unitStatus == true
                                                      ? 'Active'
                                                      : 'Inactive',
                                                  style: TextStyle(
                                                    fontSize: 11,
                                                    fontWeight: FontWeight.w600,
                                                    color: unitStatus == true
                                                        ? Colors.green.shade700
                                                        : Colors.red.shade700,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                       
                                          // Action Buttons
                                          // Container(
                                          //   decoration: BoxDecoration(
                                          //     color:
                                          //         Colors.red.withOpacity(0.1),
                                          //     borderRadius:
                                          //         BorderRadius.circular(50),
                                          //   ),
                                          //   child: IconButton(
                                          //     tooltip: 'Delete',
                                          //     icon: const Icon(
                                          //         Icons.delete_outline,
                                          //         size: 20,
                                          //         color: Colors.red),
                                          //     onPressed: () async {
                                          //       // Show confirmation dialog
                                          //       final shouldDelete =
                                          //           await showDialog<bool>(
                                          //         context: context,
                                          //         builder: (context) =>
                                          //             AlertDialog(
                                          //           shape:
                                          //               RoundedRectangleBorder(
                                          //                   borderRadius:
                                          //                       BorderRadius
                                          //                           .circular(
                                          //                               16)),
                                          //           title: const Text(
                                          //               'Delete Store'),
                                          //           content: Text(
                                          //               'Are you sure you want to delete "${unit.unitName}"?'),
                                          //           actions: [
                                          //             TextButton(
                                          //               onPressed: () =>
                                          //                   Navigator.of(
                                          //                           context)
                                          //                       .pop(false),
                                          //               child: const Text(
                                          //                   'Cancel'),
                                          //             ),
                                          //             FilledButton(
                                          //               onPressed: () =>
                                          //                   Navigator.of(
                                          //                           context)
                                          //                       .pop(true),
                                          //               style: FilledButton
                                          //                   .styleFrom(
                                          //                       backgroundColor:
                                          //                           Colors.red),
                                          //               child: const Text(
                                          //                   'Delete'),
                                          //             ),
                                          //           ],
                                          //         ),
                                          //       );

                                          //       if (shouldDelete == true) {
                                          //         isLoading.value = true;
                                          //         final viewUnitService =
                                          //             ViewUnitService(
                                          //                 accessToken:
                                          //                     accessToken);
                                          //         final response =
                                          //             await viewUnitService
                                          //                 .deleteUnitSerivce(
                                          //                     unit.id!);
                                          //         if (response == 200) {
                                          //           isLoading.value = false;
                                          //           ScaffoldMessenger.of(
                                          //                   context)
                                          //               .showSnackBar(
                                          //             SnackBar(
                                          //               content: const Text(
                                          //                   "Store deleted successfully"),
                                          //               backgroundColor:
                                          //                   Colors.green,
                                          //               behavior:
                                          //                   SnackBarBehavior
                                          //                       .floating,
                                          //               shape: RoundedRectangleBorder(
                                          //                   borderRadius:
                                          //                       BorderRadius
                                          //                           .circular(
                                          //                               10)),
                                          //             ),
                                          //           );
                                          //           Future.delayed(
                                          //               const Duration(
                                          //                   seconds: 3), () {
                                          //             ref.refresh(
                                          //                 storesProvider);
                                          //           });
                                          //         } else {
                                          //           isLoading.value = false;
                                          //           ScaffoldMessenger.of(
                                          //                   context)
                                          //               .showSnackBar(
                                          //             SnackBar(
                                          //               content: const Text(
                                          //                   "Failed to delete store"),
                                          //               backgroundColor:
                                          //                   Colors.red,
                                          //               behavior:
                                          //                   SnackBarBehavior
                                          //                       .floating,
                                          //               shape: RoundedRectangleBorder(
                                          //                   borderRadius:
                                          //                       BorderRadius
                                          //                           .circular(
                                          //                               10)),
                                          //             ),
                                          //           );
                                          //         }
                                          //       }
                                          //     },
                                          //   ),
                                          // ),
                                       
                                        ],
                                      ),
                                    ],
                                  ),
                                );
                              },
                            );
                          },
                        );
                      }),
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

  void _showAddUnitDialog(BuildContext context, WidgetRef ref) {
    final unitNameController = TextEditingController();
    final unitValueController = TextEditingController();

    final descriptionController = TextEditingController();

    final storeIdNotifier = ValueNotifier<int?>(null);
    final storesAsync = ref.watch(storesProvider);
    final isLoading = ValueNotifier<bool>(false);
    final accessToken = ref.read(userProvider)?.accessToken;
    final userId = ref.read(userProvider)?.user?.id.toString();

    if (accessToken == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Authentication required'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    final service = ViewUnitService(accessToken: accessToken);
    final formKey = GlobalKey<FormState>();

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog.adaptive(
          title: const Text(
            'Add New Unit',
            style: TextStyle(color: textPrimaryColor),
          ),
          content: SingleChildScrollView(
            child: Form(
              key: formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Store dropdown
                  ValueListenableBuilder<int?>(
                    valueListenable: storeIdNotifier,
                    builder: (context, selectedStoreId, child) {
                      return DropdownButtonFormField<int?>(
                        value: selectedStoreId,
                        decoration: InputDecoration(
                          labelText: 'Select Store*',
                          labelStyle:
                              const TextStyle(color: textSecondaryColor),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        hint: const Text('Choose store'),
                        items: storesAsync.when(
                          loading: () => [
                            const DropdownMenuItem<int?>(
                              value: null,
                              child: SizedBox(
                                height: 24,
                                child:
                                    Center(child: CircularProgressIndicator()),
                              ),
                            )
                          ],
                          error: (e, _) => [
                            const DropdownMenuItem<int?>(
                              value: null,
                              child: Text('Failed to load stores'),
                            )
                          ],
                          data: (storeModel) {
                            final List<store_model.StoreData>? stores =
                                storeModel.data;
                            if (stores == null || stores.isEmpty) {
                              return [
                                const DropdownMenuItem<int?>(
                                  value: null,
                                  child: Text('No stores available'),
                                )
                              ];
                            }
                            return stores
                                .map((store) => DropdownMenuItem<int?>(
                                      value: store.id,
                                      child: Text(
                                          store.storeName ?? 'Unnamed Store'),
                                    ))
                                .toList();
                          },
                        ),
                        onChanged: (val) => storeIdNotifier.value = val,
                        validator: (value) =>
                            value == null ? 'Please select a store' : null,
                      );
                    },
                  ),

                  const SizedBox(height: 12),
                  TextFormField(
                    controller: unitNameController,
                    decoration: InputDecoration(
                      labelText: 'Unit Name*',
                      hintText: 'Enter unit name',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    validator: (value) =>
                        value?.isEmpty ?? true ? 'Unit name is required' : null,
                  ),
                  const SizedBox(height: 12),
                  TextFormField(
                    controller: unitValueController,
                    decoration: InputDecoration(
                      labelText: 'Unit Value*',
                      hintText: 'Enter unit value',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    keyboardType: TextInputType.number,
                    validator: (value) {
                      if (value?.isEmpty ?? true) {
                        return 'Unit value is required';
                      }
                      if (double.tryParse(value!) == null) {
                        return 'Enter a valid number';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 12),
                  TextFormField(
                    controller: descriptionController,
                    decoration: InputDecoration(
                      labelText: 'Description*',
                      hintText: 'Enter description',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    maxLines: 2,
                    validator: (value) => value?.isEmpty ?? true
                        ? 'Description is required'
                        : null,
                  ),
                ],
              ),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel',
                  style: TextStyle(color: textSecondaryColor)),
            ),
            ValueListenableBuilder<bool>(
              valueListenable: isLoading,
              builder: (context, isProcessing, child) {
                return ElevatedButton(
                  onPressed: isProcessing
                      ? null
                      : () async {
                          if (!formKey.currentState!.validate()) {
                            return;
                          }

                          if (userId == null) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('Authentication required'),
                                backgroundColor: Colors.red,
                              ),
                            );
                            return;
                          }

                          isLoading.value = true;
                          try {
                            final payload = {
                              'store_id': storeIdNotifier.value!.toString(),
                              'parent_id': null,
                              'unit_name': unitNameController.text,
                              'unit_value': unitValueController.text,
                              'description': descriptionController.text,
                              'user_id': userId,
                            };

                            final response =
                                await service.addUnitService(payload);

                            if (context.mounted) {
                              isLoading.value = false;
                              if (response ==
                                  "Units Detail Created Successfully") {
                                ref
                                    .read(refreshTriggerProvider.notifier)
                                    .state++;
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text('Unit added successfully'),
                                    backgroundColor: Colors.green,
                                  ),
                                );
                                Navigator.pop(context);
                              } else {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content:
                                        Text(response ?? 'Failed to add unit'),
                                    backgroundColor: Colors.red,
                                  ),
                                );
                              }
                            }
                          } catch (e) {
                            if (context.mounted) {
                              isLoading.value = false;
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text('Error: ${e.toString()}'),
                                  backgroundColor: Colors.red,
                                ),
                              );
                            }
                          }
                        },
                  style: ElevatedButton.styleFrom(backgroundColor: accentColor),
                  child: isProcessing
                      ? const SizedBox(
                          width: 16,
                          height: 16,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: Colors.white,
                          ),
                        )
                      : const Text('Add'),
                );
              },
            ),
          ],
        );
      },
    ).then((_) {
      // Clean up controllers when dialog is closed
      unitNameController.dispose();
      unitValueController.dispose();

      descriptionController.dispose();
      storeIdNotifier.dispose();
      isLoading.dispose();
    });
  }
}
