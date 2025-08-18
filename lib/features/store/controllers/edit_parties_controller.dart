import 'dart:developer';

import 'package:green_biller/features/store/services/edit_parties_services.dart';

class EditPartiesController {
  final String name;
  final String phone;
  final String email;
  final String address;
  final String gstin;
  final String accestoken;

  EditPartiesController({
    required this.name,
    required this.phone,
    required this.email,
    required this.address,
    required this.gstin,
    required this.accestoken,
  });

//*============================================== supplier update api call==============================================*//
  Future<String> editSupplierController(String supplierId) async {
    try {
      final response = await EditPartiesServices(
        name: name,
        phone: phone,
        email: email,
        address: address,
        gstin: gstin,
        accestoken: accestoken,
      ).editSupplierServices(supplierId);
      if (response == "Supplier updated successfully") {
        return 'Supplier updated successfully';
      } else {
        return 'Failed to update supplier';
      }
    } catch (e) {
      log(e.toString());
      return 'Failed to update supplier';
    }
  }

//*============================================== customer update api call==============================================*//

  Future<String> editCustomerController(String customerId) async {
    try {
      final response = await EditPartiesServices(
        name: name,
        phone: phone,
        email: email,
        address: address,
        gstin: gstin,
        accestoken: accestoken,

        //*============================================== curently customer id is passing here*//
      ).editCustomerServices(customerId);
      if (response == "Customer updated successfully") {
        return 'Customer updated successfully';
      } else {
        return 'Failed to update customer';
      }
    } catch (e) {
      log(e.toString());
      return 'Failed to update customer';
    }
  }
}
