// import 'package:flutter/material.dart';
// import 'package:green_biller/core/constants/colors.dart';
// import 'package:green_biller/core/widgets/card_container.dart';

// class PaymentOutPage extends StatelessWidget {
//   const PaymentOutPage({super.key});

//   @override
//   Widget build(BuildContext context) {
//     final isDesktop = MediaQuery.of(context).size.width > 600;
//     final padding = isDesktop ? 24.0 : 16.0;

//     return Scaffold(
//       backgroundColor: backgroundColor,
//       appBar: AppBar(
//         backgroundColor: accentColor,
//         elevation: 0,
//         // leading: IconButton(
//         //   onPressed: () => Navigator.pop(context),
//         //   icon: const Icon(Icons.arrow_back_ios,
//         //       color: Color.fromARGB(255, 0, 0, 0)),
//         // ),
//         title: const Text(
//           "Payment Out",
//           style: TextStyle(color: Colors.white,fontSize: 20,fontWeight: FontWeight.bold),
//         ),
//       ),
//       body: SingleChildScrollView(
//         padding: EdgeInsets.all(padding),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             _buildSectionTitle("Supplier Information"),
//             CardContainer(
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   _buildSearchSupplier(),
//                   const SizedBox(height: 16),
//                   _buildSupplierDetails(),
//                 ],
//               ),
//             ),
//             const SizedBox(height: 24),
//             _buildSectionTitle("Payment Details"),
//             CardContainer(
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   _buildPaymentFields(),
//                   const SizedBox(height: 16),
//                   _buildPaymentTypeDropdown(),
//                 ],
//               ),
//             ),
//             const SizedBox(height: 24),
//             _buildSectionTitle("Additional Information"),
//             CardContainer(
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   _buildAdditionalFields(),
//                 ],
//               ),
//             ),
//           ],
//         ),
//       ),
//       bottomNavigationBar: _buildBottomBar(context),
//     );
//   }

//   Widget _buildSectionTitle(String title) {
//     return Padding(
//       padding: const EdgeInsets.only(bottom: 8),
//       child: Text(
//         title,
//         style: const TextStyle(
//           fontSize: 18,
//           fontWeight: FontWeight.w600,
//           color: textPrimaryColor,
//         ),
//       ),
//     );
//   }

//   Widget _buildSearchSupplier() {
//     return Row(
//       children: [
//         Expanded(
//           child: TextField(
//             decoration: InputDecoration(
//               hintText: 'Search supplier...',
//               prefixIcon: const Icon(Icons.search),
//               border: OutlineInputBorder(
//                 borderRadius: BorderRadius.circular(8),
//                 borderSide: const BorderSide(color: textLightColor),
//               ),
//               enabledBorder: OutlineInputBorder(
//                 borderRadius: BorderRadius.circular(8),
//                 borderSide: const BorderSide(color: textLightColor),
//               ),
//               focusedBorder: OutlineInputBorder(
//                 borderRadius: BorderRadius.circular(8),
//                 borderSide: const BorderSide(color: accentColor),
//               ),
//             ),
//           ),
//         ),
//         const SizedBox(width: 16),
//         ElevatedButton.icon(
//           onPressed: () {

//           },
//           icon: const Icon(Icons.person_add),
//           label: const Text('New Supplier'),
//           style: ElevatedButton.styleFrom(
//             backgroundColor: accentColor,
//             foregroundColor: Colors.white,
//             padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
//             shape: RoundedRectangleBorder(
//               borderRadius: BorderRadius.circular(8),
//             ),
//           ),
//         ),
//       ],
//     );
//   }

//   Widget _buildSupplierDetails() {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         _buildInfoRow(Icons.person, 'Supplier Name', 'Acme Supplies'),
//         const SizedBox(height: 12),
//         _buildInfoRow(Icons.phone, 'Phone Number', '+91 9876543210'),
//         const SizedBox(height: 12),
//         _buildInfoRow(Icons.email, 'Email', 'contact@acmesupplies.com'),
//       ],
//     );
//   }

//   Widget _buildInfoRow(IconData icon, String label, String value) {
//     return Row(
//       children: [
//         Icon(icon, size: 20, color: textSecondaryColor),
//         const SizedBox(width: 12),
//         Text(
//           label,
//           style: const TextStyle(
//             color: textSecondaryColor,
//             fontSize: 14,
//           ),
//         ),
//         const SizedBox(width: 8),
//         Text(
//           value,
//           style: const TextStyle(
//             color: textPrimaryColor,
//             fontSize: 14,
//             fontWeight: FontWeight.w500,
//           ),
//         ),
//       ],
//     );
//   }

//   Widget _buildPaymentFields() {
//     return Column(
//       children: [
//         _buildAmountField('Total Due', '₹ 30,000', isReadOnly: true),
//         const SizedBox(height: 12),
//         _buildAmountField('Amount Paid', '₹ 0'),
//         const SizedBox(height: 12),
//         _buildAmountField('Balance', '₹ 30,000',
//             isNegative: true, isReadOnly: true),
//       ],
//     );
//   }

