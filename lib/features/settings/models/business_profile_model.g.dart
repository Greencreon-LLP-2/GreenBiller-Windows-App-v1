// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'business_profile_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class BusinessProfileAdapter extends TypeAdapter<BusinessProfile> {
  @override
  final int typeId = 1;

  @override
  BusinessProfile read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return BusinessProfile(
      name: fields[0] as String,
      phone: fields[1] as String,
      tin: fields[2] as String?,
      email: fields[3] as String?,
      pincode: fields[4] as String?,
      address: fields[5] as String?,
      businessType: fields[6] as String?,
      category: fields[7] as String?,
      state: fields[8] as String?,
      gst: fields[9] as String?,
      profileImagePath: fields[10] as String?,
      signatureImagePath: fields[11] as String?,
      id: fields[12] as int?,
    );
  }

  @override
  void write(BinaryWriter writer, BusinessProfile obj) {
    writer
      ..writeByte(13)
      ..writeByte(0)
      ..write(obj.name)
      ..writeByte(1)
      ..write(obj.phone)
      ..writeByte(2)
      ..write(obj.tin)
      ..writeByte(3)
      ..write(obj.email)
      ..writeByte(4)
      ..write(obj.pincode)
      ..writeByte(5)
      ..write(obj.address)
      ..writeByte(6)
      ..write(obj.businessType)
      ..writeByte(7)
      ..write(obj.category)
      ..writeByte(8)
      ..write(obj.state)
      ..writeByte(9)
      ..write(obj.gst)
      ..writeByte(10)
      ..write(obj.profileImagePath)
      ..writeByte(11)
      ..write(obj.signatureImagePath)
      ..writeByte(12)
      ..write(obj.id);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is BusinessProfileAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
