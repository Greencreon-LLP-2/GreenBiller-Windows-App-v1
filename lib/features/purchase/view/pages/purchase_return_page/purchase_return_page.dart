import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:go_router/go_router.dart';
import 'package:green_biller/core/constants/colors.dart';
import 'package:green_biller/features/auth/login/model/user_model.dart';
import 'package:green_biller/features/purchase/models/purcahse_single_all_deatils.dart';
import 'package:green_biller/features/purchase/services/purchase_view_service.dart';
import 'package:green_biller/features/purchase/view/pages/purchase_page/prucahse_widgets/purchase_table_data_cell_widget.dart';
import 'package:green_biller/features/purchase/view/pages/purchase_page/prucahse_widgets/purchase_table_header_widget.dart';
import 'package:green_biller/features/purchase/view/pages/purchase_return_page/purcahse_return_widgets/purchase_return_bottom_section.dart';
import 'package:green_biller/features/purchase/view/pages/purchase_return_page/purcahse_return_widgets/purchase_return_topsection_widget.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:intl/intl.dart';

class PurchaseReturnPage extends HookConsumerWidget {
  final String purcahseId;
  const PurchaseReturnPage({super.key, required this.purcahseId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(userProvider);
    final userId = user?.user?.id?.toString();
    if (userId == null) {
      return const Scaffold(
        body: Center(child: Text('Access Denied')),
      );
    }
    final currentPurchaseData = useState<PurcahseSingleAllDeatils?>(null);
    final isLoadingDate = useState(false);
    final returnDateController = useTextEditingController(
        text: DateFormat('yyyy-MM-dd').format(DateTime.now()));
    final returnNoController = useTextEditingController();
    final purchaseNoteController = useTextEditingController();
    final otherChargesController = useTextEditingController();
    final itemsList = useState<List<PurchaseItem>>([]);
    final tempSubTotal = useState<double>(0.0);
    final userModel = ref.watch(userProvider);
    final accessToken = userModel?.accessToken;
    final returnQtyControllers = useRef(<int, TextEditingController>{});

    // Initialize controllers for return quantities
    useEffect(() {
      for (var i = 0; i < itemsList.value.length; i++) {
        returnQtyControllers.value[i] = TextEditingController(text: '0');
      }
      return null;
    }, [itemsList.value]);

    void getItemDataById() async {
      try {
        isLoadingDate.value = true;
        currentPurchaseData.value = await PurchaseViewService()
            .getPurchaseViewByIdService(accessToken!, purcahseId);
        if (currentPurchaseData.value != null) {
          itemsList.value = currentPurchaseData.value!.items;
          print(currentPurchaseData.value!.items.length);
        }
      } catch (e) {
        print(e);
      } finally {
        isLoadingDate.value = false;
      }
    }

    useEffect(() {
      if (accessToken != null) {
        getItemDataById();
      }
      return null;
    }, [purcahseId]);

    double recalculateGrandTotal() {
      double sum = 0.0;
      for (int i = 0; i < itemsList.value.length; i++) {
        final item = itemsList.value[i];
        final returnQty =
            double.tryParse(returnQtyControllers.value[i]?.text ?? '0') ?? 0;
        final price = double.tryParse(item.unitSalesPrice ?? '0') ?? 0;
        final amount = returnQty * price;
        sum += amount;
      }
      tempSubTotal.value = sum;
      return sum;
    }

    void handleSave() async {
      try {
        // Check if there's a current purchase
        if (currentPurchaseData.value == null) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('No purchase data available')),
          );
          return;
        }

        // Prepare return items and calculate total return amount
        final returnItems = <Map<String, dynamic>>[];
        final purchase = currentPurchaseData.value!;
        double totalReturnAmount = 0.0;

        for (int i = 0; i < itemsList.value.length; i++) {
          final returnQty =
              double.tryParse(returnQtyControllers.value[i]?.text ?? '0') ?? 0;
          if (returnQty > 0) {
            final item = itemsList.value[i];
            final itemAmount =
                returnQty * (double.tryParse(item.unitSalesPrice ?? '0') ?? 0);
            totalReturnAmount += itemAmount;
            if (otherChargesController.text.isNotEmpty &&
                double.tryParse(otherChargesController.text) != 0) {
              totalReturnAmount +=
                  double.tryParse(otherChargesController.text) ?? 0;
            }
            returnItems.add({
              'store_id': purchase.storeId,
              'purchase_id': purchase.id,
              'item_id': item.itemId,
              'return_qty': returnQty.toString(),
              'price_per_unit': item.unitSalesPrice,
              'tax_type': item.taxType,
              'tax_id': item.taxId,
              'tax_amt': item.taxAmt,
              'discount_type': item.discountType,
              'discount_input': item.discountInput,
              'discount_amt': item.discountAmt,
              'unit_total_cost': item.unitTotalCost,
              'total_cost': itemAmount.toString(),
              'profit_margin_per': item.profitMarginPer,
              'unit_sales_price': item.unitSalesPrice,
              'stock': item.stock,
              'if_batch': item.ifBatch,
              'batch_no': item.batchNo,
              'if_expirydate': item.ifExpiryDate,
              'expire_date': item.expireDate,
              'description': item.description,
              'status': 'active',
            });
          }
        }

        if (returnItems.isEmpty) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
                content:
                    Text('Please add at least 1 return quantity to proceed')),
          );
          return;
        }

        // 1. First create the main purchase return
        final returnData = {
          'store_id': purchase.storeId,
          'warehouse_id': purchase.warehouseId,
          'purchase_id': purchase.id,
          'return_code': 'RTN-${DateTime.now().millisecondsSinceEpoch}',
          'reference_no': returnNoController.text.isNotEmpty
              ? returnNoController.text
              : 'RTN-REF-${DateTime.now().millisecondsSinceEpoch}',
          'return_date': returnDateController.text,
          'supplier_id': purchase.supplierId,
          'subtotal': totalReturnAmount.toString(),
          'grand_total': totalReturnAmount.toString(),
          'return_note': purchaseNoteController.text,
          'payment_status': totalReturnAmount > 0 ? 'pending' : 'completed',
          'paid_amount': '0',
          'created_by': userId,
        };

        final returnResponse =
            await PurchaseViewService().createPurchaseReturnService(
          accessToken!,
          returnData,
        );

        final returnId = returnResponse.id;

        // 2. Create purchase item returns
        for (final item in returnItems) {
          // Add return_id to each item
          final itemData = {...item, 'return_id': returnId};

          try {
            await PurchaseViewService().createPurchaseItemReturnService(
              accessToken,
              itemData,
            );
          } catch (e) {
            print('Error creating item return: $e');
            // Continue with other items even if one fails
          }
        }

        // 3. Create purchase payment return if there's a return amount
        if (totalReturnAmount > 0) {
          // Get payment type from current purchase's payments
          String paymentType = 'Cash'; // default
          if (purchase.payments.isNotEmpty) {
            paymentType = purchase.payments.first.paymentType ?? 'Cash';
          }

          final paymentData = {
            'store_id': purchase.storeId,
            'purchase_id': purchase.id,
            'return_id': returnId,
            'payment_code': 'PAY-RTN-${DateTime.now().millisecondsSinceEpoch}',
            'payment_date': returnDateController.text,
            'payment_type': paymentType,
            'payment': totalReturnAmount,
            'payment_note': 'Return payment for purchase #${purchase.id}',
            'status': 'completed',
            'supplier_id': purchase.supplierId,
            'created_by': userId,
            'account_id': 0
          };

          try {
            await PurchaseViewService().createPurchasePaymentReturnService(
              accessToken,
              paymentData,
            );
          } catch (e) {
            print('Error creating payment return: $e');
          }
        }

        // Show success message
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text(
              'Purchase return created successfully',
              style: TextStyle(color: Colors.white),
            ),
            backgroundColor: Colors.green,
          ),
        );
        Future.delayed(
            const Duration(seconds: 3), () => context.go('/homepage'));
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error creating purchase return: $e')),
        );
        print('Error creating purchase return: $e');
      }
    }

    if (isLoadingDate.value) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(70),
        child: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [accentColor, accentColor.withOpacity(0.8)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            boxShadow: [
              BoxShadow(
                color: accentColor.withOpacity(0.3),
                blurRadius: 10,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: AppBar(
            // leading: IconButton(
            //   onPressed: () => context.go('/homepage'),
            //   icon: const Icon(Icons.arrow_back_ios_new),
            // ),
            backgroundColor: Colors.transparent,
            elevation: 0,
            centerTitle: false,
            title: const Text(
              'Purchase Return',
              style: TextStyle(
                color: Colors.white,
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
      ),
      body: Container(
        margin: const EdgeInsets.all(12),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.green.shade50,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.green.withOpacity(0.2),
              blurRadius: 12,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              PurchaseReturnTopsectionWidget(
                returnBillController: returnNoController,
                returnDateController: returnDateController,
                billNo: currentPurchaseData.value?.id.toString() ?? '',
                store: currentPurchaseData.value?.storeName ?? '',
                supplier: currentPurchaseData.value?.supplierName ?? '',
                warehouse: currentPurchaseData.value?.warehouseName ?? '',
                isLoadingStores: isLoadingDate,
                isLoadingWarehouses: useState(false),
                isLoadingSuppliers: useState(false),
              ),
              const SizedBox(height: 16),
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                child: Text(
                  "Purchase Items",
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        color: Colors.green.shade800,
                        fontWeight: FontWeight.bold,
                      ),
                ),
              ),
              const SizedBox(height: 8),
              SizedBox(
                child: LayoutBuilder(builder: (context, constraints) {
                  const columnCount = 5;
                  const itemFlex = 3;
                  const otherFlex = 1;
                  const totalFlex = itemFlex + (columnCount - 1) * otherFlex;
                  final baseColumnWidth = constraints.maxWidth / totalFlex;
                  final itemColumnWidth = baseColumnWidth * itemFlex * 0.9;

                  return ConstrainedBox(
                    constraints: BoxConstraints(minWidth: constraints.maxWidth),
                    child: SingleChildScrollView(
                      scrollDirection: Axis.vertical,
                      child: Column(
                        children: [
                          Container(
                            color: Colors.green.shade200,
                            child: Row(
                              children: [
                                HeaderCellWidget(
                                    text: "S.No", width: baseColumnWidth),
                                HeaderCellWidget(
                                    text: "Item", width: itemColumnWidth),
                                HeaderCellWidget(
                                    text: "Price", width: baseColumnWidth),
                                HeaderCellWidget(
                                    text: "Purchased Qty",
                                    width: baseColumnWidth),
                                HeaderCellWidget(
                                    text: "Return Qty", width: baseColumnWidth),
                              ],
                            ),
                          ),
                          ...List.generate(
                            itemsList.value.length,
                            (index) {
                              final item = itemsList.value[index];
                              return Container(
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  border: Border(
                                    bottom: BorderSide(
                                        color: Colors.green.shade100),
                                    left: BorderSide(
                                        color: Colors.green.shade100),
                                    right: BorderSide(
                                        color: Colors.green.shade100),
                                  ),
                                ),
                                child: Row(
                                  children: [
                                    DataCellWidget(
                                      width: baseColumnWidth,
                                      child: Text("${index + 1}"),
                                    ),
                                    DataCellWidget(
                                      width: itemColumnWidth,
                                      child: Text(item.itemName ?? ''),
                                    ),
                                    DataCellWidget(
                                      width: baseColumnWidth,
                                      child: Text(item.unitSalesPrice ?? '0'),
                                    ),
                                    DataCellWidget(
                                      width: baseColumnWidth,
                                      child: Text(item.purchaseQty ?? '0'),
                                    ),
                                    DataCellWidget(
                                      width: baseColumnWidth,
                                      child: TextField(
                                          controller:
                                              returnQtyControllers.value[index],
                                          keyboardType: TextInputType.number,
                                          style: const TextStyle(fontSize: 14),
                                          decoration: const InputDecoration(
                                            isDense: true,
                                            contentPadding:
                                                EdgeInsets.symmetric(
                                                    horizontal: 8, vertical: 6),
                                            border: InputBorder.none,
                                          ),
                                          onChanged: (value) {
                                            if (int.parse(item.purchaseQty!) <
                                                int.parse(value)) {
                                              returnQtyControllers
                                                  .value[index]!.text = '0';
                                              ScaffoldMessenger.of(context)
                                                  .showMaterialBanner(
                                                MaterialBanner(
                                                  backgroundColor: Colors.red,
                                                  content: const Text(
                                                      'Return qty cant be larger than Purcahse qty'),
                                                  leading:
                                                      const Icon(Icons.info),
                                                  actions: [
                                                    TextButton(
                                                      onPressed: () {
                                                        ScaffoldMessenger.of(
                                                                context)
                                                            .hideCurrentMaterialBanner();
                                                      },
                                                      child:
                                                          const Text('DISMISS'),
                                                    ),
                                                  ],
                                                ),
                                              );
                                            }
                                            recalculateGrandTotal();
                                          }),
                                    ),
                                  ],
                                ),
                              );
                            },
                          ),
                        ],
                      ),
                    ),
                  );
                }),
              ),
              PurchaseReturnBottomSection(
                subTotal: tempSubTotal.value,
                totalDiscount: 0.0,
                otherChargesController: otherChargesController,
                purchaseNoteController: purchaseNoteController,
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Container(
            margin: const EdgeInsets.only(right: 10),
            decoration: BoxDecoration(
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.3),
                  blurRadius: 10,
                  offset: const Offset(2, 8),
                )
              ],
            ),
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color.fromARGB(255, 52, 177, 104),
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                padding: const EdgeInsets.symmetric(
                  horizontal: 30,
                  vertical: 20,
                ),
              ),
              onPressed: () {},
              child: const Text("Save & Print"),
            ),
          ),
          Container(
            decoration: BoxDecoration(
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.3),
                  blurRadius: 10,
                  offset: const Offset(2, 8),
                )
              ],
            ),
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: accentColor,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                padding: const EdgeInsets.symmetric(
                  horizontal: 30,
                  vertical: 20,
                ),
              ),
              onPressed: handleSave,
              child: const Text("Save"),
            ),
          ),
        ],
      ),
    );
  }
}