//   Widget _buildAmountField(String label, String value,
//       {bool isReadOnly = false, bool isNegative = false}) {
//     return Row(
//       children: [
//         Expanded(
//           flex: 2,
//           child: Text(
//             label,
//             style: const TextStyle(
//               fontSize: 16,
//               color: textPrimaryColor,
//             ),
//           ),
//         ),
//         Expanded(
//           flex: 3,
//           child: Container(
//             padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
//             decoration: BoxDecoration(
//               color: isReadOnly ? Colors.grey.shade100 : Colors.white,
//               border: Border.all(color: textLightColor),
//               borderRadius: BorderRadius.circular(8),
//             ),
//             child: Text(
//               value,
//               style: TextStyle(
//                 fontSize: 16,
//                 fontWeight: FontWeight.w500,
//                 color: isNegative ? errorColor : textPrimaryColor,
//               ),
//             ),
//           ),
//         ),
//       ],
//     );
//   }

//   Widget _buildPaymentTypeDropdown() {
//     return Row(
//       children: [
//         const Expanded(
//           flex: 2,
//           child: Text(
//             'Payment Type',
//             style: TextStyle(
//               fontSize: 16,
//               color: textPrimaryColor,
//             ),
//           ),
//         ),
//         Expanded(
//           flex: 3,
//           child: Container(
//             padding: const EdgeInsets.symmetric(horizontal: 12),
//             decoration: BoxDecoration(
//               border: Border.all(color: textLightColor),
//               borderRadius: BorderRadius.circular(8),
//             ),
//             child: DropdownButton<String>(
//               value: 'Cash',
//               isExpanded: true,
//               underline: const SizedBox(),
//               items: const [
//                 DropdownMenuItem(value: 'Cash', child: Text('Cash')),
//                 DropdownMenuItem(value: 'Card', child: Text('Card')),
//                 DropdownMenuItem(value: 'Cheque', child: Text('Cheque')),
//                 DropdownMenuItem(value: 'UPI', child: Text('UPI')),
//                 DropdownMenuItem(value: 'Credit', child: Text('Credit')),
//               ],
//               onChanged: (value) {},
//             ),
//           ),
//         ),
//       ],
//     );
//   }

//   Widget _buildAdditionalFields() {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         const Text(
//           'Notes',
//           style: TextStyle(
//             fontSize: 16,
//             color: textPrimaryColor,
//           ),
//         ),
//         const SizedBox(height: 8),
//         TextField(
//           maxLines: 3,
//           decoration: InputDecoration(
//             hintText: 'Add any additional notes here...',
//             border: OutlineInputBorder(
//               borderRadius: BorderRadius.circular(8),
//               borderSide: const BorderSide(color: textLightColor),
//             ),
//             enabledBorder: OutlineInputBorder(
//               borderRadius: BorderRadius.circular(8),
//               borderSide: const BorderSide(color: textLightColor),
//             ),
//             focusedBorder: OutlineInputBorder(
//               borderRadius: BorderRadius.circular(8),
//               borderSide: const BorderSide(color: accentColor),
//             ),
//           ),
//         ),
//         const SizedBox(height: 16),
//         const Text(
//           'Attachment',
//           style: TextStyle(
//             fontSize: 16,
//             color: textPrimaryColor,
//           ),
//         ),
//         const SizedBox(height: 8),
//         Container(
//           height: 120,
//           decoration: BoxDecoration(
//             border: Border.all(color: textLightColor),
//             borderRadius: BorderRadius.circular(8),
//           ),
//           child: Center(
//             child: Column(
//               mainAxisAlignment: MainAxisAlignment.center,
//               children: [
//                 Icon(
//                   Icons.cloud_upload,
//                   size: 32,
//                   color: Colors.grey.shade400,
//                 ),
//                 const SizedBox(height: 8),
//                 Text(
//                   'Click to upload attachment',
//                   style: TextStyle(
//                     color: Colors.grey.shade400,
//                     fontSize: 14,
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         ),
//       ],
//     );
//   }

//   Widget _buildBottomBar(BuildContext context) {
//     return Container(
//       padding: const EdgeInsets.all(16),
//       decoration: BoxDecoration(
//         color: cardColor,
//         boxShadow: [
//           BoxShadow(
//             color: Colors.grey.withOpacity(0.1),
//             spreadRadius: 1,
//             blurRadius: 5,
//             offset: const Offset(0, -2),
//           ),
//         ],
//       ),
//       child: Row(
//         children: [
//           Expanded(
//             child: TextButton(
//               onPressed: () => Navigator.pop(context),
//               style: TextButton.styleFrom(
//                 padding: const EdgeInsets.symmetric(vertical: 12),
//                 shape: RoundedRectangleBorder(
//                   borderRadius: BorderRadius.circular(8),
//                 ),
//               ),
//               child: const Text(
//                 "Cancel",
//                 style: TextStyle(
//                   color: errorColor,
//                   fontSize: 16,
//                   fontWeight: FontWeight.w500,
//                 ),
//               ),
//             ),
//           ),
//           const SizedBox(width: 16),
//           Expanded(
//             flex: 2,
//             child: ElevatedButton(
//               onPressed: () {},
//               style: ElevatedButton.styleFrom(
//                 backgroundColor: accentColor,
//                 foregroundColor: Colors.white,
//                 padding: const EdgeInsets.symmetric(vertical: 12),
//                 shape: RoundedRectangleBorder(
//                   borderRadius: BorderRadius.circular(8),
//                 ),
//               ),
//               child: const Text(
//                 "Save Payment",
//                 style: TextStyle(
//                   fontSize: 16,
//                   fontWeight: FontWeight.w500,
//                 ),
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }
