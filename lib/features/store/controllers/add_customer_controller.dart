import 'package:flutter/material.dart';
import 'package:green_biller/features/store/services/add_customer_service.dart';

class AddCustomerController {
  String accessToken;
  int storeId;
  String userId;
  String name;
  String phone;
  String email;
  String address;
  String gstin;
  String userName;
  VoidCallback? onSuccess;
  AddCustomerController({
    required this.accessToken,
    required this.storeId,
    required this.userId,
    required this.name,
    required this.phone,
    required this.email,
    required this.address,
    required this.gstin,
    required this.userName,
    required this.onSuccess,
  });

  Future<String> addCustomerController(BuildContext context) async {
    final response = AddCustomerService(
      accessToken: accessToken,
      storeId: storeId,
      userId: userId,
      name: name,
      phone: phone,
      email: email,
      address: address,
      gstin: gstin,
      userName: userName,
    );
    final result = await response.addCustomerService();
    if (result == "Customer added successfully") {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Customer added successfully"),
          backgroundColor: Colors.green,
        ),
      );
      onSuccess?.call();
      return "Customer added successfully";
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(result.toString()),
          backgroundColor: Colors.red,
        ),
      );
      return result;
    }
  }
}
