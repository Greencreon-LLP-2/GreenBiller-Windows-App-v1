import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:greenbiller/core/colors.dart';
import 'package:greenbiller/core/gloabl_widgets/sidebar/admin_sidebar.dart';


class StoreAdminEntryPoint extends StatelessWidget {
  const StoreAdminEntryPoint({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(StoreAdminController());
    final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

    return Scaffold(
      key: scaffoldKey,
  drawer: AdminSidebar(),
      body: Row(
        children: [         
          Expanded(
            child: Column(
              children: [
              
                Container(
                  height: 64,
                  color: accentColor,
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  child: Row(
                    children: [
                      IconButton(
                        icon: const Icon(Icons.menu),
                        color: Colors.white,
                        onPressed: () => scaffoldKey.currentState?.openDrawer(),
                      ),
                      const SizedBox(width: 8),
                      Text(
                          'Admin Dashboard',
                          style: TextStyle(
                          fontWeight: FontWeight.w700,
                          fontSize: 18,
                          color: Colors.white,
                        ),
                      ),
                      const Spacer(),
                      
                    ],
                  ),
                ),
                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                    
                        Container(
                          width: double.infinity,
                          padding: const EdgeInsets.symmetric(vertical: 18, horizontal: 12),
                          decoration: BoxDecoration(
                            color: accentLightColor,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Obx(() => Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  overviewCardLarge(Icons.trending_up, "Today's Sale",
                                      "₹ ${controller.todaySale}",Colors.green),
                                  overviewCardLarge(Icons.warning_amber_rounded,
                                      "Due Amount", "₹ ${controller.dueAmount}", Colors.orange),
                                  overviewCardLarge(Icons.inventory_2_outlined,
                                      "Total Items", "${controller.totalItems}",Colors.blue),
                                  overviewCardLarge(Icons.people_alt_outlined,
                                      "Customers", "${controller.customers}",Colors.purple),
                                ],
                              )),
                        ),
                        const SizedBox(height: 20),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(
                              flex: 2,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                   Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      const Text(
                                        "Quick Actions",
                                        style: TextStyle(
                                            fontWeight: FontWeight.w700,
                                            fontSize: 17),
                                      ),
                                      TextButton(
                                        onPressed: () {
                                         
                                        },
                                        child: Text(
                                          "View All",
                                          style: TextStyle(color: Colors.green),
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 12),
                  GridView.count(
                  shrinkWrap: true,
                  crossAxisCount: 2,
                  mainAxisSpacing: 18,
                  crossAxisSpacing: 18,
                  childAspectRatio: 2.1,
                  physics: const NeverScrollableScrollPhysics(),
                  children: [
                    quickActionTileGradient(Icons.add, "New Sale",
                      Colors.green, Colors.greenAccent),
                    quickActionTileGradient(Icons.sync_alt,
                      "Transactions", Colors.blue, Colors.lightBlueAccent),
                    quickActionTileGradient(Icons.bar_chart,
                      "Reports", Colors.purple, Colors.deepPurpleAccent),
                    quickActionTileGradient(Icons.settings,
                      "Settings", Colors.blueGrey, Colors.grey),
                  ],
                  ),
                                ],
                              ),
                            ),
                            const SizedBox(width: 20),
                            Expanded(
                              flex: 3,
                              child: SingleChildScrollView(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                   
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                      
                                        const Text(
                                          "   Recent Transactions",
                                          style: TextStyle(
                                              fontWeight: FontWeight.w700,
                                              fontSize: 17),
                                        ),
                                        TextButton(
                                          onPressed: () {
                                           
                                          },
                                          child: Text(
                                            "View All",
                                            style: TextStyle(color: Colors.green),
                                          ),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 12),
                                    Obx(() => SingleChildScrollView(
                                      child: Column(
                                            children: controller.transactions
                                                .map((txn) => transactionCard(
                                                      txn["customer"]!,
                                                      txn["invoice"]!,
                                                      txn["status"]!,
                                                      txn["date"]!,
                                                      txn["amount"]!,
                                                    ))
                                                .toList(),
                                          ),
                                    )),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }



  Widget overviewCardLarge(IconData icon, String title, String value,Color iconColor) {
    return Expanded(
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 6),
        padding: const EdgeInsets.symmetric(horizontal: 18, 
        vertical: 16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.04),
              blurRadius: 12,
              offset: const Offset(0, 8),
            )
          ],
        ),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                   
                    child: Icon(icon, color: iconColor, size: 22),
                  ),
                  const SizedBox(width: 12),
                  Expanded(child: Text(title, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: Colors.black54))),
                ],
              ),
              const SizedBox(height: 12),
              Text(value, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w800)),
            ],
          ),
        ),
      ),
    );
  }
  Widget overviewCard(IconData icon, String title, String value) {
    return Expanded(
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 6),
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.black12,
              blurRadius: 6,
              offset: const Offset(0, 3),
            )
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(icon, color: successColor, size: 26),
                const SizedBox(width: 10),
                Expanded(child: Text(title, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600))),
              ],
            ),
            const SizedBox(height: 10),
            Text(value, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w700)),
          ],
        ),
      ),
    );
  }

  Widget quickActionTile(IconData icon, String title, Color color) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        gradient: LinearGradient(colors: [color, color.withOpacity(0.9)],
         begin: Alignment.topLeft, 
         end: Alignment.bottomRight),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          Icon(icon, color: Colors.white),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              title,
              style: const TextStyle(
                  color: Colors.white, fontWeight: FontWeight.w600),
            ),
          ),
        ],
      ),
    );
  }

  Widget quickActionTileGradient(IconData icon,
   String title, 
   Color c1,
    Color c2) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 18, horizontal: 16),
      decoration: BoxDecoration(
        gradient: LinearGradient(colors: [c1, c2], 
        begin: Alignment.topLeft, 
        end: Alignment.bottomRight),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.08), blurRadius: 12, offset: const Offset(0, 6))],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, color: Colors.white, size: 28),
          const SizedBox(height: 10),
          Text(title, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w600)),
        ],
      ),
    );
  }

  Widget transactionCard(String customer, String invoice, String status, String date, String amount) {
  Color statusColor = successColor;
  if (status.toLowerCase().contains('pend')) statusColor = warningColor;
  if (status.toLowerCase().contains('fail')) statusColor = errorColor;

  final displayAmount = amount.replaceAll(',', '');

  return Container(
    margin: const EdgeInsets.only(bottom: 14),
    padding: const EdgeInsets.all(16),
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(18),
      border: Border.all(color: accentLightColor.withOpacity(0.08)),
      boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.03), blurRadius: 4, offset: const Offset(0, 6))],
    ),
    child: Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            color: statusColor,
            border: Border.all(color: Colors.white, width: 2),
          ),
          child: Center(
            child: Text(
              customer.isNotEmpty ? customer[0].toUpperCase() : '?',
              style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
            ),
          ),
        ),
        const SizedBox(width: 14),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(customer, style: const TextStyle(fontWeight: FontWeight.w700)),
                  Text(displayAmount, style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 16, color: Colors.black87)),
                ],
              ),
              const SizedBox(height: 6),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                decoration: BoxDecoration(
                  color: statusColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(18),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      status.toLowerCase().contains('com') ? Icons.check : (status.toLowerCase().contains('pend') ? Icons.access_time : Icons.error),
                      size: 14,
                      color: statusColor,
                    ),
                    const SizedBox(width: 6),
                    Text(status.toUpperCase(), style: TextStyle(color: statusColor, fontSize: 12, fontWeight: FontWeight.w600)),
                  ],
                ),
              ),
              const SizedBox(height: 12),
              Container(
                height: 44,
                decoration: BoxDecoration(
                  color: statusColor.withOpacity(0.06),
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.02), blurRadius: 6, offset: const Offset(0, 4))],
                ),
                padding: const EdgeInsets.symmetric(horizontal: 12),
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(6),
                      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(6)),
                      child: Icon(Icons.receipt_long, color: statusColor, size: 16),
                    ),
                    const SizedBox(width: 12),
                    Expanded(child: Text(invoice, style: const TextStyle(color: Colors.black54, fontWeight: FontWeight.w600))),
                    const SizedBox(width: 10),
                    Row(children: [
                      const Icon(Icons.calendar_today, size: 14, color: Colors.black38),
                      const SizedBox(width: 6),
                      Text(date, style: const TextStyle(color: Colors.black45, fontSize: 12)),
                    ]),
                  ],
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


class StoreAdminController extends GetxController {
  var todaySale = 25450.obs;
  var dueAmount = 12350.obs;
  var totalItems = 156.obs;
  var customers = 45.obs;

  var transactions = [
    {
      "customer": "Customer 1",
      "invoice": "INV-1234",
      "status": "Completed",
      "amount": "₹25,450",
      "date": "23 Dec, 2024"
    },
    {
      "customer": "Customer 2",
      "invoice": "INV-1235",
      "status": "Pending",
      "amount": "₹26,450",
      "date": "23 Dec, 2024"
    },
    {
      "customer": "Customer 3",
      "invoice": "INV-1236",
      "status": "Failed",
      "amount": "₹27,450",
      "date": "23 Dec, 2024"
    },
  ].obs;
}
