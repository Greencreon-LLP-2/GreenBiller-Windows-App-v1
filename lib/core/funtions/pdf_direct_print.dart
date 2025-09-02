// else if (Platform.isWindows) {
//                             try {
//                               // Use printing package for better printer support
//                               await Printing.layoutPdf(
//                                 onLayout: (_) => file.readAsBytes(),
//                                 name: 'Invoice #$invoiceNumber',
//                               );
                              
//                               // Show success notification
//                               ScaffoldMessenger.of(context).showSnackBar(
//                                 const SnackBar(
//                                   content: Text('Document sent to printer'),
//                                   backgroundColor: Colors.green,
//                                 ),
//                               );
//                             } catch (e) {
//                               log("Windows print exception: $e");
//                               // Show error notification
//                               ScaffoldMessenger.of(context).showSnackBar(
//                                 SnackBar(
//                                   content: Text('Failed to print: $e'),
//                                   backgroundColor: Colors.red,
//                                 ),
//                               );
//                             }
//                           }
