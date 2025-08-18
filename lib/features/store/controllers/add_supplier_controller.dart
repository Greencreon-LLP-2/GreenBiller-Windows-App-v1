import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:green_biller/features/store/services/add_supplier_service.dart';

class AddSupplierController {
  final AddSupplierService addSupplierService = AddSupplierService();

  String accessToken;
  int storeId;
  String name;
  String phone;
  String email;
  String address;
  String gstin;

  AddSupplierController(
      {required this.accessToken,
      required this.storeId,
      required this.name,
      required this.phone,
      required this.email,
      required this.address,
      required this.gstin});

  Future<void> addSupplierController(
      BuildContext context, VoidCallback? onSuccess) async {
    try {
      final response = await addSupplierService.addSupplierService(
          accessToken, storeId, name, phone, email, address, gstin);
      if (response == "Supplier added successfully") {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("Supplier added successfully"),
            backgroundColor: Colors.green,
          ),
        );
        onSuccess?.call();
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(response),
            backgroundColor: Colors.red,
          ),
        );
      }
    } catch (e) {
      log(e.toString());
      throw Exception(e);
    }
  }
}
