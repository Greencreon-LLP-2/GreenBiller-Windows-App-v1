import 'dart:developer';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:green_biller/core/constants/colors.dart';
import 'package:green_biller/core/funtions/pdf_second_design.dart';
import 'package:green_biller/core/theme/text_styles.dart';
import 'package:open_file/open_file.dart';
import 'package:printing/printing.dart';

class SaleCompletionPage extends StatelessWidget {
  final String invoiceNumber;
  final double amount;

  const SaleCompletionPage({
    super.key,
    required this.invoiceNumber,
    required this.amount,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        backgroundColor: primaryColor,
        title: const Text("Sale Complete", style: AppTextStyles.h3),
        leading: IconButton(
          icon: const Icon(Icons.close),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: Column(
        children: [
          _buildSuccessHeader(),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  _buildInvoiceDetails(),
                  const SizedBox(height: 24),
                  _buildActionSection(
                    "Payment Options",
                    [
                      ActionItem(
                        icon: Icons.payment,
                        title: "Collect Payment",
                        subtitle: "Record payment for this invoice",
                        onTap: () {
                          // Navigate to payment collection
                        },
                      ),
                      ActionItem(
                        icon: Icons.account_balance_wallet,
                        title: "Add to Credit",
                        subtitle: "Convert to credit sale",
                        onTap: () {
                          // Handle credit conversion
                        },
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),
                  _buildActionSection(
                    "Document Options",
                    [
                      ActionItem(
                        icon: Icons.print,
                        title: "Print Invoice",
                        subtitle: "Print physical copy",
                        onTap: () async {
                          final file = await pdfFormatSecond(
                            otherCharges: 0,
                            totalDiscount: 0,
                            shopName: 'Shop Name',
                            shopAddress: 'Shop Address',
                            shopContact: 'Shop Contact',
                            shopEmail: 'Shop Email',
                            shopState: 'Shop State',
                            invoiceNo: invoiceNumber,
                            invoiceDate: DateTime.now(),
                            website: 'Website',
                            amountInWords: 'Amount in Words',
                            terms: 'Terms',
                            received: amount,
                            subtotal: amount,
                            total: amount,
                            balance: amount,
                            customerName: 'Customer Name',
                            paymentMode: 'Payment Mode',
                            items: [
                              // {
                              //   'serialNo': '001',
                              //   'name': 'Item 1',
                              //   'description': 'GDEVYEWSDHVHYH121 ' 'SGVDCTHVVHSHDAEHJ12 ' 'AEFVVFYVWEVHYEWFV143 ' 'VTGEDSUYEWYWEY322 ' 'GHVEDWCHUJSYBCSD123',
                              //   'hsn': '998391',
                              //   'qty': 1,
                              //   'unit': 'Pcs',
                              //   'price': amount,
                              //   'discount': 0.0,
                              //   'tax': 18.0,
                              //   'taxAmount': amount * 0.18,
                              //   'total': amount,
                              // },
                              // {
                              //   'serialNo': '001',
                              //   'name': 'Item 1',
                              //   'description': 'GDEVYEWSDHVHYH121 ' 'SGVDCTHVVHSHDAEHJ12 ' 'AEFVVFYVWEVHYEWFV143 ' 'VTGEDSUYEWYWEY322 ' 'GHVEDWCHUJSYBCSD123',
                              //   'hsn': '998391',
                              //   'qty': 1,
                              //   'unit': 'Pcs',
                              //   'price': amount,
                              //   'discount': 0.0,
                              //   'tax': 18.0,
                              //   'taxAmount': amount * 0.18,
                              //   'total': amount,
                              // },
                              // {
                              //   'serialNo': '001',
                              //   'name': 'Item 1',
                              //   'description': 'GDEVYEWSDHVHYH121 ' 'SGVDCTHVVHSHDAEHJ12 ' 'AEFVVFYVWEVHYEWFV143 ' 'VTGEDSUYEWYWEY322 ' 'GHVEDWCHUJSYBCSD123',
                              //   'hsn': '998391',
                              //   'qty': 1,
                              //   'unit': 'Pcs',
                              //   'price': amount,
                              //   'discount': 0.0,
                              //   'tax': 18.0,
                              //   'taxAmount': amount * 0.18,
                              //   'total': amount,
                              // },
                              // {
                              //   'serialNo': '001',
                              //   'name': 'Item 1',
                              //   'description': 'GDEVYEWSDHVHYH121 ' 'SGVDCTHVVHSHDAEHJ12 ' 'AEFVVFYVWEVHYEWFV143 ' 'VTGEDSUYEWYWEY322 ' 'GHVEDWCHUJSYBCSD123',
                              //   'hsn': '998391',
                              //   'qty': 1,
                              //   'unit': 'Pcs',
                              //   'price': amount,
                              //   'discount': 0.0,
                              //   'tax': 18.0,
                              //   'taxAmount': amount * 0.18,
                              //   'total': amount,
                              // },
                              // {
                              //   'serialNo': '001',
                              //   'name': 'Item 1',
                              //   'description': 'GDEVYEWSDHVHYH121 ' 'SGVDCTHVVHSHDAEHJ12 ' 'AEFVVFYVWEVHYEWFV143 ' 'VTGEDSUYEWYWEY322 ' 'GHVEDWCHUJSYBCSD123',
                              //   'hsn': '998391',
                              //   'qty': 1,
                              //   'unit': 'Pcs',
                              //   'price': amount,
                              //   'discount': 0.0,
                              //   'tax': 18.0,
                              //   'taxAmount': amount * 0.18,
                              //   'total': amount,
                              // },
                              // {
                              //   'serialNo': '002',
                              //   'name': 'Item 2',
                              //   'description': 'Detailed description of Item 2',
                              //   'hsn': '998392',
                              //   'qty': 2,
                              //   'unit': 'Kg',
                              //   'price': amount / 2,
                              //   'discount': 5.0,
                              //   'tax': 12.0,
                              //   'taxAmount': (amount / 2) * 0.12,
                              //   'total': amount,
                              // },
                            ],
                            print: false,
                          );
                          String filePath = file.path;

                          if (Platform.isLinux) {
                            // Linux: use `lpr` command
                            final result = await Process.run('lpr', [filePath],
                                runInShell: true);
                            log("Linux print result: ${result.stdout}");
                            if (result.stderr != null &&
                                result.stderr.toString().isNotEmpty) {
                              log("Linux print error: ${result.stderr}");
                            }
                            //!============================================================================= windows printing
                          } else if (Platform.isWindows) {
                            try {
                              // Use printing package for better printer support
                              await Printing.layoutPdf(
                                onLayout: (_) => file.readAsBytes(),
                                name: 'Invoice #$invoiceNumber',
                              );

                              // Show success notification
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text('Document sent to printer'),
                                  backgroundColor: Colors.green,
                                ),
                              );
                            } catch (e) {
                              log("Windows print exception: $e");
                              // Show error notification
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text('Failed to print: $e'),
                                  backgroundColor: Colors.red,
                                ),
                              );
                            }
                          }
                        },
                      ),
                      ActionItem(
                        icon: Icons.share,
                        title: "Share PDF",
                        subtitle: "Share via WhatsApp, Email etc.",
                        onTap: () {
                          // Handle PDF sharing
                        },
                      ),
                      ActionItem(
                        icon: Icons.download,
                        title: "Download PDF",
                        subtitle: "Save invoice as PDF",
                        onTap: () async {
                          final file = await pdfFormatSecond(
                            otherCharges: 0,
                            totalDiscount: 0,
                            shopName: 'Shop Name',
                            shopAddress: 'Shop Address',
                            shopContact: 'Shop Contact',
                            shopEmail: 'Shop Email',
                            shopState: 'Shop State',
                            invoiceNo: invoiceNumber,
                            invoiceDate: DateTime.now(),
                            website: 'Website',
                            amountInWords: 'Amount in Words',
                            terms: 'Terms',
                            received: amount,
                            subtotal: amount,
                            total: amount,
                            balance: amount,
                            customerName: 'Customer Name',
                            paymentMode: 'Payment Mode',
                            items: [
                              //   {
                              //   'serialNo': '001',
                              //   'name': 'Item 1',
                              //   'description': 'GDEVYEWSDHVHYH121 ' 'SGVDCTHVVHSHDAEHJ12 ' 'AEFVVFYVWEVHYEWFV143 ' 'VTGEDSUYEWYWEY322 ' 'GHVEDWCHUJSYBCSD123',
                              //   'hsn': '998391',
                              //   'qty': 1,
                              //   'unit': 'Pcs',
                              //   'price': amount,
                              //   'discount': 0.0,
                              //   'tax': 18.0,
                              //   'taxAmount': amount * 0.18,
                              //   'total': amount,
                              // },
                              // {
                              //   'serialNo': '001',
                              //   'name': 'Item 1',
                              //   'description': 'GDEVYEWSDHVHYH121 ' 'SGVDCTHVVHSHDAEHJ12 ' 'AEFVVFYVWEVHYEWFV143 ' 'VTGEDSUYEWYWEY322 ' 'GHVEDWCHUJSYBCSD123',
                              //   'hsn': '998391',
                              //   'qty': 1,
                              //   'unit': 'Pcs',
                              //   'price': amount,
                              //   'discount': 0.0,
                              //   'tax': 18.0,
                              //   'taxAmount': amount * 0.18,
                              //   'total': amount,
                              // },
                              // {
                              //   'serialNo': '001',
                              //   'name': 'Item 1',
                              //   'description': 'GDEVYEWSDHVHYH121 ' 'SGVDCTHVVHSHDAEHJ12 ' 'AEFVVFYVWEVHYEWFV143 ' 'VTGEDSUYEWYWEY322 ' 'GHVEDWCHUJSYBCSD123',
                              //   'hsn': '998391',
                              //   'qty': 1,
                              //   'unit': 'Pcs',
                              //   'price': amount,
                              //   'discount': 0.0,
                              //   'tax': 18.0,
                              //   'taxAmount': amount * 0.18,
                              //   'total': amount,
                              // },
                              // {
                              //   'serialNo': '001',
                              //   'name': 'Item 1',
                              //   'description': 'GDEVYEWSDHVHYH121 ' 'SGVDCTHVVHSHDAEHJ12 ' 'AEFVVFYVWEVHYEWFV143 ' 'VTGEDSUYEWYWEY322 ' 'GHVEDWCHUJSYBCSD123',
                              //   'hsn': '998391',
                              //   'qty': 1,
                              //   'unit': 'Pcs',
                              //   'price': amount,
                              //   'discount': 0.0,
                              //   'tax': 18.0,
                              //   'taxAmount': amount * 0.18,
                              //   'total': amount,
                              // },
                              // {
                              //   'serialNo': '001',
                              //   'name': 'Item 1',
                              //   'description': 'GDEVYEWSDHVHYH121 ' 'SGVDCTHVVHSHDAEHJ12 ' 'AEFVVFYVWEVHYEWFV143 ' 'VTGEDSUYEWYWEY322 ' 'GHVEDWCHUJSYBCSD123',
                              //   'hsn': '998391',
                              //   'qty': 1,
                              //   'unit': 'Pcs',
                              //   'price': amount,
                              //   'discount': 0.0,
                              //   'tax': 18.0,
                              //   'taxAmount': amount * 0.18,
                              //   'total': amount,
                              // },
                              // {
                              //   'serialNo': '002',
                              //   'name': 'Item 2',
                              //   'description': 'Detailed description of Item 2',
                              //   'hsn': '998392',
                              //   'qty': 2,
                              //   'unit': 'Kg',
                              //   'price': amount / 2,
                              //   'discount': 5.0,
                              //   'tax': 12.0,
                              //   'taxAmount': (amount / 2) * 0.12,
                              //   'total': amount,
                              // },
                            ],
                            print: true,
                          );
                          await OpenFile.open(file.path);
                        },
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          _buildBottomBar(context),
        ],
      ),
    );
  }

  Widget _buildSuccessHeader() {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: successColor.withOpacity(0.1),
        borderRadius: const BorderRadius.only(
          bottomLeft: Radius.circular(24),
          bottomRight: Radius.circular(24),
        ),
      ),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: successColor.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.check_circle_outline,
              color: successColor,
              size: 48,
            ),
          ),
          const SizedBox(height: 16),
          Text(
            "₹ $amount",
            style: const TextStyle(
              fontSize: 32,
              fontWeight: FontWeight.bold,
              color: textPrimaryColor,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            "Invoice #$invoiceNumber",
            style: const TextStyle(
              fontSize: 16,
              color: textSecondaryColor,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInvoiceDetails() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 5,
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Invoice Details",
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: textPrimaryColor,
            ),
          ),
          const SizedBox(height: 16),
          _buildDetailRow("Status", "Unpaid"),
          _buildDetailRow("Due Amount", "₹ $amount"),
          _buildDetailRow("Date", "Today"),
        ],
      ),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: const TextStyle(
              color: textSecondaryColor,
              fontSize: 14,
            ),
          ),
          Text(
            value,
            style: const TextStyle(
              color: textPrimaryColor,
              fontSize: 14,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionSection(String title, List<ActionItem> actions) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: textPrimaryColor,
          ),
        ),
        const SizedBox(height: 16),
        ...actions.map((action) => _buildActionCard(action)),
      ],
    );
  }

  Widget _buildActionCard(ActionItem action) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.all(16),
        leading: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: accentColor.withOpacity(0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(action.icon, color: accentColor),
        ),
        title: Text(
          action.title,
          style: const TextStyle(
            fontWeight: FontWeight.w500,
            color: textPrimaryColor,
          ),
        ),
        subtitle: Text(
          action.subtitle,
          style: const TextStyle(
            color: textSecondaryColor,
            fontSize: 12,
          ),
        ),
        onTap: action.onTap,
      ),
    );
  }

  Widget _buildBottomBar(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: cardColor,
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 5,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: ElevatedButton(
        onPressed: () => Navigator.of(context).pop(),
        style: ElevatedButton.styleFrom(
          backgroundColor: accentColor,
          padding: const EdgeInsets.symmetric(vertical: 12),
        ),
        child: const Text(
          "Done",
          style: TextStyle(
            color: Colors.white,
            fontSize: 16,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
    );
  }
}

class ActionItem {
  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback onTap;

  ActionItem({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.onTap,
  });
}
